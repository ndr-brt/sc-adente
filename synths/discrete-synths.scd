(
(
SynthDef(\blow, { |out, speed=1, decay=0, sustain=1, freq, pan, accelerate, voice = 0.5, semitone=12, resonance=0.2, lfo=1, pitch1=1|
	var sig, env, imp;
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var lfof1 = min(basefreq*10*pitch1, 22000);
	var lfof2 = min(lfof1 * (lfo + 1), 22000);
	imp = LFNoise1.kr(100);
	env = EnvGen.ar(Env.pairs([[0,0],[0.05,1],[0.2,1-decay],[0.95,1-decay],[1,0]], -3), timeScale:sustain, doneAction:2);
	sig = SinOsc.ar(LFNoise1.kr(2).range(2,4) * basefreq * env / 2.sqrt) * env;
	sig = LPF.ar(sig, LFNoise2.kr(40).range(lfof1, lfof2), resonance);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;
);

)