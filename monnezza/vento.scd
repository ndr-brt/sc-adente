(
SynthDef(\soffio, { |freq=440, pan=0.0, t_gate=1.0, atk=0.01, amp=1.0, decay=0.8, rq=1|
	var sig, env, imp;
	imp = LFNoise1.kr(100);
	env = EnvGen.ar(Env.new([0,1,1,0],[2,2],1), t_gate, doneAction:2);
	sig = SinOsc.ar(LFNoise1.kr(2).range(2,4) * freq * env / 2.sqrt) * env;
	sig = BPF.ar(sig, LFNoise2.kr(40).range(440, 880), rq);
	sig = sig * amp * imp;
	Out.ar(0, Pan2.ar(sig, pan))
}).add;
)

(
~vento = Pdef(\vento, Pbind(
	\instrument, \soffio,
	\dur, Pexprand(0.5, 1, inf),
	\freq, Prand([40, 43, 48, 53, 32, 54].midicps, inf),
	\pan, Prand([-0.5, 0, 0.5], inf),
	\atk, 0.1,
	\decay, Pexprand(1, 2),
	\amp, 0.4,
	\rq, Pexprand(0.1, 1.5, inf),
)
)
)

s.meter;
s.plotTree;
~vento.play;
~vento.stop;