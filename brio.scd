NetAddr.langPort;

(

var parameters;

SynthDef(\sava, { |freq=440,amp=1,pan=0|
	var sig;
	sig = { SinOsc.ar(freq * ExpRand(0.5, 1.5)) }!5;
	sig = sig.sum;
	sig = sig * EnvGen.kr(Env([0,1,0],[1,1]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan);
	sig = sig * (amp / 5);
	Out.ar(0, sig!2);
}).add;


parameters = (
    dur: 0.5,
	lowFreq: 55,
	hiFreq: 220,
	amp: 0.3,
);

Pdef(\dronide,
	Pbindf(
		Pfuncn({ parameters }, inf),
		\instrument, \sava,
		\freq, Pexprand(Pfuncn({parameters[\lowFreq]},inf), Pfuncn({parameters[\hiFreq]},inf), inf),
		\amp, Pfunc { parameters[\amp] + rrand(-0.1,0.1) },
		\pan, Prand([-0.8,-0.4,0,0.4,0.8], inf),
	)
);

OSCdef.new(\state, { |msg, time, addr, port|
	postf("Drone state: %\n", msg[1]);
	if (msg[1] == 0) { Pdef(\dronide).stop; } { Pdef(\dronide).play; }
},'/drone/state');

OSCdef.new(\volume, { |msg, time, addr, port| parameters[\amp] = msg[1]; }, '/drone/volume');

OSCdef.new(\density, { |msg, time, addr, port| parameters[\dur] = msg[1]; }, '/drone/density');

OSCdef.new(\frequency, { |msg, time, addr, port|
		parameters[\lowFreq] = msg[1];
		parameters[\hiFreq] = msg[2];
	}, '/drone/frequency');

)
