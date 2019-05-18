(
Ndef(\kicks, {
	var base_freq = LFNoise2.kr(1!2).exprange(35,60);
	Pan2.ar(
		SinOsc.ar(
			EnvGen.ar(
				Env(
					[
						base_freq,
						LFNoise2.kr(1/2!2).exprange(400,6500),
						LFNoise2.kr(1/2!2).exprange(35,125),
						base_freq
					],
					[
						LFNoise2.kr(1/2!2).exprange(0.001,0.008),
						LFNoise2.kr(1/2!2).exprange(0.008,0.13),
						LFNoise2.kr(1/2!2).exprange(0.01,0.5)
					],
					[
						LFNoise2.kr(1/4!2).exprange(1/5,5),
						LFNoise2.kr(1/4!2).range(-19,-6),
						LFNoise2.kr(1/4!2).range(-5,5)
					]
				).circle
			), 0,
			LFNoise2.kr(LFNoise2.kr(1/20!2).exprange(1/9,9)).range(0.05,1)
		),
		LFTri.ar(
			LFNoise0.kr(1/20).exprange(1/10,10), [0,2],
			SinOsc.kr(LFNoise2.kr(1/10!2).exprange(1/5,5)).range(0.3,1)
		)
	).mean;
});
)

Ndef(\kicks).play;