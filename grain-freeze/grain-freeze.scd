(
SynthDef(\grain_freeze, {
	|
	inBus = 0, outBus = 0, amp = 1,
	trigRate = 60, grainDur = 0.35, pos = 0.3, rate = 1,
	attackTime = 0.5, decayTime = 0, sustainLevel = 1, releaseTime = 2, gate = 1,
	lowPassCutoff = 7000, highPassCutoff = 100, postDistCutoff = 18000, distAmt = 1
	|

	var input = In.ar(inBus, 1);
	var localBuf = LocalBuf.new(SampleRate.ir * 1, 1).clear;
	var record = RecordBuf.ar(input, localBuf, loop: 0);

	var grainTrig = Dust.ar(trigRate);
	var granulation = GrainBuf.ar(1, grainTrig, grainDur, localBuf, rate, pos);

	var lpf = LPF.ar(granulation, lowPassCutoff);
	var hpf = HPF.ar(lpf, highPassCutoff);
	var dist = LPF.ar((hpf * distAmt).distort, postDistCutoff);

	var env = EnvGen.kr(Env.dadsr(1, attackTime, decayTime, sustainLevel, releaseTime), gate, amp, doneAction: 2);

	Out.ar(outBus, (dist * env)!2);
}).add;

// OSCdef.new(\gf_onoff, { |msg, time, addr, port|
// 	postf("grain-freeze state: %\n", msg[1]);
// 	if (msg[1] == 1) { Pdef(\dronide).stop; } { Pdef(\dronide).play; }
// },'/drone/state');

a = Bus.audio;
// then this:
{ Out.ar(a, SoundIn.ar(0)) }.play;
)



//// examples:

// execute this:


// sing, whistle, or play a steady held note, then execute this line of code:
c = Synth(\grain_freeze, [\inBus, a, \outBus, 0, \attackTime, 4], addAction: \addToTail);


// play at half the speed, (one octave down):
c.set(\rate, 0.7);

// set lowpass cutoff:
c.set(\lowPassCutoff, 2700);

// set high pass cutoff:
c.set(\highPassCutoff, 200);

// reset it:
c.set(\highPassCutoff, 20);

// set distortion (CAREFUL!! Gets loud):
(
c.set(\postDistCutoff, 160);
c.set(\distAmt, 44.dbamp);
)

// increase release time and free:
(
c.set(\releaseTime, 10);
c.set(\gate, 0);
)

