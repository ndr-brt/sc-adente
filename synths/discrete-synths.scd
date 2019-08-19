(

SynthDef(\blow, { |out, decay=0, sustain=0.03, freq, pan, accelerate, voice = 0.5, semitone=12, resonance=0.3, lfo=1, pitch1=1, width = 0.3|
	var imp = LFNoise1.kr(80);
	var basefreq = freq * Line.kr(1, 1+accelerate, sustain);
	var lfof1 = min(basefreq*10*pitch1, 22000);
	var lfof2 = min(lfof1 * (lfo + 1), 22000);
	var sig = LPF.ar(
		SinOsc.ar(
			LFNoise1.kr(3).range(2,4) * basefreq / 2.sqrt
		),
		LFNoise2.kr(40).range(lfof1, lfof2), resonance
	);
	var env = LFGauss.ar(sustain, width, loop: 0).range(0, 1);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;

)