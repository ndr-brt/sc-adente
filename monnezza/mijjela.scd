(
SynthDef(\taaac, {
	Out.ar(0, SinOsc.ar)
}).add;

y = Synth.new(\taaac);
x = {
	Blip.ar(
		LFNoise1.kr(
			{ LFNoise0.kr(3).range(1, 10) }!2
		).range(200, 500),
		Saw.kr(400).range(100, 300)
	);
};

x.play;
)