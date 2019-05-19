(
SynthDef(\krell, { |attackMod=0.1, decayMod=0.1, freq=440|
	var env = Env([0,1,0], [attackMod, decayMod], 2);
	var envgen = EnvGen.kr(env, doneAction:2);
	var sig = VarSaw.ar(freq) * Rand(0.4, 0.8);
	sig = BPF.ar(sig, 110 * Rand(0.5, 1), Rand(0.1, 2));
	sig = sig * envgen;
	Out.ar(0, sig!2);
}).add;

Pdef(\krell, Pbind(
	\instrument, \krell,
	\attackMod, Pexprand(0.1, 2),
	\decayMod, Pexprand(0.1, 1),
	\dur, Pkey(\attackMod) + Pkey(\decayMod),
	\freq, Pexprand(110, 440),
));
)

Pdef(\krell).play;