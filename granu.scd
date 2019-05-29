(
SynthDef(\sinegrain, {arg pan, freq, amp;
	var grain = Saw.ar(freq, amp)*(XLine.kr(1.001,0.001,0.1,doneAction:2)-0.001);
	Out.ar(0,Pan2.ar(grain, pan))
}).add;
)

(
Pdef(\sinegrain, Pbind(
	\instrument, \sinegrain,
	\dur, Pgeom(0.1, 1.001, inf),
	\freq, Pexprand(100, 3000),
	\amp, Pexprand(0.05, 0.1),
	\pan, Pwhite(0, 1, inf),
)).play;
)

Pdef(\sinegrain).stop;



b = Buffer.read(s,"/home/andrea/Music/0_nuova/Suzanne Ciani - 2016 - Buchla Concerts, 1975/01 - concert at wbai free music store.flac");
(

SynthDef(\sfgrain, {arg bufnum=0, pan=0.0, startPos=0.0, amp=0.1, dur=0.04;
	var grain = PlayBuf.ar(2,bufnum, BufRateScale.kr(bufnum), 1, BufFrames.ir(bufnum)*startPos, 0)*(EnvGen.kr(Env.perc(0.01,dur),doneAction:2)-0.001);
	Out.ar(0,Pan2.ar(grain, pan))}).add;
)



(
Pdef(\sfgrain, Pbind(
	\instrument, \sfgrain,
	\dur, 0.5,
	\bufnum, b.bufnum,
	\startPos, Pexprand(0, 1, inf),
	\amp, Pexprand(0.005, 1, inf),
	\pan, Pwhite(0, 1, inf),
)).play;
)

Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(0.0,1.0),\amp, exprand(0.005,0.1), \pan, 1.0.rand2]);



SuperDirt.free;
Quarks.gui;