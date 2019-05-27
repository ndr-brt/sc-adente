p = ProxySpace.new(s, \p);
p.fadeTime = 20;
p.clock = TempoClock.default; ~c.quant = 1.0;

~c.play;
~c[0] = { FreeVerb.ar(SinOsc.ar([SinOsc.kr(Rand(0.01, 0.5)).exprange(100, 302), SinOsc.kr(Rand(0.1,0.5)).exprange(Rand(100,257), 352)]), 1, 1, 1).max * 0.7 };
~c[1] = { (min(LFSaw.ar([20, 202]), Impulse.ar([14, 125])) + Dust.ar(10)) * 0.15 };
~c[2] = { Ringz.ar(Impulse.ar(1.2), [300, 340], 0.9).dup * SinOsc.ar(2).range(-1,1).dup.max * 0.9 };

~c.fadeTime = 4;
~c.send;

(
~d = { |pan=0|
	Pan2.ar(
			Ringz.ar(
				VarSaw.ar(30),
				Rand(100, 700),
				Rand(0.5,2.5)
		).dup.max.sum, Rand(-1,1)

	)
}
)
~dpan = { Rand(-1,1) };
~d.mold(2);
~d.send;
~d.play;
~d.map(\pan, ~dpan);

~d.end(3);
~c.end(3);
p.end(3);

(
{
	2.do {
		~d.send;
		exprand(1.5, 3.5).wait;
	}
}.fork;
)


p = ProxySpace.push(s.boot);
~x.play; ~y.play;

~x = { Ringz.ar(Impulse.ar(5), LFSaw.kr(13).exprange(200, 1400 ! 2), 0.05).log10 };
~y = { Ringz.ar(Impulse.ar(1.5), LFSaw.kr(11).exprange(300, 3400 ! 2), 0.05).distort };

~x.clock = TempoClock.default; ~x.quant = 1.0;
~y.clock = TempoClock.default; ~y.quant = 1.0;

p.clock = TempoClock.default; p.quant = 1.0;

~y = { Ringz.ar(Impulse.ar(1), 800, 0.05).dup };

~z.play;
~z = { Ringz.ar(Impulse.ar(1), [500, 514], 0.8).dup * 0.1};
~z = { Ringz.ar(Impulse.ar(1), exprand(300, 400 ! 2), 1.8).dup * 0.1 };
~z = { Ringz.ar(Impulse.ar(7), SinOsc.kr(7).exprange(300, 3400 ! 2), 0.08).max * 0.5 };
~z.end;

p.end(3);

~z.play; ~y.play;
~z = { Ringz.ar(Impulse.ar(2), exprand(300, 3400 ! 2), 0.08).dup * 0.2 };
~y.quant = [1, 0.3]; // offset of 0.3, quant of 1.0
~y = { Ringz.ar(Impulse.ar(1), 600, 0.05).dup };
~y.quant = [2, 1/3]; // offset of 1/3, quant of 2.0
~y = { Ringz.ar(Impulse.ar(0.5), 600, 0.05).dup };

p.makeTempoClock(2.0);

~y.play; ~x.play;
~y.quant = 1; // set the quant back to 1 and the offset to 0
~y = { Ringz.ar(Impulse.ar(~tempo.kr), 600, 0.05).dup }; // impulse uses tempo
~x = Pbind(\instrument, \default, \freq, Pseq([300, 400], inf)); // pattern uses tempoclock

p.clock.tempo = 1.0; // set the tempo to 1
p.clock.tempo = 2.2; // set the tempo to 2.2

ProxySynthDef.sampleAccurate = false;

~x.play;

// the grain frees itself
~x = { SinOsc.ar(800) * EnvGen.ar(Env.perc(0.001, 0.03, 0.4), doneAction: Done.freeSelf) };


// jittery tone.
(
r = Routine {
    loop {
        200.do { arg i;
            ~x.spawn;
            (0.005).wait;
        };
        1.wait;
    }
}.play;
)

ProxySynthDef.sampleAccurate = true;

// steady tone, because sample accurate.

~x.rebuild;

r.stop;

p.clear; // remove all.