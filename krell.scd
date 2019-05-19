(
SynthDef(\krell, { |attackMod=0.1, decayMod=0.1, freq=440, modfreq=1, pan=0|
	var env = Env.asr(attackMod, 1, decayMod, 2);
	var envgen = EnvGen.kr(env, Line.kr(1, 0, attackMod + decayMod), doneAction:2);
	var sig = VarSaw.ar(freq * SinOsc.kr(modfreq).range(0.5, 1.5)) * Rand(0.4, 0.8);
	sig = BPF.ar(sig, LFNoise1.kr(2).range(100, 300), Rand(0.1, 2));
	sig = FreeVerb.ar(sig, 0.5, 0.8);
	sig = sig * envgen;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;

Pdef(\krell, Pbind(
	\instrument, \krell,
	\attackMod, Pexprand(0.1, 0.5),
	\decayMod, Pexprand(1, 2),
	\dur, Pkey(\attackMod) + Pkey(\decayMod),
	\freq, Pwhite(110, 440),
	\modfreq, Pexprand(0.1, 0.5),
	\pan, Pwhite(-0.5, 0.5),
));
)

Pdef(\krell).play;
Pdef(\krell).pause;