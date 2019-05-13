(
SynthDef(\cappu, { |freq=440, pan=0.0, t_gate=1.0, atk=0.01, amp=1.0, decay=0.8, rq=1|
	var sig, env;
	env = EnvGen.ar(Env.adsr(atk, decay), t_gate, doneAction:2);
	sig = SinOsc.ar(LFNoise1.kr(2).range(2,4) * freq * env / 2.sqrt) * env;
	sig = BPF.ar(sig, LFNoise2.kr(40).range(440, 880), rq);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pan))
}).add;
)

x = Synth.new(\cappu);
x.free;

(
~pathos = Pdef(\sona, Pbind(
	\instrument, \cappu,
	\dur, Pexprand(0.2, 0.8, inf),
	\freq, Prand([60, 43, 78, 43, 32, 54].choose.midicps, inf),
	\pan, Prand([-0.5, 0, 0.5], inf),
	\atk, Pexprand,
	\decay, Pexprand(5, 6),
	\amp, 0.2,
	\rq, Pexprand(0.1, 2, inf),
)
)
)

s.meter;
~pathos.play;
~pathos.stop;
~pathos.set(\amp, 0.1);