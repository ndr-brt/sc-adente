s.meter;
s.plotTree;
(
SynthDef(\burp, { |freq=440,t_gate=1,amp=1,atk=0.01,dec=0.3,sus=0.5,out=0,pan=0|
	var sig, env, mod, modmod;
	env = EnvGen.kr(Env.adsr(atk, dec, sus), t_gate, doneAction:2);
	modmod = LFNoise0.kr(2).range(2,10);
	mod = LFNoise1.kr(modmod).range(0.5,1);
	sig = VarSaw.ar(freq*mod) * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

SynthDef(\ringz, {|amp=1,inpfrq=10|
	var sig,input,arrayRef;
	input = Impulse.ar(inpfrq);
	arrayRef = `[LocalIn.ar.clip2(LFPulse.kr([1,2,1/8]).sum/2)*100100];
	a=DynKlank.ar(arrayRef,input);
	LocalOut.ar(a);
	sig = LPF.ar(a).clip2 * amp;
	Out.ar(0,sig!2);
}).add;

SynthDef(\rev, { |in=0,out=0,mix=0.33,room=0.5,damp=0.5|
	var sig;
	sig = SoundIn.ar(in);
	sig = FreeVerb.ar(sig,mix,room,damp);
	out = Out.ar(out, sig!2);
}).add;
)

(
Pdef(\pat, Pbind(
	\instrument, \burp,
	\dur, Prand([0.01,0.02,0.05],inf),
	\amp, Pexprand(0.5, 0.8),
	\freq, Pexprand(50, 110, inf),
	\atk, Pexprand(0.01,0.06,inf),
	\dec, Pexprand(0.2,0.5,inf),
	\sus, Pexprand(0.3,0.8,inf),
	\pan, Prand([-0.8,-0.4,0,0.4,0.8],inf),
	\out, 0,
));
)

x = Synth(\ringz, [\amp, 0.2]);
x.set(\amp, 1);
x.set(\inpfrq, 32);
x.free;

s.reboot;

~reverb = Synth(\rev, [\in, ~reverbBus, \mix, 1]);
~reverbBus = Bus.audio(s, 2)


Pdef(\pat).play;
Pdef(\pat).stop;
