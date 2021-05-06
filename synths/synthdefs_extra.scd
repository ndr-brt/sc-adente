//* taken from https://github.com/everythingwillbetakenaway/Synthdefs *//
(

SynthDef(\plastickystrings,{ |out=0, freq=440, lforate = 5900, lfowidth=0.01, pan, attack=0.4|
	var lfo = LFTri.ar(lforate, Rand(0,2.0));
	var signal = SinOsc.ar(freq*(1.0+(lfowidth*lfo)),0.5);
	var env = EnvGen.ar(Env.adsr(attack,0.0,1.0,1.0),1,doneAction:2);

	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\plucking, { | out=0, amp, freq=440, decay = 5, coef = 0.1, pan |
	var snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),

        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
        coef: coef);

	var env = EnvGen.kr(Env.linen(0, decay, 0), doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\pitchednoise, { | out=0, freq=440, amp=0.1,attack=0.01, sustain=0.1, decay=0.01,pan=0.0, bandwidth=100 |
	var env= EnvGen.ar(Env([0,1,1,0],[attack, sustain, decay]), doneAction:2);
	var source= WhiteNoise.ar(amp);
	var filter= BPF.ar(source*env, freq, bandwidth/freq);

	OffsetOut.ar(out, DirtPan.ar(filter, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\werkit, { | out=0, freq = 440, amp = 0.1, gate = 1, cutoff = 100, rq = 0.1, attack = 0.2, sustain=0.5, release=0.2, pan |
	var source = LFSaw.ar(Array.fill(16, { Rand(100, 200) }));
	var filter = BLowPass4.ar(source, freq, rq) * 0.1;
	var env = EnvGen.ar(Env.asr(attack, sustain, release), gate, doneAction: 2);
	var snd = (filter + (0.3 * filter.distort));
	snd = HPF.ar(snd, 100);
	snd = Splay.ar(snd);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\trianglewavebells,{ | out = 0, pan, freq = 440, amp = 1.0, gate = 1, att = 0.01, dec = 0.1, sus = 1, rel = 0.5, lforate = 10, lfowidth = 0.0, cutoff = 100, rq = 0.5 |

	var vibrato = SinOsc.ar(lforate, Rand(0, 2.0));
	var osc1 = Saw.ar(freq * (1.0 + (lfowidth * vibrato)), 0.75);
	var osc2 = Mix(LFTri.ar((freq.cpsmidi + [11.9, 12.1]).midicps));
	var filter = RHPF.ar((osc1 + (osc2 * 0.5)) * 0.5, cutoff, rq);
	var env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(filter, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\voicform, { | out=0, gate=1, freq=440, amp=0.25, voiceGain=0.25, noiseGain=0.2, sweepRate=0.01, pan = 0.0 |

	var voiced = Pulse.ar(freq, 0.1, voiceGain);
	var onezero = OneZero.ar(voiced, -0.9);
	var onepole = OnePole.ar(onezero, 0.97 - (amp*0.2));
	var noise = WhiteNoise.ar(noiseGain*0.1);
	var excitation = onepole + noise;

	var ffreqs = Control.names([\ffreq]).kr([770, 1153, 2450, 3140]);
	var fradii = Control.names([\bw]).kr([0.950, 0.970, 0.780, 0.8]);
	var famps = Control.names([\gain]).kr([1.0, 0.355, 0.0355, 0.011]);

	var filters = TwoPole.ar(excitation, Lag.kr(ffreqs, sweepRate), Lag.kr(fradii, sweepRate), Lag.kr(famps, sweepRate), amp);

	OffsetOut.ar(out, DirtPan.ar(filters, ~dirt.numChannels, pan));

}).add;

SynthDef(\synchronicity,{|out=0, freq=440, cutoff=8000, rq=0.2, pan=0, sustain=1, begin=0,end=1,speed=1,accelerate=0 |
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var env = Env.adsr;
  var volume = IEnvGen.ar(env, line);
  var sig;

  freq = max(0, freq * speed * (1 + (accelerate * line)));
  sig = BLowPass.ar(
    SyncSaw.ar(freq, EnvGen.ar(Env([1,5,1],[0.04,0.9])) * freq),
    cutoff,
    rq);

  Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
}).add;

SynthDef(\spook,{ |out=0, freq = 440, amp = 0.1, gate=1, cutoff=8000, rq=0.2, lfowidth=0.01, lforate=3.8, pan|
	var lfo = LFTri.kr(lforate,Rand(0,2.0)!2);
	var pulse = Mix(Saw.ar(freq*[1,1.001]*[1.0,1.0+(lfowidth*lfo)]))*0.5;
	var filter = BHiPass.ar(pulse,cutoff,rq, amp);
	var env = EnvGen.ar(Env.adsr(0.1,0.0,1.0,3),gate,doneAction:2);

	OffsetOut.ar(out, DirtPan.ar(filter, ~dirt.numChannels, pan, env));

}).add;

SynthDef(\spook2,{ |out= 0, freq = 440, amp = 0.1, gate=1, cutoff=8000, rq=0.2, pan=0.0|

	var filter, env;
	var lfo = LFTri.kr([3.5,5],Rand(0,2.0)!2);
	var pulsewidthlfo = SinOsc.kr(4.5);
	var saw = Saw.ar(freq*(1.0+(0.052*lfo[0])));
	var pulse = Pulse.ar(freq*(1.0+(0.072*lfo[1])),pulsewidthlfo*0.25+0.5);

	//combine, equal mix
	pulse = 0.5*(saw+pulse);

	//filter specification not the clearest, so just going for slow attack to brightness
	filter = BLowPass.ar(pulse,XLine.kr(678,cutoff,0.378),rq, amp);

	env = EnvGen.ar(Env.adsr(0.1,0.0,1.0,3),gate,doneAction:2);

	OffsetOut.ar(out, DirtPan.ar(filter, ~dirt.numChannels, pan, env));

}).add;

SynthDef(\sosbell, { |freq=440, out=0, amp=0.1, pan=0|
	var strike, hum;

	// Stretched harmonic series
	var son = SinOsc.ar(#[2, 3, 4.1, 5.43, 6.8, 8.21] * freq, 0,
		#[1, 0.9, 0.8, 0.7, 0.6, 0.5] * 0.1);

	son = son * EnvGen.ar(Env.new([0,1,0.3, 0.2, 0], [0, 0.3, 0.3, 0.3]));

	// A bit of FM adds 'warble'
	son = son * LFTri.ar({Rand(1.0, 1.8)}.dup(6), 1, 0.3, 0.7);

	// Mix down the partials in the main sound
	son = son.mean;

	strike = SinOsc.ar(LFNoise1.ar(freq * 36, 100, freq*8), 1, 0.1) * EnvGen.ar(Env.new([0,1,0.2, 0.1, 0], [0, 0.01, 0, 0.04]));

	hum = SinOsc.ar([freq*1.01, freq*0.47], 0, EnvGen.ar(Env.new([0,0.05,0.05,0], [0.5,0.5,1]), doneAction:2)).mean;

	OffsetOut.ar(out, DirtPan.ar((son + strike + hum) * 4 * amp, ~dirt.numChannels, pan));

}).add;

SynthDef(\apad, { | freq=880, amp=0.5, attack=0.4, decay=0.5, sustain=0.8, release=0.4, gate=1.0, out=0, pan=0.0 |
	var env=EnvGen.kr(Env.asr(attack,sustain,release),gate,levelScale:amp,doneAction:2);
	var mod1=SinOsc.kr(6).range(freq*0.99,freq*1.01);
	var mod2=LFNoise2.kr(1).range(0.2,1);
	var mod3=SinOsc.kr(rrand(4.0,6.0)).range(0.5,1);
	var sig=SinOsc.ar([freq,mod1],0,env).distort;
	sig=sig*mod2*mod3;

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\babbl, { |out=0, amp=0.1, pan=0.0|
	var son =
	    ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 14) * 400 + 500, 0.03, 0.003)}!2)
	    + ({RHPF.ar(OnePole.ar(BrownNoise.ar, 0.99), LPF.ar(BrownNoise.ar, 20)* 800 + 1000, 0.03, 0.005)}!2) * 4;

	OffsetOut.ar(out, DirtPan.ar(son * (amp * 20), ~dirt.numChannels, pan))
}).add;

SynthDef(\bbdd, { | out=0, pan=0.0, freq=440 |
	var osc = FSinOsc.ar(freq);
	var env = EnvGen.ar(Env.perc(0, 0.55), doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(osc, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\beating, {arg freq = 440, amp = 0.1, art = 1, pan = 0.0;
	var env = EnvGen.ar(Env.perc(0.01, art), doneAction: 2);
	var snd1 = SinOsc.ar(freq);
	var snd2 = SinOsc.ar(Line.kr(freq+15, freq, art));

	OffsetOut.ar(0, DirtPan.ar(Mix([snd1 , snd2]), ~dirt.numChannels, pan, env))
}).add;

SynthDef(\blips1, {arg out = 0, freq = 25, numharm = 10, att = 0.01, rel = 1, amp = 0.1, pan = 0.5;
	var env = Env.perc(att, rel, amp).kr(doneAction: 2);
	var snd = LeakDC.ar(Mix(Blip.ar([freq, freq*1.01], numharm)));

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\blowbotl, { | out=0, amp=1.0, freq= 20, rq=0.1, gate=1, noise=0.1, vibFreq=5.2, vibGain=0.9, pan=0.0 |
	var lastOut = LocalIn.ar(1);
	var env = EnvGen.ar(Env.adsr(0.005, 0.01, 1.0, 0.010), gate, doneAction: 2);
	var vibrato = SinOsc.ar(vibFreq, 0, vibGain);
	var pressureDiff = vibrato - lastOut;
	var jet = (pressureDiff * (pressureDiff.squared - 1.0)).clip2(1.0);
	var randPressure = WhiteNoise.ar(noise)*(1.0 + pressureDiff);

	var resonator = Resonz.ar(randPressure - (jet*pressureDiff), freq, rq) * 4;
	LocalOut.ar(resonator);

	OffsetOut.ar(out, DirtPan.ar(LeakDC.ar(resonator), ~dirt.numChannels, pan, env))
}).add;

SynthDef(\cymbal808_ryan, { | out=0, baseFreq = 300, time = 250, amp=0.1, pan=0.0 |
	var freqs = [205.35, 304.41, 369.64, 522.71, 540.54, 812.21];
	var env = EnvGen.ar(Env.new([0, 1, 0.4, 0, 0], [2, time, 50, 500], [0, -0.5, 0, -50]), timeScale:(1/1000), doneAction:2);
	var pulseEnv = EnvGen.ar(Env.new([1.0, 0.6], [time], [-0.5]), timeScale:(1/1000));
	var signal = Mix.new(LFPulse.ar(freqs * 4.09));
	signal = (BinaryOpUGen('==', signal, 6.0) * 0.6) + (BinaryOpUGen('==', signal, 2.0) * 0.2) + (BinaryOpUGen('==', signal, 1.0) * 0.9); // XOR
 	signal = (signal * pulseEnv) + (Mix.new(LFPulse.ar(freqs, width:0.55)) * 0.9);
	signal = RLPF.ar(signal, 7000, 0.6);
 	signal = RHPF.ar(signal, 6800, 1.5);
	signal = RHPF.ar(signal, 6800, 1.5);
	signal = RHPF.ar(signal, 1200, 1.5);
	signal = signal + FreeVerb.ar(signal);
	signal = [signal, DelayN.ar(signal, 0.005, 0.005)];

	OffsetOut.ar(out, DirtPan.ar(signal * 4 * amp, ~dirt.numChannels, pan, env))
}).add;

// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html
SynthDef(\flute, { | scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2, pan=0.0 |

	var sr = SampleRate.ir;
	var cr = ControlRate.ir;
	var block = cr.reciprocal;

	var ifqc = freq;

	// noise envelope
	var kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	var env = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	var kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	var aflow1 = LFClipNoise.ar( sr, kenv1 );
	var kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	var asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	var afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	var fdbckArray = LocalIn.ar( 1 );

	var asum2 = asum1 + ( fdbckArray * ifeedbk1 );

	var ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );
	var apoly = ax - ( ax.cubed );
	var asum3 = apoly + ( fdbckArray * ifeedbk2 );
	var signal = LPF.ar( asum3, 2000 );

	var aflute1 = DelayC.ar(signal, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar(fdbckArray);

	OffsetOut.ar(0, DirtPan.ar(signal, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\forestbird, { |out=0, pan=0|
	var signal = BPF.ar(BrownNoise.ar,SinOsc.kr(LFNoise2.kr(50,50,50),0,100,2000),0.001,10);
	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan))
}).add;

SynthDef(\goeysynth, { |out=0,freq=440,sustain=1,pan=0,begin=0,end=1,amp=0.1|
  var line = Line.ar(begin, end, sustain*(end-begin), doneAction: Done.freeSelf);
  var env = Env([0,1,0.4,0.7,0],[Rand(0.001,0.005),0.005,0.005,sustain]);
  var volume = IEnvGen.ar(env, line);
  var source = LPF.ar(
    Mix(LFPar.ar(freq*[0.999,1.001],0,amp)).distort,
    EnvGen.kr(Env([10000,2000,4000,1000],[0.005,Rand(0.009,0.05),0.005]))
  );

  Out.ar(0, DirtPan.ar(source*volume, ~dirt.numChannels, pan))
}).add;

//adapted from JmC reverb

SynthDef(\goeyfx, { | out=0, pan=0.0 |
	var combDelays = 2; // number of comb delays
	var allpassDelays = 3; // number of allpass delays

	var in = In.ar(0,2);
	// reverb predelay time :
	var delay = DelayN.ar(in, 0.048,0.048);

	//for delaytime if want modulation-	//LFNoise1.kr(0.1.rand, 0.04, 0.05)
	var y = Mix.arFill(combDelays,{CombL.ar(delay,0.1,rrand(0.01, 0.1),5)});

	// chain of 4 allpass delays on each of two channels (8 total) :
	allpassDelays.do {
		y = AllpassN.ar(y, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1)
	};

	OffsetOut.ar(out, DirtPan.ar(y, ~dirt.numChannels, pan));
}).add;

SynthDef(\handclapsmash,{|out= 0 amp = 0.1 gate=1 cutoff=12000 rq=0.5 releaseTime=0.5 pan=0.0|

	var noise = WhiteNoise.ar;
	var filterenv = EnvGen.ar(Env([0.0,1.0,0.3,0.0],[0.0,0.3,0.3]));
	var filter = BHiPass.ar(RLPF.ar(noise,cutoff*filterenv,rq),150);
	var env = EnvGen.ar(Env.perc(0.005,releaseTime),doneAction:2);

	filter = BPeakEQ.ar(filter,440,1.0,8);
	filter = BPeakEQ.ar(filter,1200,1.0,14);

	OffsetOut.ar(out, DirtPan.ar(filter*amp, ~dirt.numChannels, pan, env));
}).add;


//with dirty attack
SynthDef(\handclapsmash2,{|out= 0 amp = 0.1 gate=1 cutoff= 12000 cutoff2=10000 rq=0.5 modamount=0.0 modrate=50 releaseTime=0.7 pan=0.0|

	var env = EnvGen.ar(Env.perc(0.005,releaseTime),doneAction:2);
	var noise = WhiteNoise.ar;
	var filterenv = EnvGen.ar(Env([0.0,1.0,0.3,0.0],[0.0,0.3,0.3]));
	var modulation = (LFSaw.ar(modrate).range(0.0,1.0))*EnvGen.ar(Env([1,1,0,0],[0.1,0.0,1.0]));
	var filter = BHiPass.ar(RLPF.ar(noise,cutoff*filterenv+ (cutoff2*modamount*modulation),rq),150);
	filter = BPeakEQ.ar(filter,440,1.0,8);
	filter = BPeakEQ.ar(filter,1200,1.0,14);

	OffsetOut.ar(out, DirtPan.ar(filter*amp, ~dirt.numChannels, pan, env));

}).add;

SynthDef(\harpsichord, { | out = 0, freq = 440, amp = 0.1, pan = 0.0 |
	var env = Env.perc(level: amp).kr(doneAction: 2);
	var snd = Pulse.ar(freq, 0.25, 0.75);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\hat, { | out=0, pan, amp |
	var osc1 = WhiteNoise.ar(amp);
	var env = EnvGen.kr(Env.perc(0.01, 0.2), doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(osc1, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\snare, { | out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0 |
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1, ffreq) + snd2;

	OffsetOut.ar(out, DirtPan.ar(sum, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\kick, { | out = 0, amp = 0.3, sinfreq = 70, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0 |
	var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
	var snd = SinOsc.ar(gliss);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	snd = snd * amp;
	snd = Limiter.ar(snd,1,0.001);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\impulsetrain, { | freq=440, amp=0.1,attack=0.01, sustain=0.1, decay=0.01,pan=0.0, bandwidth=100 |
	var env = EnvGen.ar(Env([0,1,1,0],[attack, sustain, decay]), doneAction:2);
	var source = Impulse.ar(freq);
	var filter = BPF.ar(source*amp*10,freq,bandwidth/freq);

	OffsetOut.ar(0, DirtPan.ar(filter, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\jilet, { | out=0, gate=1, freq=4, amp=0.5, endReflection=1.5, jetReflection=0.5, jetRatio=10.72, noiseGain=0.35, vibFreq=5.925, vibGain=0.02, outputGain=0.20, pan=0.0 |

	var adsr = (amp*0.2) + EnvGen.ar(Env.adsr(0.005, 0.01, 1.1, 0.01), gate, doneAction: 2);
	var noise = WhiteNoise.ar(noiseGain);
	var vibrato = SinOsc.ar(vibFreq, 0, vibGain);

	var delay = (freq*0.66666).reciprocal;
	var lastOut = LocalIn.ar(1);
	var breathPressure = adsr*Mix([1.0, noise, vibrato]);
	var filter = LeakDC.ar(OnePole.ar(lastOut.neg, 0.7));
	var pressureDiff = breathPressure - (jetReflection*filter);
	var jetDelay = DelayL.ar(pressureDiff, 0.025, delay*jetRatio);
	var jet = (jetDelay * (jetDelay.squared - 1.0)).clip2(1.0);
	var boreDelay = DelayL.ar(jet + (endReflection*filter), 0.05, delay);
	LocalOut.ar(boreDelay);

	OffsetOut.ar(out, DirtPan.ar(0.3 * boreDelay * outputGain, ~dirt.numChannels, pan))
}).add;

SynthDef(\justwannahavefun,{|out= 0 freq = 440 amp = 0.1 ringTime=10.0 pan=0.0|
  	var impulse = Impulse.ar(0);
	var filter = Ringz.ar(impulse,(freq.cpsmidi + (Rand(0.2,1.2)*SinOsc.kr(Rand(10,50)))).midicps,ringTime);
	var env = EnvGen.ar(Env([0.0,1.0,1.0,0.0],[0.001,0.04,0.04]),doneAction:2);

	OffsetOut.ar(out, DirtPan.ar((filter.softclip(0.9))*amp, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\kick_oto309, { | out=0, amp=0.5, pan=0 |
	var env0, env1, env1m, son;

	env0 =  EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.06, 0.26], [-4, -2, -4]), doneAction:2);
	env1 = EnvGen.ar(Env.new([110, 59, 29], [0.005, 0.29], [-4, -5]));
	env1m = env1.midicps;

	son = LFPulse.ar(env1m, 0, 0.5, 1, -0.5);
	son = son + WhiteNoise.ar(1);
	son = LPF.ar(son, env1m*1.5, env0);
	son = son + SinOsc.ar(env1m, 0.5, env0);

	son = son * 1.2;
	son = son.clip2(1);

	OffsetOut.ar(out, DirtPan.ar((son * amp), ~dirt.numChannels, pan))
}).add;

/*
Mitchell Sigman (2011) Steal this Sound. Milwaukee, WI: Hal Leonard Books
Adapted for SuperCollider and elaborated by Nick Collins
http://www.sussex.ac.uk/Users/nc81/index.html
under GNU GPL 3 as per SuperCollider license
Minor modifications by Bruno Ruviaro, June 2015.
*/
SynthDef(\laserbeam, { | out = 0, pan = 0.0, freq = 440, amp = 0.1, att = 0.01 |
	var freqenv = EnvGen.ar(Env([4, 0.5, 1, 1], [att, 0.01, 1.0]));
	var ampenv = EnvGen.ar(
		envelope: Env([0, 1, 0.5, 0.0], [0.02, 0.2, 0.1]),
		levelScale: amp,
		doneAction: 2);
	var snd = LFTri.ar(freq * freqenv);

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, ampenv))
}).add;

SynthDef(\mrostinato,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 10 lfowidth= 0.5 pan = 0.0|
	var lfo = LFTri.kr(lforate,Rand(0,2.0)!3);
	var pulse = Pulse.ar(freq*[1,1.01,0.5],lfo*lfowidth+0.5, amp);
	var env = EnvGen.ar(Env.adsr(0.01,0.05,0.5,0.1),gate,doneAction:2);

	OffsetOut.ar(out, DirtPan.ar(pulse, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\noisy, { | out = 0, freq = 440, amp = 0.2, pan = 0.0 |
	var env = Env.perc(0.02, 0.1).kr(doneAction: 2);
	var snd = Mix(LFPulse.ar(
		freq: freq * [1, 5/2],
		iphase: 0.0,
		width: 0.5,
		mul: amp));

	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\oneclap_thor, {arg out=0, t_trig=1, amp=0.1, filterfreq=1000, rq=0.1, pan=0;
	var noise = WhiteNoise.ar(1)+SinOsc.ar([filterfreq/2,filterfreq/2+4 ], pi*0.5, XLine.kr(1,0.01,4))
	    + PinkNoise.ar(1)+SinOsc.ar([(filterfreq)*XLine.kr(1,0.01,3), (filterfreq+4)*XLine.kr(1,0.01,3) ], pi*0.5, XLine.kr(1,0.01,4));

	var hpf1 = RLPF.ar(noise, filterfreq, rq);
	var hpf2 = RHPF.ar(noise, filterfreq/2, rq/4);
	var env = EnvGen.kr(Env.perc(0.003, 0.00035));
	var signal = (hpf1+hpf2);
	signal = FreeVerb.ar(signal, 0.23, 0.15, 0.2);

	OffsetOut.ar(out, DirtPan.ar(signal*amp, ~dirt.numChannels, pan,env))
}).add;

SynthDef(\organdonor, { | out=0, pan=0.0, freq = 440, amp = 0.1, gate = 1, att = 0.01, dec = 0.5, sus = 1, rel = 0.5, lforate = 10, lfowidth = 0.01, cutoff = 100, rq = 0.5 |

	var pulse, env, filter;
	var vibrato = SinOsc.ar(lforate, Rand(0, 2.0));
	freq = freq * [1, 1.9953843530485, 3.0139733629359];
	freq = freq * (1.0 + (lfowidth * vibrato));
	pulse = VarSaw.ar(
		freq: freq,
		iphase: Rand(0.0, 1.0) ! 3,
		width: Rand(0.3, 0.5) ! 3,
		mul: [1.0,0.7,0.3]);
	pulse = Mix(pulse);
	filter = RLPF.ar(pulse, cutoff, rq);
	env = EnvGen.ar(
		envelope: Env.adsr(att, dec, sus, rel, amp),
		gate: gate,
		doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(filter, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\ping_mh,{ | freq=440,amp=0.2,dur=0.1,attack=0.001,pan=0,out=0 |
    var sig,freq2, env;
    freq=freq*rrand(1,1.01);
    freq2=freq*rrand(1,1.01);
    env=EnvGen.ar(Env.perc(attack,dur,curve:-4),doneAction:2);
    sig=SinOsc.ar([freq,freq2],0,amp);
    sig=Pan2.ar(sig,pan);

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\sillyVoice, { |
	freq = 220,
	amp = 0.5,
	vibratoSpeed = 6,
	vibratoDepth = 4,
	vowel = 0,
	att = 0.01,
	rel = 0.1,
	lag = 1,
	pan = 0.0,
	gate = 1 |

	var in, vibrato, env, va, ve, vi, vo, vu, snd;

	vibrato = SinOsc.kr(vibratoSpeed, mul: vibratoDepth);
	in = Saw.ar(Lag.kr(freq, lag) + vibrato);
	env = EnvGen.kr(Env.asr(att, 1, rel), gate, doneAction: 2);

	va = BBandPass.ar(
		in: in,
		freq: [ 600, 1040, 2250, 2450, 2750 ],
		bw: [ 0.1, 0.067307692307692, 0.048888888888889, 0.048979591836735, 0.047272727272727 ],
		mul: [ 1, 0.44668359215096, 0.35481338923358, 0.35481338923358, 0.1 ]);

	ve = BBandPass.ar(
		in: in,
		freq: [ 400, 1620, 2400, 2800, 3100 ] ,
		bw: [ 0.1, 0.049382716049383, 0.041666666666667, 0.042857142857143, 0.038709677419355 ],
		mul: [ 1, 0.25118864315096, 0.35481338923358, 0.25118864315096, 0.12589254117942 ]);

	vi = BBandPass.ar(
		in: in,
		freq: [ 250, 1750, 2600, 3050, 3340 ] ,
		bw: [ 0.24, 0.051428571428571, 0.038461538461538, 0.039344262295082, 0.035928143712575 ],
		mul: [ 1, 0.031622776601684, 0.15848931924611, 0.079432823472428, 0.03981071705535 ] );

	vo = BBandPass.ar(
		in: in,
		freq:[ 400, 750, 2400, 2600, 2900 ] ,
		bw: [ 0.1, 0.10666666666667, 0.041666666666667, 0.046153846153846, 0.041379310344828 ],
		mul: [ 1, 0.28183829312645, 0.089125093813375, 0.1, 0.01 ]);

	vu = BBandPass.ar(
		in: in,
		freq: [ 350, 600, 2400, 2675, 2950 ],
		bw: [ 0.11428571428571, 0.13333333333333, 0.041666666666667, 0.044859813084112, 0.040677966101695 ],
		mul: [ 1, 0.1, 0.025118864315096, 0.03981071705535, 0.015848931924611 ]);

	snd = SelectX.ar(Lag.kr(vowel, lag), [va, ve, vi, vo, vu]);
	snd = Mix.new(snd);

	OffsetOut.ar(0, DirtPan.ar(snd!2 * amp, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\situationsynth,{ |out= 0 freq = 440 amp = 0.1 gate=1 cutoff=8000 rq=0.8 lfowidth=0.001 lforate= 3.3 pan=0.0|

	var lfo = LFTri.kr(lforate,Rand(0,2.0)!2);
	var pulse = Mix(Pulse.ar((((freq.cpsmidi)+[0,0.14])+(lfo*lfowidth)).midicps,[0.5,0.51]+(lfowidth*lfo)))*0.5;
	var filterenv = EnvGen.ar(Env([0.0,1.0,0.3,0.0],[0.005,0.57,0.1],-3));
	var filter =  RLPF.ar(pulse,100+(filterenv*cutoff),rq);
	var env = EnvGen.ar(Env.adsr(0.002,0.57,1.0,0.3),gate,doneAction:2);

	OffsetOut.ar(out, DirtPan.ar(filter * amp, ~dirt.numChannels, pan, env))
}).add;


SynthDef(\yazoodelayeffect, {|out=0 gate=1 pan= 0.1|
	var source = In.ar(out,2);
	var env = Linen.kr(gate, 0.0, 1, 0.1, 2);
	var delay= DelayC.ar(source[0].distort,0.25,0.25);

	OffsetOut.ar(out, DirtPan.ar(delay, ~dirt.numChannels, pan, env))
}).add;

SynthDef(\snare_oto309, { | out=0, amp=0.1, pan=0 |
	var env0, env1, env2, env1m, oscs, noise, son;

	env0 = EnvGen.ar(Env.new([0.5, 1, 0.5, 0], [0.005, 0.03, 0.10], [-4, -2, -4]));
	env1 = EnvGen.ar(Env.new([110, 60, 49], [0.005, 0.1], [-4, -5]));
	env1m = env1.midicps;
	env2 = EnvGen.ar(Env.new([1, 0.4, 0], [0.05, 0.13], [-2, -2]), doneAction:2);

	oscs = LFPulse.ar(env1m, 0, 0.5, 1, -0.5) + LFPulse.ar(env1m * 1.6, 0, 0.5, 0.5, -0.25);
	oscs = LPF.ar(oscs, env1m*1.2, env0);
	oscs = oscs + SinOsc.ar(env1m, 0.8, env0);

	noise = WhiteNoise.ar(0.2);
	noise = HPF.ar(noise, 200, 2);
	noise = BPF.ar(noise, 6900, 0.6, 3) + noise;
	noise = noise * env2;

	son = oscs + noise;
	son = son.clip2(1) * amp;

	OffsetOut.ar(out, DirtPan.ar(son, ~dirt.numChannels, pan))
}).add;

)
