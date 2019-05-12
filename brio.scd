(
SynthDef(\sava, { |freq=440,amp=1,pan=0|
	var sig;
	sig = { SinOsc.ar(freq * ExpRand(0.5, 1.5)) }!5;
	sig = sig.sum;
	sig = sig * EnvGen.kr(Env([0,1,0],[1,1]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan);
	sig = sig * (amp / 5);
	Out.ar(0, sig!2);
}).add;
)

(
Pdef(\dronide,
	Pbind(
		\instrument, \sava,
		\dur, 0.4,
		\amp, Pexprand(0.2,0.4),
		\freq, Pexprand(55, 220, inf),
		\pan, Prand([-0.8,-0.4,0,0.4,0.8], inf),
	)
)
)

Pdef(\dronide).play;
Pdef(\dronide).stop;