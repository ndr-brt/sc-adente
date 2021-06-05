//WIP!
// ugens from https://github.com/madskjeldgaard/mkplugins
(
SynthDef(\lpg, { |out,pan,freq=440,attack=0.00001,release=1,reso=1.35|
  // var sig = PinkNoise.ar(0.95);
	// var freq = LFNoise2.kr(1).range(1.0,4.0);
	// var env = Env.perc(0.1,1.5).ar(gate: Impulse.kr(freq), timeScale:freq.reciprocal * 0.05);
  var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	var sig = WhiteNoise.ar(0.2) + SinOsc.ar(freq * SinOsc.kr(env.lag3.range(100,10)));

	sig = LPG.ar(
		input: sig,
		controlinput: env,
		controloffset: 0.0,
		controlscale: LFNoise2.kr(10.1).range(0.5,0.95),
		vca: 0.091,
		resonance:reso,
		lowpassmode:1,
		linearity:1
	);

	Out.ar(out, DirtPan.ar(sig / 3, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\minieasel, { |out,pan,freq=440,attack=0.00001,release=1,reso=1.1,speed=1,accelerate=0,sustain=1,feedback=1.1,noise=0.05|

	var sig = SinOscFB.ar(freq*DirtFreqScale.kr(speed,accelerate,sustain), feedback) + WhiteNoise.ar(noise);
	var env = Env.perc(0.1,0.9).kr;

	sig = LPG.ar(
		input: sig,
		controlinput: env,
		controloffset: LFSaw.kr(0.1).range(0.0,0.2),
		controlscale: LFNoise2.kr(0.1).range(0.4,0.95),
		vca: LFNoise2.kr(1).unipolar,
		resonance:reso,
		lowpassmode:1,
		linearity:0);

	Out.ar(out, DirtPan.ar(sig / 3, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef.new(\bongo, {
	|out=0,
	amp=0.5,
	freq=141,
	width=0.95,
	attack=0.001,
	release=0.999,
	pan=0,
	lpgsustain=0.01,
	lpgoffset=0,
	lpgfilterscale=0.3,
	vcaness=0.75,
	resonance=1.1, speed=1, accelerate=0, sustain=1, feedback=1.5|

	// var sig = VarSaw.ar(freq - [ 0, freq/100.0 ], 0, width).sum;
	var sig = SinOscFB.ar(freq * DirtFreqScale.kr(speed, accelerate, sustain), feedback);
	var env = Env.perc(attack,release).kr(timeScale: lpgsustain.poll, doneAction: 0);

	sig = LPG.ar(
		input: sig,
		controlinput: env,
		controloffset: lpgoffset,
		controlscale: lpgfilterscale,
		vca: vcaness,
		resonance: resonance,
		lowpassmode:1,
		linearity:1
	);

  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef.new(\rongs, {|out=0, amp=0.25, pan=0, sustainTime=0.01, freq=440, structure=0.8,
    bright=0.59, damp=0.25, accent=0.4, harmonicstretch=0.5, pos=0.15, loss=0.15,
    attack=0.00001, release=0.1|
  var trig = Env.perc(attack, release);
  // var env = EnvGen.ar(trig, doneAction:2);

	var modeNum=3, cosFreq=0.025;
	var sig = Rongs.ar(
		trigger:trig.kr,
		sustain:trig.kr,
		f0:freq,
		structure:structure,
		brightness:bright,
		damping:damp,
		accent:accent,
		stretch:harmonicstretch,
		position:pos,
		loss:loss,
		modeNum:modeNum,
		cosFreq:cosFreq
	);

	DetectSilence.ar(in: sig, amp: 0.01, time: 0.1, doneAction: 2);

  // Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan));
}).add;
)
