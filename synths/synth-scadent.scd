(

(
SynthDef(\entropy, { |out, sustain=1, pan, decay=0, width=0.3, attack, release|
	var env = EnvGen.kr(Env.new([0,1,1,0],[attack, sustain, release], -8),doneAction: 2);
	var caboos = LFNoise0.kr(15);
	var sig = SinOscFB.ar(
		Pulse.kr(
			LFPulse.kr(SinOsc.kr(0.3).range(1, caboos.fold(1, 4)), Crackle.kr.range(0, 2pi)),
			LFNoise1.kr(7).range(0.1, caboos.slew(0.3, 0.9))
		).exprange(LFNoise2.kr(3).range(Line.kr(300, 800, 17), caboos.range(800, 1400)))
	)!2;

	sig = sig + Impulse.ar(caboos.slew(0.1, 0.9).range(300, 800));

	sig = sig / 2;

	sig = FreeVerb.ar(sig,
		SinOsc.kr(1/3).range(0.3, 0.9),
		LFSaw.kr(1/5).range(0.3, 0.9),
		SinOsc.kr(1/7).range(0.3, 0.9)
	);
	sig = [sig, sig + Delay1.ar(sig)];
	sig = sig.tanh;

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
);

SynthDef(\blow, { |out, decay=0, sustain=0.03, freq, pan, accelerate, voice = 0.5, semitone=12, resonance=0.3, lfo=1, pitch1=1, width = 0.3|
	var imp = LFNoise1.kr(80);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var lfof1 = min(basefreq*10*pitch1, 22000);
	var lfof2 = min(lfof1 * (lfo + 1), 22000);
	var sig = LPF.ar(
		SinOsc.ar(
			LFNoise1.kr(3).range(2,4) * basefreq / 2.sqrt
		),
		LFNoise2.kr(40).range(lfof1, lfof2), resonance
	);
	var env = LFGauss.ar(sustain, width, loop: 0).range(0, 1);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;

)