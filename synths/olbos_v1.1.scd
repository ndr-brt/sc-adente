//Olbos' boot file template for Tidalcycles

//EFFECTS
//Diffract: an FFT effect that scales and shifts bins based on the PV_BinShift Ugen

(
~dirt.addModule('diffract', { |dirtEvent|
	dirtEvent.sendSynth('diffract' ++ ~dirt.numChannels,
		[
			diffract: ~diffract,
			diffshift: ~diffshift,
			diffmix: ~diffmix,
			out: ~out
		]
	)
}, { ~diffract.notNil or: {~diffshift.notNil or: {~diffmix.notNil}}})
);

(
SynthDef("diffract" ++ ~dirt.numChannels, { |out, diffract = 1,
	diffshift = 1, diffmix = 0.5|
	var signal, chain, drywet, clean;
	signal = In.ar(out, ~dirt.numChannels);
	clean = signal;
	chain = signal.asArray.collect { |x| FFT(LocalBuf([2048, 2048]), x) };
	chain = PV_BinShift(chain, diffract, diffshift, 1);
	chain = IFFT(chain);
	drywet = XFade2.ar(signal, chain, diffmix.linlin(0, 1, -1, 1));
	ReplaceOut.ar(out, drywet)
	}
  ).add
);

//Invert: an FFT spectral inverter. It may send out very high frequency sounds.
//It's suggested to apply a lo-pass filter around 5-10khz on Tidalcycles.
(
~dirt.addModule('invert', { |dirtEvent|
	dirtEvent.sendSynth('invert' ++ ~dirt.numChannels,
		[
			invert: ~invert,
			out: ~out
		]
	)
}, { ~invert.notNil})
);

(
SynthDef("invert" ++ ~dirt.numChannels, { |out, invert = 0.1|
	var signal, chain, drywet, clean;
	signal = In.ar(out, ~dirt.numChannels);
		clean = signal;
	chain = signal.asArray.collect { |x| FFT(LocalBuf([512, 512]), x) };
	chain = PV_Invert(chain);
	chain = IFFT(chain);
	drywet = XFade2.ar(signal, chain, invert.linlin(0, 1, -1, 1));
	ReplaceOut.ar(out, drywet)
	}
  ).add;
);


//Ringshape: a waveshaper + a diode ring modulator. It needs SC additional plugins to be installed.
//The only parameter is "ringshape": it controls the frequency of the ring modulator.
(
~dirt.addModule('ringshape', { |dirtEvent|
	dirtEvent.sendSynth('ringshape' ++ ~dirt.numChannels,
		[
			out: ~out,
			ringshape: ~ringshape
		]
	)
}, {~ringshape.notNil})
);

(
SynthDef("ringshape" ++ ~dirt.numChannels, { |out, ringshape|
	var signal;
	signal = In.ar(out, ~dirt.numChannels);
	signal = SineShaper.ar(signal, 0.7) * 0.85;
	signal = DiodeRingMod.ar(signal, SinOsc.ar(ringshape));
	signal = LPF.ar(signal, 10000);
	signal = LeakDC.ar(signal);
	ReplaceOut.ar(out, signal)
	}
).add
);

// A tanh limiter/distortion. It has a single parameter (tanh) that controls the gain multiplication before getting limited.
//You can exaggerate with this value (for instance, multiplying by 1000) and it will always keep the output range to +1 maximum.
//Anyway, due to a dramatically restricted dynamic in values >10~, it could be necessary to decrease the tidal gain function to keep the level similar to a dry condition.

(
~dirt.addModule('tanh', { |dirtEvent|
	dirtEvent.sendSynth('tanh' ++ ~dirt.numChannels,
		[
			tanh: ~tanh,
			out: ~out
		]
	)
}, {~tanh.notNil})
);

(
SynthDef("tanh" ++ ~dirt.numChannels, { |out, tanh|
	var signal;
	signal = In.ar(out, ~dirt.numChannels);
	signal = signal * tanh;
	signal = signal.tanh;
	ReplaceOut.ar(out, signal)
	}).add
);


