(

SynthDef(\kk, { |out=0, amp=0.5, pan, distort=0.3, n, attack=0.0001, release=0.09, accelerate|
	var env = EnvGen.kr(Env.perc(attack, release, amp, 8));
	var source = SinOsc.ar(EnvGen.kr(Env.perc(0.0001, 1.5, n+1, -200), 1, 1000, 45, doneAction:2), 1, 1);
	var noise = BPF.ar(
		GrayNoise.ar(6),
		EnvGen.kr(Env.perc(0.001, accelerate + 0.3, 1, -200), 1, 6000, 70),
		1.5).distort * Line.kr(distort,0.0,0.1);

	OffsetOut.ar(
		out,
		DirtPan.ar(
			source + noise,
			~dirt.numChannels,
			pan,
			env
		)
	)
}).add;

SynthDef(\ss, { |out=0, amp=0.1, pan=0.0|
	var filtWhite = LPF.ar(WhiteNoise.ar(1), 7040, 1);

	var snare = ((SinOsc.ar(330,0,0.25) * EnvGen.ar(Env.perc(0.0005,0.055))) +(SinOsc.ar(185,0,0.25) * EnvGen.ar(Env.perc(0.0005,0.075))) + (filtWhite * EnvGen.ar(Env.perc(0.0005,0.2), doneAction: 2) * 0.2)
 + (HPF.ar(filtWhite, 523, 1) * EnvGen.ar(Env.perc(0.0005,0.183)) * 0.2));

	OffsetOut.ar(
		out,
		DirtPan.ar(
			snare * amp * 10,
			~dirt.numChannels,
			pan
		)
	)
}).add;

)