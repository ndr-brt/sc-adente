(
SynthDef(\krell, {
	var attackMod = Rand(0.1, 1);
	var decayMod = Rand(0.1, 1);
	//var env = Env.adsr(attackMod, decayMod, 0, 0);
	var env = Env([0,1,0], [attackMod, decayMod], 2);
	var envgen = EnvGen.kr(env, doneAction:2);
	var sig = VarSaw.ar(Rand(110, 880)) * Rand(0.1, 1);
	sig = BPF.ar(sig, 220 * Rand(0.5, 1), Rand(0.1, 2));
	sig = sig * envgen;
	Out.ar(0, sig!2);
}).add;

Pdef(\krell, Pbind(
	\instrument, \krell,
));
)

Pdef(\krell).play;