//Tantanh: a distortion/limiter with extreme outcomes.
//The "tantanh" parameters controls the amount of distortion; over 5-8 there is a drastic change, than you can go up to 300 before getting into the complete noise territory.


(
~dirt.addModule('tantanh', { |dirtEvent|
	dirtEvent.sendSynth('tantanh' ++ ~dirt.numChannels,
		[
			tantanh: ~tantanh,
			out: ~out
		]
	)
}, {~tantanh.notNil})
);

(
SynthDef("tantanh" ++ ~dirt.numChannels, { |out, tantanh|
	var signal;
	signal = In.ar(out, ~dirt.numChannels);
	signal = signal * tantanh;
	signal = signal.tan.tanh;
	signal = LeakDC.ar(signal);
	ReplaceOut.ar(out, signal)
	}).add
);


// Binscr: a bin scramble fft processor synthdef written by Nesso

(
  ~dirt.addModule('binscr',
	{ |dirtEvent|
	    dirtEvent.sendSynth
		('binscr' ++ ~dirt.numChannels,
		      [
			  scr: ~scr,
			  smooth: ~smooth,
			  scry: ~scry,
			  out: ~out
			  ]
	    )
    }, { ~scr.notNil or: {~scry.notNil or: {~smooth.notNil}}})
);

(
 SynthDef("binscr" ++ ~dirt.numChannels,
	          { |out, scr = 0.1, scry = 0.1, smooth = 8|
		        var signal, chain;
		        smooth = smooth.clip(8, 13);
		        signal = In.ar(out, ~dirt.numChannels);
		        chain = signal.asArray.collect { |x| FFT(LocalBuf([(2.pow(smooth)), (2.pow(smooth))]), x) };
		        chain = PV_BinScramble(chain, scr, scry, scr > 0 );
		        chain = IFFT(chain);
		        //chain = chain + (signal * 0);
		        //drywet = XFade2.ar(signal, chain, invert.linlin(0, 1, -1, 1));
		        ReplaceOut.ar(out, chain);
	          }
           ).add;
);


//set the order of the effect chain as you wish

~dirt.orderModules(['sound', 'invert', 'diffract', 'binscr', 'vowel', 'ring', 'ringshape', 'tantanh', 'tanh']);


//SYNTHS



// Xenbass: a stochastic bass synthesizer based on the Gendy1 oscillator invented by Iannis Xenakis and Marie-Helene Serra and implemented on SC by Nick Collins. Works best with long decays due to its stochastic behavior. The depth control sets the range of frequency variation, high numbers determine chaotic pitch results.
(
SynthDef(\xenbass, {|out=0,pan=0,freq=440,tuning=19,attack=0.001,release=1,depth=1,sustain=1,begin=0,end=1,speed=1,accelerate=0|
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var env = Env.asr(attackTime: attack, releaseTime: release);
  var volume = IEnvGen.ar(env, line);
  var signal, freqenv;
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var note = basefreq.cpsmidi;
  var octave = ((note/tuning)-5).trunc(1);
  freq = [440 * (pow(2, octave)) * (pow(2, ((mod(note, tuning))/tuning)))];  //sets microtonal properties according to Guiot's technique
  freqenv = EnvGen.ar(Env([freq, freq * 6, freq], [attack, release], 'exp')); // filter envelope
  signal = Gendy1.ar(1, 5, 1, 1, freq, [freq + depth, freq + depth + 1 ], 0.5, 0.6, 6); // a Gendy1 oscillator
  signal = LPF.ar(signal, freqenv); // applies filter and amplitude envelope to the oscillator
  signal = LeakDC.ar(signal); //remove DC Offset
  signal = Mix.ar(signal);

  Out.ar(out, DirtPan.ar(signal * volume, ~dirt.numChannels, pan));
}).add;
);

