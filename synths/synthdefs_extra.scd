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

SynthDef(\synchronicity,{|out= 0, freq = 440, amp = 0.1, gate=1, cutoff=8000, rq=0.2, pan|
	var slavefreq = EnvGen.ar(Env([1,5,1],[0.04,0.9]))*freq;
	var pulse = SyncSaw.ar(freq,slavefreq);
	var filter = BLowPass.ar(pulse,cutoff,rq,amp);
	var env = EnvGen.ar(Env.adsr(0.01,0.0,1.0,0.1),gate,doneAction:2);

	OffsetOut.ar(out, DirtPan.ar(filter * amp, ~dirt.numChannels, pan, env));
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

SynthDef(\bd, { | out=0, pan=0.0, freq=440 |
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

SynthDef(\clap_oto309, { | out=0, amp = 0.1, pan=0 |
	var son, noise1, noise2;

	var env1 = EnvGen.ar(Env.new([0, 1, 0, 1, 0, 1, 0, 1, 0], [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03], [0, -3, 0, -3, 0, -3, 0, -4]));
	var env2 = EnvGen.ar(Env.new([0, 1, 0], [0.02, 0.3], [0, -4]), doneAction:2);

	noise1 = WhiteNoise.ar(env1);
	noise1 = HPF.ar(noise1, 600);
	noise1 = BPF.ar(noise1, 2000, 3);

	noise2 = WhiteNoise.ar(env2);
	noise2 = HPF.ar(noise2, 1000);
	noise2 = BPF.ar(noise2, 1200, 0.7, 0.7);

	son = noise1 + noise2;
	son = son * 2;
	son = son.softclip * amp;

	OffsetOut.ar(out, DirtPan.ar(son, ~dirt.numChannels, pan))
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

SynthDef(\cymbalic_mcld, { |out=0, pan=0.0, amp=0.1|
	var freqs, res, thwack;

	var locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 20000 + 10;
	var lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	var hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	var hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));

	freqs  = {exprand(300, 20000)}.dup(100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

	OffsetOut.ar(out, DirtPan.ar(((res * 1) + (lodriver * 2) + thwack) * amp, ~dirt.numChannels, pan))
}).add;

SynthDef(\drum_kick, {
	|freq=440, gate=1, amp=0.5, pan = 0.0,out=0|
	var env = EnvGen.kr(Env.perc(0.0001, 0.09, amp, 8));
	var source =
		SinOsc.ar(EnvGen.kr(Env.perc(0.0001, 1.5, 1, -200), gate, 1000, 45, doneAction:2), 1, 1) +
		((BPF.ar([GrayNoise.ar(6),GrayNoise.ar(6)],EnvGen.kr(Env.perc(0.001, 0.3, 1, -200), gate, 6000, 70), 1.5)).distort * Line.kr(0.3,0,0.1));

	OffsetOut.ar(out, DirtPan.ar(source, ~dirt.numChannels, pan, env))
}).add;

// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html
SynthDef("waveguideFlute", { | scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2, pan=0.0 |

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, 2000 );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	OffsetOut.ar(0, DirtPan.ar( [ signalOut * kenv2, signalOut * kenv2 ] , ~dirt.numChannels, pan))

}).add;

SynthDef(\forestbird, { |out=0, pan=0|
	var signal = BPF.ar(BrownNoise.ar,SinOsc.kr(LFNoise2.kr(50,50,50),0,100,2000),0.001,10);
	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan))
}).add;

SynthDef(\goeysynth, { | freq=440, amp=0.1, sustain=0.1, pan=0.0 |
	var source = LPF.ar(Mix(LFPar.ar(freq*[0.999,1.001],0,amp)).distort,EnvGen.kr(Env([10000,2000,4000,1000],[0.005,Rand(0.009,0.05),0.005])));
	var env = EnvGen.kr(Env([0,1,0.4,0.7,0],[Rand(0.001,0.005),0.005,0.005,sustain]), doneAction:2);

	OffsetOut.ar(0, DirtPan.ar(source, ~dirt.numChannels, pan, env))
}).add;

//adapted from JmC reverb

SynthDef(\goeyfx, { | out=0, pan=0.0 |
	var a,c,z,y,in;
	c = 2; // number of comb delays
	a = 3; // number of allpass delays

	in = In.ar(0,2);
	// reverb predelay time :
	z = DelayN.ar(in, 0.048,0.048);

	//for delaytime if want modulation-	//LFNoise1.kr(0.1.rand, 0.04, 0.05)
	y=Mix.arFill(c,{CombL.ar(z,0.1,rrand(0.01, 0.1),5)});

	// chain of 4 allpass delays on each of two channels (8 total) :
	a.do({ y = AllpassN.ar(y, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1) });

	OffsetOut.ar(out, DirtPan.ar((0.2*y), ~dirt.numChannels, pan));
}).add;

SynthDef(\handclapsmash,{|out= 0 amp = 0.1 gate=1 cutoff= 12000 rq=0.5 releaseTime=0.5 pan=0.0|

	var noise, filter, filterenv, env;

	noise = WhiteNoise.ar;

	filterenv = EnvGen.ar(Env([0.0,1.0,0.3,0.0],[0.0,0.3,0.3]));
	//this involves a gate control, less use here
	//filterenv = EnvGen.ar(Env.adsr(0.0,0.3,0.3,0.3),gate);

	filter = BHiPass.ar(RLPF.ar(noise,cutoff*filterenv,rq),150);

	//body
	filter = BPeakEQ.ar(filter,440,1.0,8);
	//snap
	filter = BPeakEQ.ar(filter,1200,1.0,14);

	//no gate, fixed percussion sound
	env = EnvGen.ar(Env.perc(0.005,releaseTime),doneAction:2);

	// Out.ar(out,Pan2.ar(filter*env*amp,pan));
	OffsetOut.ar(out, DirtPan.ar(filter*env*amp, ~dirt.numChannels, pan));
}).add;


//with dirty attack
SynthDef(\handclapsmash2,{|out= 0 amp = 0.1 gate=1 cutoff= 12000 cutoff2=10000 rq=0.5 modamount=0.0 modrate=50 releaseTime=0.7 pan=0.0|

	var noise, filter, filterenv, modulation, env;

	noise = WhiteNoise.ar;

	filterenv = EnvGen.ar(Env([0.0,1.0,0.3,0.0],[0.0,0.3,0.3]));

	modulation = (LFSaw.ar(modrate).range(0.0,1.0))*EnvGen.ar(Env([1,1,0,0],[0.1,0.0,1.0]));

	//filter = BHiPass.ar(RLPF.ar(noise,cutoff*filterenv*(1.0+(modamount*modulation)),rq),150); //alternative
	filter = BHiPass.ar(RLPF.ar(noise,cutoff*filterenv+ (cutoff2*modamount*modulation),rq),150);

	//body
	filter = BPeakEQ.ar(filter,440,1.0,8);
	//snap
	filter = BPeakEQ.ar(filter,1200,1.0,14);

	//no gate, fixed percussion sound
	env = EnvGen.ar(Env.perc(0.005,releaseTime),doneAction:2);

	//amp modulation too not very effective ((1.0-modamount)+(modamount*modulation))
	// Out.ar(out,Pan2.ar(filter*env*amp,pan));
	OffsetOut.ar(out, DirtPan.ar(filter*env*amp, ~dirt.numChannels, pan));

}).add;

SynthDef("harpsichord1", { arg out = 0, freq = 440, amp = 0.1, pan = 0.0;
    var env, snd;
	env = Env.perc(level: amp).kr(doneAction: 2);
	snd = Pulse.ar(freq, 0.25, 0.75);
	snd = snd * env;
	// Out.ar(out, Pan2.ar(snd, pan));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan));
}).add;

SynthDef(\hat, { | out=0,pan |
	var osc1 = WhiteNoise.ar * 0.4;
	var env = EnvGen.kr(Env.perc(0.01, 0.2), doneAction: 2);
	// Out.ar(out, Pan2.ar(osc1, 0, env));
	OffsetOut.ar(out, DirtPan.ar(osc1, ~dirt.numChannels, pan, env));
}).add;


// Basic drum kit


SynthDef("hihat", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	// Out.ar(out, Pan2.ar(snd, pan));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
}).add;

SynthDef("snare", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	var sum = HPF.ar(snd1 * env, ffreq)+(snd2*env);
	// Out.ar(out, Pan2.ar(sum, pan));
	OffsetOut.ar(out, DirtPan.ar(sum, ~dirt.numChannels, pan))
}).add;

