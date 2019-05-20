(
SynthDef(\krell, { |attack=0.1, decay=0.1, freq=440, modfreq=1, pan=0, amp=1|
	var env = Env.asr(attack, amp, decay, -4);
	var envgen = EnvGen.kr(env, Line.kr(0.5, 0, attack), doneAction:2);
	var sig = VarSaw.ar(freq * LFSaw.kr(modfreq).range(0.5, 1.5));
	sig = BPF.ar(sig, Rand(100,300), Rand(0.1, 2));
	sig = FreeVerb.ar(sig, Rand(0, 1), Rand(0, 1), Rand(0, 1));
	sig = sig * envgen;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;

Pdef(\krell, Pbind(
	\instrument, \krell,
	\attack, Pwhite(0.01, 0.2),
	\decay, Pwhite(0.5, 1),
	\dur, Pkey(\attack) + Pkey(\decay),
	\freq, Pwhite(220, 440),
	\modfreq, Pwhite(40, 200),
	\pan, Pwhite(-0.5, 0.5),
	\amp, Pwhite(0.3, 0.5),
));

)

Pdef(\krell).play;
Pdef(\krell).pause;

