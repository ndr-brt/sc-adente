(

SynthDef(\kk, { |out=0, amp, pan, distort=0.3, n, attack=0.0001, release=0.09, accelerate, speed=1|
	var env = EnvGen.kr(Env.perc(attack/speed, release/speed, amp, 8));
	var source = SinOsc.ar(EnvGen.kr(Env.perc(0.0001, 1.5, n+1, -200), 1, 1000, 45, doneAction:2), 1, 1);
	var noise = BPF.ar(
		GrayNoise.ar(6),
		EnvGen.kr(Env.perc(0.001, accelerate + 0.3, 1, -200), 1, 6000, 70),
		1.5
	).distort * Line.kr(distort,0.0,0.1);

	var sound = source + noise;

	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\ss, { |out=0, amp, pan, attack=0.0005, release=0.2, freq=440, speed=1|
	var filtWhite = LPF.ar(WhiteNoise.ar(amp*4), freq*16);
	var env = EnvGen.ar(Env.perc(attack/speed, release/speed), doneAction: 2);
	var snare =
	    (SinOsc.ar(30,0,0.25) * EnvGen.ar(Env.perc(attack,0.055))) +
	    (SinOsc.ar(285,0,0.25) * EnvGen.ar(Env.perc(attack,0.075))) +
	    (filtWhite * amp) +
	    (HPF.ar(filtWhite, 223, 1) * amp);

	var sound = snare * amp * 2;

	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\hhat, { |out=0, amp, attack=0.01, release = 0.08, freq, pan|
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(attack, release).kr(doneAction: 2);
	var sound = HPF.ar(snd, freq * 18);

	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\clap, { | out=0, amp = 0.1, pan=0 |

	var env1 = EnvGen.ar(
		Env.new(
			[0, 1, 0, 1, 0, 1, 0, 1, 0],
			[0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03],
			[0, -3, 0, -3, 0, -3, 0, -4]
	));
	var env2 = EnvGen.ar(
		Env.new(
			[0, 1, 0],
			[0.02, 0.3],
			[0, -4]
	), doneAction:2);

	var noise1 = BPF.ar(
		HPF.ar(
			WhiteNoise.ar(env1),
			600),
		2000, 3
	);

	var noise2 = BPF.ar(
		HPF.ar(
			WhiteNoise.ar(env2),
			1000),
		1200, 0.7, 0.7
	);

	var son = noise1 + noise2;
	son = son.softclip * amp * 2;

	OffsetOut.ar(out, DirtPan.ar(son, ~dirt.numChannels, pan))
}).add;


SynthDef(\crash, { |out=0, pan=0.0, amp=0.1, attack=0.01, release=2|
	var freqs, res, thwack, env;

	var locutoffenv = EnvGen.ar(Env.perc(0.5, 5)) * 20000 + 10;
	var lodriver = LPF.ar(WhiteNoise.ar(0.1), locutoffenv);

	var hicutoffenv = 10001 - (EnvGen.ar(Env.perc(1, 3)) * 10000);
	var hidriver = HPF.ar(WhiteNoise.ar(0.1), hicutoffenv);
	hidriver = hidriver * EnvGen.ar(Env.perc(1, 2, 0.25));

	thwack = EnvGen.ar(Env.perc(0.001,0.001,1));

	freqs  = {exprand(300, 20000)}.dup(100);

	res    = Ringz.ar(lodriver + hidriver + thwack, freqs).mean;

	env = EnvGen.ar(Env.perc(attack, release, amp));

	OffsetOut.ar(out, DirtPan.ar(((res * 1) + (lodriver * 2) + thwack), ~dirt.numChannels, pan, env))
}).add;

)
