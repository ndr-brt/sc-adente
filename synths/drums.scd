(

SynthDef(\kk, { |out=0, amp, pan, distort=0.3, n, attack=0.0001, release=0.09, accelerate|
	var env = EnvGen.kr(Env.perc(attack, release, amp, 8));
	var source = SinOsc.ar(EnvGen.kr(Env.perc(0.0001, 1.5, n+1, -200), 1, 1000, 45, doneAction:2), 1, 1);
	var noise = BPF.ar(
		GrayNoise.ar(6),
		EnvGen.kr(Env.perc(0.001, accelerate + 0.3, 1, -200), 1, 6000, 70),
		1.5).distort * Line.kr(distort,0.0,0.1);

	var sound = source + noise;

	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef(\ss, { |out=0, amp, pan, attack=0.0005, release=0.2, freq|
	var filtWhite = LPF.ar(WhiteNoise.ar(amp*4), freq*16);
	var env = EnvGen.ar(Env.perc(attack, release), doneAction: 2);
	var snare =
	    (SinOsc.ar(30,0,0.25) * EnvGen.ar(Env.perc(attack,0.055))) +
	    (SinOsc.ar(285,0,0.25) * EnvGen.ar(Env.perc(attack,0.075))) +
	    (filtWhite * amp) +
	    (HPF.ar(filtWhite, 223, 1) * amp);

	var sound = snare * amp * 2;

	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

SynthDef("hh", { |out=0, amp, attack=0.01, release = 0.18, freq, pan|
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(attack, release).kr(doneAction: 2);
	var sound = HPF.ar(snd * env, freq * 18);

	OffsetOut.ar(out, DirtPan.ar(sound, ~dirt.numChannels, pan, env));
}).add;

)