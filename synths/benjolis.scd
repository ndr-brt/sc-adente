/*
Instrument inspired from Rob Hordijk's Benjolin, it requires sc3-plugins (PulseDPW, SVF and DFM1)

outSignal:
1-triangle osc1,
2-square osc1,
3-triangle osc2,
4-pulse osc2,
5-XOR output,
6-Filter output

Original by Alejandro Olarte (see https://scsynth.org/t/benjolin-inspired-instrument/1074/4)
Modified by Mads Kjeldgaard
Adapted for tidal by ndr_brt
*/
(
SynthDef(\benjolis,{ |freq1= 40, freq2=4, scale=1, begin=0.16, end=0.0, runglerFilt=9, loop=0, resonance=0.82, hresonance=0.63, cutoff=40, hcutoff=400, gain=1, offset=0, n=6, amp=1, out, pan|
	var rungler1 = begin;
	var rungler2 = end;
	var outSignal = n;
	var lq = resonance;
	var hq = hresonance;
	var lFiltFreq = cutoff;
	var hFiltFreq = hcutoff;
	var filterType = offset;

	var sh0, sh1, sh2, sh3, sh4, sh5, sh6, sh7, sh8=1, filt, output, osc2freq;
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

	rungler = ((sh1/2.pow(8))+(sh2/2.pow(7))+(sh3/2.pow(6))+(sh4/2.pow(5))+(sh5/2.pow(4))+(sh6/2.pow(3))+(sh7/2.pow(2))+(sh8/2.pow(1)));

	buf = rungler;
	rungler = (rungler * scale.linlin(0,1,0,127));
	rungler = rungler.midicps;

	LocalOut.ar([rungler,buf]);

	filt = Select.ar(filterType, [
		RLPF.ar(pwm,(rungler*runglerFilt)+lFiltFreq,lq* -1 +1,gain),
		RHPF.ar(pwm,(rungler*runglerFilt)+hFiltFreq,hq* -1 +1,gain),
		SVF.ar(pwm,(rungler*runglerFilt)+lFiltFreq,lq,1,0,0,0,0,gain),
		DFM1.ar(pwm,(rungler*runglerFilt)+hFiltFreq,hq,gain,1)
	]);

	output = Select.ar(outSignal, [
		tri1, osc1, tri2, osc2, pwm, sh0, filt
	]);

	output = LeakDC.ar(output, 0.99).tanh;
	output = output * amp ! 2;
	OffsetOut.ar(out, DirtPan.ar(output, ~dirt.numChannels, pan));
}).add;
)
// add ranges for controlling with a GUI
/*
Spec.add(\freq1, ControlSpec( 20.0, 14000.0, \exp, 0, 70, "Hz") );
Spec.add(\freq2, ControlSpec( 0.1, 14000.0, \exp, 0, 4, "Hz") );
Spec.add(\filtFreq, ControlSpec( 20.0, 20000.0, \exp, 0, 40, "Hz") );
Spec.add(\q, ControlSpec( 0.0, 1.0, \lin, 0, 0.82) );
Spec.add(\gain, ControlSpec( 0.0, 3.0, \lin, 0, 1) );
Spec.add(\filterType, ControlSpec( 0.0, 3.0, \lin, 1, 0) );
Spec.add(\rungler1, ControlSpec( 0.0, 1.0, \lin, 0, 0.16) );
Spec.add(\rungler2, ControlSpec( 0.0, 1.0, \lin, 0, 0) );
Spec.add(\runglerFilt, ControlSpec( 0.0, 1.0, \lin, 0, 9) );
Spec.add(\loop, ControlSpec( 0.0, 1.0, \lin, 0, 1) );
Spec.add(\scale, ControlSpec( 0.0, 1.0, \lin, 0, 1) );
Spec.add(\outSignal, ControlSpec( 0.0, 6.0, \lin, 1, 6) );
*/