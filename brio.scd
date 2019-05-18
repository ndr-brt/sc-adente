// crucial-library required

(

var droneParams, weirdpcParams, ringParams;
~osc = NetAddr.new("127.0.0.1", 8080);

// DRONE
SynthDef(\dronide, { |freq=440,amp=1,pan=0|
	var sig = { SinOsc.ar(freq * ExpRand(0.5, 1.5)) }!5;
	sig = sig.sum;
	sig = sig * EnvGen.kr(Env([0,1,0],[1,1]), 1, doneAction:2);
	sig = Pan2.ar(sig, pan);
	sig = sig * (amp / 5);
	Out.ar(0, sig!2);
}).add;

droneParams = (
    dur: 0.5,
	lowFreq: 55,
	hiFreq: 220,
	amp: 0.2,
);
~osc.sendMsg("/drone/volume", droneParams[\amp]);
~osc.sendMsg("/drone/lofreq", droneParams[\lowFreq]);
~osc.sendMsg("/drone/hifreq", droneParams[\hiFreq]);
~osc.sendMsg("/drone/density", droneParams[\dur]);

Pdef(\dronide,
	Pbindf(
		Pfuncn({ droneParams }, inf),
		\instrument, \dronide,
		\freq, Pexprand(Pfuncn({droneParams[\lowFreq]},inf), Pfuncn({droneParams[\hiFreq]},inf), inf),
		\amp, Pfunc { droneParams[\amp] },
		\pan, Prand([-0.8,-0.4,0,0.4,0.8], inf),
	)
);

OSCdef.new(\d_state, { |msg, time, addr, port|
	postf("Drone state: %\n", msg[1]);
	if (msg[1] == 0) { Pdef(\dronide).stop; } { Pdef(\dronide).play; }
},'/drone/state');
OSCdef.new(\d_volume, { |msg, time, addr, port| droneParams[\amp] = msg[1]; }, '/drone/volume');
OSCdef.new(\d_density, { |msg, time, addr, port| droneParams[\dur] = msg[1]; }, '/drone/density');
OSCdef.new(\d_lofreq, { |msg, time, addr, port| droneParams[\lowFreq] = msg[1]; }, '/drone/lofreq');
OSCdef.new(\d_hifreq, { |msg, time, addr, port| droneParams[\hiFreq] = msg[1]; }, '/drone/hifreq');

// RING
SynthDef(\ringz, {|amp=1, freq=10, cutoff=440, gate=1|
	var sig;
	var input = Impulse.ar(freq);
	var arrayRef = `[LocalIn.ar.clip2(LFPulse.kr([1,2,1/8]).sum/2)*100100];
	a = DynKlank.ar(arrayRef,input) * amp;
	LocalOut.ar(a);
	sig = LPF.ar(a, cutoff) * amp;
	sig = sig * EnvGen.kr(Env.adsr, gate, amp, doneAction: 2);
	Out.ar(0, sig!2);
}).add;

ringParams = (
	cutoff: 400,
	amp: 0.01
);
~osc.sendMsg("/ring/volume", ringParams[\amp]);
~osc.sendMsg("/ring/cutoff", ringParams[\cutoff]);
~osc.sendMsg("/ring/freq", ringParams[\freq]);

OSCdef.new(\r_state, { |msg, time, addr, port|
	postf("Ring state: %\n", msg[1]);
	if (msg[1] == 0) { ~ringz.set(\gate, 0); } { ~ringz = Synth(\ringz, [\cutoff, ringParams[\cutoff], \amp, ringParams[\amp]]); }
},'/ring/state');
OSCdef.new(\r_volume, { |msg, time, addr, port| ~ringz.set(\amp, msg[1]); }, '/ring/volume');
OSCdef.new(\r_cutoff, { |msg, time, addr, port| ~ringz.set(\cutoff, msg[1]); }, '/ring/cutoff');

// WEIRDPC
SynthDef(\weirdpc, { |resf=880, modf=15, maxdelaytime=2, sustain=8, gate=1|
	var mod = LFNoise0.kr(modf).exprange(110,880);
	var sig = SinOsc.ar(mod!2,0,0.2);
	sig = CombN.ar(sig,maxdelaytime,0.2,10);
	sig = HPF.ar(sig,48,16);
	sig = Resonz.ar(sig,resf,0.5,8);
	sig = Limiter.ar(sig, 0.1);
	sig = sig * EnvGen.kr(Env([0,1,1,0],[1,sustain,1]), gate, doneAction:2);
	Out.ar(0, sig!2);
}).add;

weirdpcParams = (
	resf: 880,
	speed: 15,
	maxdelaytime: 2,
	sus: 8,
);

OSCdef.new(\w_launch, { |msg, time, addr, port|
	postf("Launch weird pc: %\n", msg[1]);
	if (msg[1] == 1) { Synth(\weirdpc, [\sus, 3, \speed, 20, \maxdelaytime, 0.9, \resf, 540]); }
},'/weirdpc/launch');

)