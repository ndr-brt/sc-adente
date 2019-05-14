NetAddr.langPort;
s.meter;
(

var droneParams;

// DRONE
SynthDef(\dronide, { |freq=440,amp=1,pan=0|
	var sig;
	sig = { SinOsc.ar(freq * ExpRand(0.5, 1.5)) }!5;
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
	amp: 0.3,
);

Pdef(\dronide,
	Pbindf(
		Pfuncn({ droneParams }, inf),
		\instrument, \dronide,
		\freq, Pexprand(Pfuncn({droneParams[\lowFreq]},inf), Pfuncn({droneParams[\hiFreq]},inf), inf),
		\amp, Pfunc { droneParams[\amp] + rrand(-0.1,0.1) },
		\pan, Prand([-0.8,-0.4,0,0.4,0.8], inf),
	)
);

OSCdef.new(\d_state, { |msg, time, addr, port|
	postf("Drone state: %\n", msg[1]);
	if (msg[1] == 0) { Pdef(\dronide).stop; } { Pdef(\dronide).play; }
},'/drone/state');
OSCdef.new(\d_volume, { |msg, time, addr, port| droneParams[\amp] = msg[1]; }, '/drone/volume');
OSCdef.new(\d_density, { |msg, time, addr, port| droneParams[\dur] = msg[1]; }, '/drone/density');
OSCdef.new(\d_frequency, { |msg, time, addr, port|
		droneParams[\lowFreq] = msg[1];
		droneParams[\hiFreq] = msg[2];
	}, '/drone/frequency');

// RING
SynthDef(\ringz, {|amp=1,inpfrq=10,cutoff=440|
	var sig,input,arrayRef;
	input = Impulse.ar(inpfrq);
	arrayRef = `[LocalIn.ar.clip2(LFPulse.kr([1,2,1/8]).sum/2)*100100];
	a = DynKlank.ar(arrayRef,input) * amp;
	LocalOut.ar(a);
	sig = LPF.ar(a, cutoff) * amp;
	Out.ar(0, sig!2);
}).add;

OSCdef.new(\r_state, { |msg, time, addr, port|
	postf("Ring state: %\n", msg[1]);
	if (msg[1] == 0) { ~ringz.free; } { ~ringz = Synth(\ringz, [\cutoff, 440, \amp, 0.01]); }
},'/ring/state');
OSCdef.new(\r_volume, { |msg, time, addr, port| ~ringz.set(\amp, msg[1]); }, '/ring/volume');
OSCdef.new(\r_cutoff, { |msg, time, addr, port| ~ringz.set(\cutoff, msg[1]); }, '/ring/cutoff');

)

SynthDef(\weirdpc, {
	var sig;
	sig = LFNoise0.kr(12).exprange(110,880);
	sig = Resonz.ar(HPF.ar(CombN.ar(SinOsc.ar(sig!2,0,0.2),2,0.2,10),48,16),880,0.5,8);
	Out.ar(0, sig);
}).add;

Synth(\weirdpc); 