//Xenharp: a stochastic synth useful for arpy, high freq sounds with moderately long decays. It is based on the Gendy1 oscillator invented by Iannis Xenakis and Marie-Helene Serra and implemented on SC by Nick Collins. The depth control sets the range of frequency variation, high numbers determine chaotic pitch results.

(
SynthDef(\xenharp, { arg out, pan, freq = 440, tuning = 19, attack = 0.001, release = 1, depth = 1, sustain=1, speed=1, accelerate=0;
	var signal, env, filterenv;
	var note = (freq * DirtFreqScale.kr(speed, accelerate, sustain)).cpsmidi;
	var octave = ((note/tuning)-5).trunc(1);
	freq = [440 * (pow(2, octave)) * (pow(2, ((mod(note, tuning))/tuning)))];  //sets microtonal properties according to Guiot's technique
	filterenv = EnvGen.ar(Env([freq, 10000, freq ], [attack, release], [-4, -1])); //filter envelope
	env = EnvGen.ar(Env([0.0001, 1, 0.0001], [attack, release], [-10, -1]), doneAction: 2); //amplitude envelope
	signal = Gendy1.ar(3, 5, 1, 1, [freq, freq + 1], [freq + depth + 0.5, freq + depth], 0.0005, 0.0005, 25); //oscillator
	signal = RLPF.ar(signal, filterenv, 0.95); // resonant filter with filter envelope
	signal = LeakDC.ar(signal * env); // applies amplitude envelope and a DC block
	signal = Mix.ar(signal); //necessary for panning
	Out.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env)); //configures the synth for Tidalcycles
}).add;
);

//Tubes: a physical-modelling of two tubes based on the TwoTube Ugen plugin. SynthDef developed with Nesso for the Ambix duo project.

(
SynthDef(\tubes, { |out=0, pan=0, depth=0.3, freq=440, detune=0, begin=0, end=1, sustain=1, speed=1, accelerate=0|
  var line = Line.ar(begin, end, sustain*(end-begin), doneAction: Done.freeSelf);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var f1 = basefreq.clip(3, 5000);
  var f2 = (basefreq.cpsmidi - detune).midicps.clip(3, 5000);
  var source = WhiteNoise.ar(0.5) * EnvGen.ar(Env([1,1,0],[(f1+f2)/SampleRate.ir,0.0]));
  var volume = IEnvGen.ar(Env.asr, line);
  var sig = TwoTube.ar(
    source,
    depth.linlin(0, 1, -1, 1),
    0.999,
    f1,
    f2
  );
  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, volume));
}).add;
);

