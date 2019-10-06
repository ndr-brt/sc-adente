(
var parameters;
a = Bus.audio;
parameters = [
	\inBus, a,
	\outBus, 0,
	\attackTime, 4,
	\rate, 1,
	\lowPassCutoff, 7000,
	\highPassCutoff, 100,
	\postDistCutoff, 18000,
	\distAmt, 1
];

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

OSCdef.new(\gf_onoff, { |msg|
	postf("grain-freeze state: %\n", msg[1]);
	if (msg[1] == 1) {
		c = Synth(\grain_freeze, parameters, addAction: \addToTail);
	} {
		c.set(\releaseTime, 10);
		c.set(\gate, 0);
	}
},'/gf/onoff');

OSCdef.new(\gf_rate, { |msg| c.set(\rate, msg[1]) }, '/gf/rate');
OSCdef.new(\gf_lowPassCutoff, { |msg| c.set(\lowPassCutoff, msg[1]) }, '/gf/lowPassCutoff');
OSCdef.new(\gf_highPassCutoff, { |msg| c.set(\highPassCutoff, msg[1]) }, '/gf/highPassCutoff');
OSCdef.new(\gf_postDistCutoff, { |msg| c.set(\postDistCutoff, msg[1]) }, '/gf/postDistCutoff');
OSCdef.new(\gf_distAmt, { |msg| c.set(\distAmt, msg[1]) }, '/gf/distAmt');

{ Out.ar(a, SoundIn.ar(0)) }.play;
)