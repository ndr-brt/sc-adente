
(
SynthDef(\complex, { |out, pan=0, sustain=1, begin=0, end=1, speed=1, accelerate=0|
	var osc1=1, osc2=1, fbk, outlet, folded, wrapped, volume, env, envLength, line, basefreq1, basefreq2;

	fbk = LocalIn.ar(2,0);
  basefreq1 = \freq1.kr(40) * DirtFreqScale.kr(speed, accelerate, sustain);
  basefreq2 = \freq2.kr(0.5) * DirtFreqScale.kr(speed, accelerate, sustain);
	osc1 = SinOsc.ar(basefreq1+(fbk[1].range(1,1000)*\fm1.ar(0.1)), 0+(fbk[1].range(-pi,pi)*\pm1.ar(0)), \mul1.ar(1)+(fbk[1]*\ring1.ar(1)), \add1.ar(0));
	osc2 = SinOsc.ar(basefreq2+(fbk[0].range(1,1000)*\fm2.ar(0.1)), 0+(fbk[1].range(-pi,pi)*\pm2.ar(0)), \mul2.ar(1)+(fbk[0]*\ring2.ar(1)), \add2.ar(0));
	LocalOut.ar([osc1, osc2]);
	folded = Fold.ar(osc1!2,\fold.ar(0.8).neg,\fold.ar(0.8));
	wrapped = Wrap.ar(osc1!2,\wrap.ar(0.9).neg,\wrap.ar(0.9));
	outlet = LeakDC.ar(Select.ar(\model.kr(2), [osc1!2, osc2!2, folded, wrapped]));

  env = Env.asr;
  envLength = sustain*(end-begin)/speed;
  line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  volume = IEnvGen.ar(env, line);
  Out.ar(out, DirtPan.ar(outlet, ~dirt.numChannels, pan, volume));
}).add
);
