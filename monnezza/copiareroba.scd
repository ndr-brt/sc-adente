~reverbBus = Bus.audio(s, 2);

(
SynthDef(\burp, { |freq=440,t_gate=1,amp=1,atk=0.01,dec=0.3,sus=0.5,out=0,pan=0|
	var env = EnvGen.kr(Env.adsr(atk, dec, sus), t_gate, doneAction:2);
	var modmod = LFNoise0.kr(2).range(2,10);
	var mod = LFNoise1.kr(modmod).range(0.5,1);
	var sig = VarSaw.ar(freq*mod) * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;

Ndef(\reverb, { |in=0,out=0,mix=0.33,room=0.5,damp=0.5|
	var sig = SoundIn.ar(~reverbBus);
	sig = FreeVerb.ar(sig, mix, room, damp);
	out = Out.ar(out, sig!2);
});

Pdef(\pat, Pbind(
	\instrument, \burp,
	\dur, Prand([0.1,0.2,0.5],inf),
	\amp, Pexprand(0.7, 1),
	\freq, Pexprand(50, 110, inf),
	\atk, Pexprand(0.01,0.06,inf),
	\dec, Pexprand(0.2,0.5,inf),
	\sus, Pexprand(0.3,0.8,inf),
	\pan, Prand([-0.8,-0.4,0,0.4,0.8],inf),
	\stretch, Pkey(\dur),
	\out, 0,
));

)

Pdef(\pat).play;
Pdef(\pat).stop;