SynthDef("kick", {arg out = 0, amp = 0.3, sinfreq = 70, glissf = 0.9, att = 0.01, rel = 0.45, pan = 0;
	var gliss = XLine.kr(sinfreq, sinfreq*glissf, rel);
	var snd = SinOsc.ar(gliss);
	var env = EnvGen.kr(Env.perc(att, rel), doneAction: 2);
	snd = snd * env * amp;
	snd = Limiter.ar(snd,1,0.001);
	// Out.ar(out, Pan2.ar(snd, pan));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
}).add;

// var numChannels=2;//4  //replace 2 by 4 if you want to try a quadrophonic setup

SynthDef(\impulsetrain1, {arg freq=440, amp=0.1,attack=0.01, sustain=0.1, decay=0.01,pan=0.0, bandwidth=100;
var source, filter, env;

env= EnvGen.ar(Env([0,1,1,0],[attack, sustain, decay]), doneAction:2);

source= Impulse.ar(freq);

filter= BPF.ar(source*env*amp*10,freq,bandwidth/freq);

	// Out.ar(0,PanAz.ar(numChannels,filter,pan))
	OffsetOut.ar(0, DirtPan.ar(filter, ~dirt.numChannels, pan))
}).send(s);

SynthDef(\jilet, { arg out=0, gate=1, freq=4, amp=0.5, endReflection=1.5, jetReflection=0.5, jetRatio=10.72, noiseGain=0.35, vibFreq=5.925, vibGain=0.02, outputGain=0.20, pan=0.0;

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
	// Out.ar(out, 0.3*boreDelay*outputGain);
	OffsetOut.ar(out, DirtPan.ar(0.3 * boreDelay * outputGain, ~dirt.numChannels, pan))

}).add;

