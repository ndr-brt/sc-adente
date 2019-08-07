/*
Instrument inspired from Rob Hordijk's Benjolin, it requires sc3-plugins (PulseDPW, SVF and DFM1)

outSignal (n):
1-triangle osc1,
2-square osc1,
3-triangle osc2,
4-pulse osc2,
5-XOR output,
6-High pass output
7-Band pass output
8-Low pass output

Original by Alejandro Olarte (see https://scsynth.org/t/benjolin-inspired-instrument/1074/4)
Modified by Mads Kjeldgaard
Adapted for tidal by ndr_brt
*/
(
SynthDef(\benjolis,{
	|
	oscA=40, oscB=4, runA=0.0, runB=0.0,
	freq=40, runF=9, res=0.32, offset=1, loop=0,
	n=8, gain=1, amp=1, out, pan
	|
	var rungler1 = runA;
	var rungler2 = runB;
	var outSignal = n;
	var freq1 = oscA;
	var freq2 = oscB;
	var filtFreq = freq;
	var runglerFilt = runF;

	var lowPass, bandPass, highPass;
	var sh0, sh1, sh2, sh3, sh4, sh5, sh6, sh7, sh8=1, output, osc2freq;
	var bufR = LocalIn.ar(2,0);
	var rungler = bufR.at(0);
	var buf = bufR.at(1);
	var sr = SampleDur.ir;

	var tri1 = LFTri.ar((rungler*rungler1)+freq1);
	var tri2 = LFTri.ar((rungler*rungler2)+freq2);
	var osc1 = PulseDPW.ar((rungler*rungler1)+freq1);
	var osc2 = PulseDPW.ar((rungler*rungler2)+freq2);

	var pwm = BinaryOpUGen('>', (tri1 + tri2),(0));

	osc1 = ((buf*loop)+(osc1* (loop* -1 +1)));
	sh0 = BinaryOpUGen('>', osc1, 0.5);
	sh0 = BinaryOpUGen('==', (sh8 > sh0), (sh8 < sh0));
	sh0 = (sh0 * -1) + 1;

	sh1 = DelayN.ar(Latch.ar(sh0,osc2),0.01,sr);
	sh2 = DelayN.ar(Latch.ar(sh1,osc2),0.01,sr*2);
	sh3 = DelayN.ar(Latch.ar(sh2,osc2),0.01,sr*3);
	sh4 = DelayN.ar(Latch.ar(sh3,osc2),0.01,sr*4);
	sh5 = DelayN.ar(Latch.ar(sh4,osc2),0.01,sr*5);
	sh6 = DelayN.ar(Latch.ar(sh5,osc2),0.01,sr*6);
	sh7 = DelayN.ar(Latch.ar(sh6,osc2),0.01,sr*7);
	sh8 = DelayN.ar(Latch.ar(sh7,osc2),0.01,sr*8);

	rungler = (
		(sh1/2.pow(8))
		+(sh2/2.pow(7))
		+(sh3/2.pow(6))
		+(sh4/2.pow(5))
		+(sh5/2.pow(4))
		+(sh6/2.pow(3))
		+(sh7/2.pow(2))
		+(sh8/2.pow(1))
	);

	buf = rungler;
	rungler = (rungler * offset.linlin(0,1,0,127));
	rungler = rungler.midicps;

	LocalOut.ar([rungler,buf]);

	lowPass = RLPF.ar(pwm,(rungler*runglerFilt)+filtFreq,res* -1 +1,gain);
	bandPass = Resonz.ar(pwm,(rungler*runglerFilt)+filtFreq,res* -1 +1,gain);
	highPass = RHPF.ar(pwm,(rungler*runglerFilt)+filtFreq,res* -1 +1,gain);

	output = Select.ar(outSignal, [
		tri1, osc1, tri2, osc2, pwm, sh0, highPass, bandPass, lowPass
	]);

	output = LeakDC.ar(output * amp);
	OffsetOut.ar(out, DirtPan.ar(output, ~dirt.numChannels, pan));
}).add;
)
// add ranges for controlling with a GUI

/*
(
Spec.add(\oscA, ControlSpec( 20.0, 14000.0, \exp, 0, 70, "Hz") );
Spec.add(\oscB, ControlSpec( 0.1, 14000.0, \exp, 0, 4, "Hz") );
Spec.add(\runF, ControlSpec( 20.0, 20000.0, \exp, 0, 40, "Hz") );
Spec.add(\q, ControlSpec( 0.0, 1.0, \lin, 0, 0.82) );
Spec.add(\runA, ControlSpec( 0.0, 1.0, \lin, 0, 0.16) );
Spec.add(\runB, ControlSpec( 0.0, 1.0, \lin, 0, 0) );
Spec.add(\runF, ControlSpec( 0.0, 1.0, \lin, 0, 9) );
Spec.add(\loop, ControlSpec( 0.0, 1.0, \lin, 0, 1) );
Spec.add(\offset, ControlSpec( 0.0, 1.0, \lin, 0, 1) );
Spec.add(\n, ControlSpec( 0.0, 8.0, \lin, 1, 8) );
Spec.add(\gain, ControlSpec( 0.0, 3.0, \lin, 0, 1) );
)


x = Synth(\benjolis);
x.set(\q, 0.8);
x.set(\n, 0);
x.set(\freq, 3000);
x.set(\oscA, 40);
x.set(\oscB, 120);
x.set(\runA, 0.05);
x.set(\runB, 0.29);
x.set(\runF, 0.19);
x.set(\scale, 0.89);
x.set(\loop, 0.45);
x.free;
*/
