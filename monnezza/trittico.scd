(
SynthDef(\ciao, { |speed = 2, fund = 320|
	var sig, freq, out, phase, amp, pan;
	freq = LFNoise0.kr(speed * speed / 2);
	phase = Dust.kr(0.5);
	amp = LFNoise2.kr(8).range(0.1, 1);
	pan = LFNoise1.kr(20).range(-1, 1);
	sig = SinOsc.ar([fund * freq, fund / freq], phase) * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

x = Synth.new(\ciao);

x.set(\fund, 400);
x.set(\speed, 4);


x.free;


s.freeAll;