//added some modulation to ring frequency to roughen sound a bit
SynthDef(\justwannahavefun,{|out= 0 freq = 440 amp = 0.1 ringTime=10.0 pan=(-0.1)|

	var impulse, filter, env;

  	impulse = Impulse.ar(0);

	filter = Ringz.ar(impulse,(freq.cpsmidi + (Rand(0.2,1.2)*SinOsc.kr(Rand(10,50)))).midicps,ringTime);

	env = EnvGen.ar(Env([0.0,1.0,1.0,0.0],[0.001,0.04,0.04]),doneAction:2);

	// Out.ar(out,Pan2.ar((filter.softclip(0.9))*env*amp,pan));
	OffsetOut.ar(out, DirtPan.ar((filter.softclip(0.9))*env*amp, ~dirt.numChannels, pan))

}).add;

//
// SynthDef(\gatedreverb,{|out =0 gate= 1 threshold= 0.1 amp=0.1 pan=0.0|
//
// 	var a,c,z,y,in;
// 	var env = Linen.kr(gate, 0.1, 1, 0.1, 2);
//
// 	c = 5; // number of comb delays
// 	a = 4; // number of allpass delays
//
// 	in=In.ar(out,2);
//
// 	gate = if((in.mean)>threshold,in.mean,DC.ar(0)!2);
//
// 	// reverb predelay time :
// 	z = gate; //DelayN.ar(gate, 0.048,0.048);
//
// 	//for delaytime if want modulation-	//LFNoise1.kr(0.1.rand, 0.04, 0.05)
// 	y=Mix.arFill(c,{CombL.ar(z,0.1,rrand(0.01, 0.1),rrand(1.5,4))});
//
// 	// chain of 4 allpass delays on each of two channels (8 total) :
// 	a.do({ y = AllpassN.ar(y, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1) });
//
// 	// Out.ar(out,Pan2.ar(y,0)*env*amp);
// 	OffsetOut.ar(out, DirtPan.ar((y,0*env*amp, ~dirt.numChannels, pan)))
//
// }).add;

SynthDef("kick_oto309", {
	arg out=0, amp=0.5, pan=0;
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

	// Out.ar(out, Pan2.ar(son * amp));
	OffsetOut.ar(out, DirtPan.ar((son * amp), ~dirt.numChannels, pan))
}).add;


