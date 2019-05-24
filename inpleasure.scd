(
SynthDef(\inpleasure, { |sustain=1|
	var in = SoundIn.ar(0, 1);
	in = FreeVerb.ar(in, Saw.kr(2).range(3,5), VarSaw.kr(5).range(3,5));
	in = in * 2.5;
	in = in * EnvGen.kr(Env([0,1,1,0],[1,sustain,1], 2), doneAction: 2);
	in = in + Delay1.ar(in);
	in = Pan2.ar(in);
	in = Limiter.ar(in);
	Out.ar(0, in);
}).add;

Pdef(\inpleasure, Pbind(
	\instrument, \inpleasure,
	\dur, 3,
	\sustain, 3,
));
)

Pdef(\inpleasure).play;
Pdef(\inpleasure).stop;

