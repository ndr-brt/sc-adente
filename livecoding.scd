t = TempoClock.default;

(
t.schedAbs(t.nextBar, {
	Routine.run({
		~bass.stop;
		Server.default.sync;
		~bass = Pbind(
			\dur, Pseq([0.5, 2, 1.5, 0.5], inf),
			\note, Prand(s.semitones,inf),
			\pan, Pwhite(-0.5, 0.5, inf),
			\sustain, Pwhite(2, 3, inf),
			\octave, 3,
			\detune, Pseq([0, 2, 0, -2],inf)
		).play;
	});
});
)

(
t.schedAbs(t.nextBar, {
    Routine.run({
        ~hat.stop;
        //s.sync;
        ~hat = Pbind(
			\instrument, \click,
			\dur, Pseq([1.5, 0.5, 2, 0.5], inf),
			\amp, 0.05,
			\noise, Pseq([300, 550, 800, 550], inf)
		).play;
        })
    }
);
)

t.next;

(
s = Scale.purvi;

Pdef(\x, Pbind(
	\dur, Pexprand(0.8, 1.2, inf),
	\note, Prand(s.semitones,inf),
	\pan, Pwhite(-0.5, 0.5, inf),
	\sustain, Pwhite(2, 3, inf),
	\stretch, Pkey(\dur),
	\octave, 3,
	//\detune, Pseq([0, 2, 0, -2],inf)
));

SynthDef(\click, { |amp=0.1, noise=300|
	var sig = PinkNoise.ar * SinOsc.ar(noise);
	sig = sig * EnvGen.kr(Env.perc, doneAction: 2);
	sig = sig * amp;
	Out.ar(0, sig!2);
}).add;

Pdef(\hat, Pbind(
	\instrument, \click,
	\dur, Pseq([1.5, 0.5, 2], inf),
	\amp, 0.05,
	\noise, Pseq([30, 10, 80], inf)
));

SynthDef(\saw, {|freq=440, sustain=2, attack=0.4, release=0.4, mod=50|
	var sig = LFSaw.ar(freq + LFNoise1.kr(mod).range(-80,40));
	sig = sig * 0.1 * EnvGen.kr(Env([0,1,1,0], [attack, sustain, release], 2), doneAction: 2);
	sig = BPF.ar(sig, 220);
	sig = FreeVerb.ar(sig, Rand(0.3, 1), Rand(0.3, 1), Rand(0.3, 1));
	Out.ar(0, [sig, sig + Delay1.ar(sig)]);
}).add;

Pdef(\saw, Pbind(
	\instrument, \saw,
	\freq, Pwhite(110, 220, inf),
	\dur, Pwhite(3,4, inf),
	\sustain, Pkey(\dur),
	\attack, Pwhite(0.3, 0.5, inf),
	\release, Pwhite(0.3, 0.5, inf),
	\mod, Pwhite(50, 120, inf)
));
)
Pdef(\x).play;
Pdef(\saw).play;
Pdef(\saw).pause;
Pdef(\hat).play;
Pdef(\hat).pause;
Pdef(\x).stop;