/*
Mitchell Sigman (2011) Steal this Sound. Milwaukee, WI: Hal Leonard Books
Adapted for SuperCollider and elaborated by Nick Collins
http://www.sussex.ac.uk/Users/nc81/index.html
under GNU GPL 3 as per SuperCollider license
Minor modifications by Bruno Ruviaro, June 2015.
*/

SynthDef("laserbeam", {
	arg out = 0, pan = 0.0, freq = 440, amp = 0.1, att = 0.01;
	var snd, freqenv, ampenv;
	// frequency envelope
	freqenv = EnvGen.ar(Env([4, 0.5, 1, 1], [att, 0.01, 1.0]));
	// amplitude envelope
	// no gate: fixed-time envelope, self-terminating.
	ampenv = EnvGen.ar(
		envelope: Env([0, 1, 0.5, 0.0], [0.02, 0.2, 0.1]),
		levelScale: amp,
		doneAction: 2);
	snd = LFTri.ar(freq: freq * freqenv, mul: ampenv);
	// Out.ar(out, Pan2.ar(snd, pan));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
}).add;

SynthDef(\mrostinato,{|out= 0 freq = 440 amp = 0.1 gate=1 lforate = 10 lfowidth= 0.5 pan = 0.0|

	var lfo, pulse, filter, env;

	lfo = LFTri.kr(lforate,Rand(0,2.0)!3);

	pulse = Pulse.ar(freq*[1,1.01,0.5],lfo*lfowidth+0.5);

	env = EnvGen.ar(Env.adsr(0.01,0.05,0.5,0.1),gate,doneAction:2);

	// Out.ar(out,Pan2.ar(Mix(pulse)*env*amp,pan));
	OffsetOut.ar(out, DirtPan.ar(Mix(pulse)*env*amp, ~dirt.numChannels, pan))

}).add;

SynthDef("noisy", {arg out = 0, freq = 440, amp = 0.2, pan = 0.5;
	var snd, env;
	env = Env.perc(0.02, 0.1).kr(doneAction: 2);
	snd = Mix(LFPulse.ar(
		freq: freq * [1, 5/2],
		iphase: 0.0,
		width: 0.5,
		mul: amp));
	snd = snd * env ;
	// Out.ar(out, Pan2.ar(snd, pan));
	OffsetOut.ar(out, DirtPan.ar(snd, ~dirt.numChannels, pan))
}).add;

SynthDef(\oneclap_thor, {arg out=0, t_trig=1, amp=0.1, filterfreq=1000, rq=0.1, pan=0;
var env, signal, attack,� noise, hpf1, hpf2;
	noise = WhiteNoise.ar(1)+SinOsc.ar([filterfreq/2,filterfreq/2+4 ], pi*0.5, XLine.kr(1,0.01,4));
	noise = PinkNoise.ar(1)+SinOsc.ar([(filterfreq)*XLine.kr(1,0.01,3), (filterfreq+4)*XLine.kr(1,0.01,3) ], pi*0.5, XLine.kr(1,0.01,4));
	//signal = signal * SinOsc.ar(1,0.75);
	hpf1 = RLPF.ar(noise, filterfreq, rq);
	hpf2 = RHPF.ar(noise, filterfreq/2, rq/4);
	env = EnvGen.kr(Env.perc(0.003, 0.00035));
	signal = (hpf1+hpf2) * env;
	signal = CombC.ar(signal, 0.5, 0.03, 0.031)+CombC.ar(signal, 0.5, 0.03016, 0.06);
	//signal = Decay2.ar(signal, 0.5);
	signal = FreeVerb.ar(signal, 0.23, 0.15, 0.2);
	// Out.ar(out, Pan2.ar(signal * amp, pan));
	OffsetOut.ar(out, DirtPan.ar(signal * amp, ~dirt.numChannels, pan))
	// DetectSilence.ar(signal, doneAction:2);
}).add;