// The Waveblender SynthDef, made of 4 buffers and a waveshaper
(
~tabelle = Buffer.allocConsecutive(4, s, 4096); //allocate buffers


~env1 = Env(                                                                   //creates the waveform
	[0.000001, 0.5, -0.5, 0.8, -0.8, 1, -1, 0.000001],  //defines segments
	[1, 0.75, 1.25, 0.75, 1.25, 0.5, 2],   //time values are relative and should be one less the number of segments
	[-5, -3, 8, -11, 20, -25, 4 ]);   //curvature factors, should be the same numer of time values

~sig1 = ~env1.asSignal(2048);  // converts the envelope into a Signal (which is not audio, but a collection of values)
~wt1 = ~sig1.asWavetable; //converts the signal into wavetable format, necessary to load into Osc UGen and related ones
~tabelle[0].loadCollection(~wt1); // loads the wavetable into the first buffer aka index of of our array of buffers


//create the second wavetable to interpolate it with the first one


~env2 = Env(                                                                   //creates the waveform
	[0.000001, 0.75, -0.35, 0.9, -0.25, 0.6, -0.8, 0.000001],  //defines segments
	[1, 1.5, 0.75, 0.25, 1.5, 0.75, 1.75],   //time values are relative and should be one less the number of segments
	[5, 3, -8, 11, -20, 25, -4 ]);   //curvature factors, should be the same numer of time values

~sig2 = ~env2.asSignal(2048);  // converts the envelope into a Signal (which is not audio, but a collection of values)
~wt2 = ~sig2.asWavetable; //converts the signal into wavetable format, necessary to load into Osc UGen and related ones
~tabelle[1].loadCollection(~wt2); // loads the wavetable into the buffer


//a third one


~env3 = Env(                                                                   //creates the waveform
	[0.000001, -0.25, 0.5, -0.75, 0.65, -1, 1, 0.000001],  //defines segments
	[0.75, 1, 1.5, 0.5, 1, 0.75, 1.75],   //time values are relative and should be one less the number of segments
	[5, -2, 10, -13, 15, -4, 9 ]);   //curvature factors, should be the same numer of time values

~sig3 = ~env3.asSignal(2048);  // converts the envelope into a Signal (which is not audio, but a collection of values)
~wt3 = ~sig3.asWavetable; //converts the signal into wavetable format, necessary to load into Osc UGen and related ones
~tabelle[2].loadCollection(~wt3); // loads the wavetable into the buffer


//a fourth one


~env4 = Env(                                                                   //creates the waveform
	[0.000001, 0.15, -0.75, 0.5, -0.35, 1, -1, 0.000001],  //defines segments
	[0.25, 1.5, 1, 0.25, 1.75, 0.25, 2.5],   //time values are relative and should be one less the number of segments
	[20, -0.5, 9, -15, 20, 8, -2.1 ]);   //curvature factors, should be the same numer of time values

~sig4 = ~env4.asSignal(2048);  // converts the envelope into a Signal (which is not audio, but a collection of values)
~wt4 = ~sig4.asWavetable; //converts the signal into wavetable format, necessary to load into Osc UGen and related ones
~tabelle[3].loadCollection(~wt4); // loads the wavetable into the buffer


//creates a waveshaper with high harmonics at random amplitudes


~forma = Env([-1, 1], [1], [0]).asSignal(2049);    //asSignal value should be a pow of two + 1
~segnale = (Signal.sineFill(2049, (0!3) ++ [0, 0, 0, 1, 1, 1].scramble, {rrand(0, 2pi)} !9) /4; );
~forma = ~forma + ~segnale;
~forma = ~forma.normalize;
~forma = ~forma.asWavetableNoWrap; //wavetablenowrap is necessary for waveshapers
~formashaping = Buffer.loadCollection(s, ~forma);

////The synthdef

SynthDef (  \waveblender, {
	|out, pan, note = 60, tuning = 19, depth = 1, attack = 0.001, release = 0.5, pos = 0|
	var sig, env, octave, freq, displace, bufnum;
	bufnum = ~tabelle[0].bufnum;
	octave = ((note/tuning)-5).trunc(1);
	freq = [440 * (pow(2, octave)) * (pow(2, ((mod(note, tuning))/tuning)))];  //sets microtonal properties according to Guiot's technique
	displace = depth.wrap(1, 20);  //limits depth range
	sig = VOsc.ar( EnvGen.ar(Env([bufnum, bufnum + pos.linlin(0, 1, 0, 3), bufnum], [attack, release])), //sets pos as a value to control the range of w avetable interpolation; interpolation is controlled by the amp envelope
		     [freq, freq + (0.1 * displace), freq -(0.1 * displace), freq + (0.3 * displace), freq -(0.3 * displace), freq + (0.5 * displace), freq - (0.5 * displace)]);  //creates several instances with small freq differences, controlled by depth
	sig = Splay.ar(sig);  //reduces multichannel osc to a stereo spatialized sound
	env = EnvGen.ar(Env([0.0001, 1, 0.0001], [attack, release], [5, -5]), doneAction: 2); //define amplitude envelope
	sig = sig * env;
	sig = Shaper.ar(~formashaping, sig); //adds waveshaping
	sig = LeakDC.ar(sig);  // avoids DC offset
	sig = Mix.ar(sig); //necessary for panning
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env)); //configures the synth for Tidalcycles
 }).add

 );
