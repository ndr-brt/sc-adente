b = Buffer.read(s,"/home/andrea/Downloads/Owl_GreatHornedAlarmedAdult.wav");
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
	\startPos, Pexprand(0, 0.3, inf),
	\amp, Pexprand(0.005, 1, inf),
	\pan, Pwhite(0, 1, inf),
)).play;
)

Synth(\sfgrain,[\bufnum, b.bufnum, \startPos,rrand(0.0,1.0),\amp, exprand(0.005,0.1), \pan, 1.0.rand2]);



SuperDirt.free;
Quarks.gui;
{SinOsc.ar}.play;