SynthDef("organdonor",{
	arg out = 0, pan = 0.0, freq = 440, amp = 0.1, gate = 1, att = 0.01, dec = 0.5, sus = 1, rel = 0.5, lforate = 10, lfowidth = 0.01, cutoff = 100, rq = 0.5;

	var vibrato, pulse, filter, env;
	vibrato = SinOsc.ar(lforate, Rand(0, 2.0));
	// up octave, detune by 4 cents
	// 11.96.midiratio = 1.9953843530485
	// up octave and a half, detune up by 10 cents
	// 19.10.midiratio = 3.0139733629359
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
	// Out.ar(out, Pan2.ar(filter * env, pan));
	OffsetOut.ar(out, DirtPan.ar(filter * env, ~dirt.numChannels, pan))
}).add;

SynthDef(\ping_mh,{arg freq=440,amp=0.2,dur=0.1,attack=0.001,pan=0,out=0;
    var sig,freq2;
    freq=freq*rrand(1,1.01);
    freq2=freq*rrand(1,1.01);
    e=EnvGen.ar(Env.perc(attack,dur,curve:-4),doneAction:2);
    sig=SinOsc.ar([freq,freq2],0,amp*e);
    sig=Pan2.ar(sig,pan);
	// Out.ar(out,sig)
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan))
}).add;

SynthDef("sillyVoice", { arg
	freq = 220,
	amp = 0.5,
	vibratoSpeed = 6,
	vibratoDepth = 4,
	vowel = 0,
	att = 0.01,
	rel = 0.1,
	lag = 1,
	pan = 0.0,
	gate = 1;

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
	// Out.ar(0, snd!2 * env * amp);
	OffsetOut.ar(0, DirtPan.ar(snd!2 * env * amp, ~dirt.numChannels, pan))
}).add;

SynthDef(\situationsynth,{|out= 0 freq = 440 amp = 0.1 gate=1 cutoff=8000 rq=0.8 lfowidth=0.001 lforate= 3.3 pan=(-0.1)|

	var pulse, filter, env, filterenv, lfo;

	lfo = LFTri.kr(lforate,Rand(0,2.0)!2);

	pulse = Mix(Pulse.ar((((freq.cpsmidi)+[0,0.14])+(lfo*lfowidth)).midicps,[0.5,0.51]+(lfowidth*lfo)))*0.5;

	filterenv = EnvGen.ar(Env([0.0,1.0,0.3,0.0],[0.005,0.57,0.1],-3));

	filter =  RLPF.ar(pulse,100+(filterenv*cutoff),rq);

	env = EnvGen.ar(Env.adsr(0.002,0.57,1.0,0.3),gate,doneAction:2);

	// Out.ar(out,Pan2.ar(filter*env*amp,pan));
	OffsetOut.ar(out, DirtPan.ar(filter * env * amp, ~dirt.numChannels, pan))

}).add;


SynthDef(\yazoodelayeffect, {|out =0 gate= 1 pan= 0.1|
	var source = In.ar(out,2);
	var delay;
	var env = Linen.kr(gate, 0.0, 1, 0.1, 2);

	delay= DelayC.ar(source[0].distort,0.25,0.25);

	// Out.ar(out,Pan2.ar(delay*env,pan));
	OffsetOut.ar(out, DirtPan.ar(delay * env, ~dirt.numChannels, pan))

}).add;

SynthDef("snare_oto309", {
	arg out=0, amp=0.1, pan=0;
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

	// Out.ar(out, Pan2.ar(son, pan));
	OffsetOut.ar(out, DirtPan.ar(son, ~dirt.numChannels, pan))
}).add;

SynthDef(\snare_stein, { |out=0, amp=0.1, pan=0.0|
var snare, filtWhite;

filtWhite = LPF.ar(WhiteNoise.ar(1), 7040, 1);

snare = ((SinOsc.ar(330,0,0.25) * EnvGen.ar(Env.perc(0.0005,0.055)))
+(SinOsc.ar(185,0,0.25) * EnvGen.ar(Env.perc(0.0005,0.075)))
+(filtWhite * EnvGen.ar(Env.perc(0.0005,0.2), doneAction: 2) * 0.2)
+(HPF.ar(filtWhite, 523, 1) * EnvGen.ar(Env.perc(0.0005,0.183)) * 0.2)
);

	// Out.ar(out, Pan2.ar(snare * amp * 10, pan));
	OffsetOut.ar(out, DirtPan.ar(snare * amp * 10, ~dirt.numChannels, pan))

}).add;
)
