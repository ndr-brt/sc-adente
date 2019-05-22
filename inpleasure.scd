(
Ndef(\inpleasure, {
	var in = SoundIn.ar(0, 1);
	in = FreeVerb.ar(in, 2, 4);
	in = in * SinOsc.ar(LFNoise0.ar(5).range(200, 400))*3;
	in = in * 3;
	in = Limiter.ar(in);
	Out.ar(0, [in, Delay1.ar(in, 2)]);
});
)

Ndef(\inpleasure).play;