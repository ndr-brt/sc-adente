(
SynthDef(\entropy, { |out, sustain=1, pan, decay=0, width=0.3, attack, release|
	var env = EnvGen.kr(Env.new([0,1,1,0],[attack, sustain, release], -8),doneAction: 2);
	var caboos = LFNoise0.kr(15);
	var sig = SinOscFB.ar(
		Pulse.kr(
			LFPulse.kr(SinOsc.kr(0.3).range(1, caboos.fold(1, 4)), Crackle.kr.range(0, 2pi)),
			LFNoise1.kr(7).range(0.1, caboos.slew(0.3, 0.9))
		).exprange(LFNoise2.kr(3).range(Line.kr(300, 800, 17), caboos.range(800, 1400)))
	)!2;

	sig = sig + Impulse.ar(caboos.slew(0.1, 0.9).range(300, 800));

	sig = sig / 2;

	sig = FreeVerb.ar(sig,
		SinOsc.kr(1/3).range(0.3, 0.9),
		LFSaw.kr(1/5).range(0.3, 0.9),
		SinOsc.kr(1/7).range(0.3, 0.9)
	);
	sig = [sig, sig + Delay1.ar(sig)];
	sig = sig.tanh;

	Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
);

(
SynthDef(\blow, { |out, decay=0, sustain=0.03, freq, pan, accelerate, voice=0.5,
    semitone=12, resonance=0.3, lfo=1, pitch1=1, width=0.3, speed=1|
	var imp = LFNoise1.kr(80);
	var basefreq = DirtFreqScale.kr(speed, accelerate, sustain);
	var lfof1 = min(basefreq*10*pitch1, 22000);
	var lfof2 = min(lfof1 * (lfo + 1), 22000);
	var sig = LPF.ar(
		SinOsc.ar(
			LFNoise1.kr(3).range(2,4) * basefreq / 2.sqrt
		),
		LFNoise2.kr(40).range(lfof1, lfof2), resonance
	);
	var env = LFGauss.ar(sustain, width, loop: 0).range(0, 1);
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))
}).add;
);

(
SynthDef(\gfreeze, {
	| out = 0, amp = 1, freq = 440.0, gain,
	trigRate = 60, grainDur = 0.35, pos = 0.3, rate = 1,
	attack = 0.1, sustain = 1, release = 2, gate = 1,
	lowPassCutoff = 4000, highPassCutoff = 100, pan = 0
	|

	var input = LFSaw.ar(freq).distort * gain;
	var localBuf = LocalBuf.new(SampleRate.ir * 1, 1).clear;
	var record = RecordBuf.ar(input, localBuf, loop: 0);

	var grainTrig = Dust.ar(trigRate);
	var granulation = GrainBuf.ar(1, grainTrig, grainDur, localBuf, rate, pos);

	var lpf = LPF.ar(granulation, lowPassCutoff);
	var signal = HPF.ar(lpf.distort, highPassCutoff);

	var env = EnvGen.kr(Env.asr(attack, sustain, release), gate, amp, doneAction: 2);

	OffsetOut.ar(out, DirtPan.ar(signal / 10, ~dirt.numChannels, pan, env));
}).add;
);

(
SynthDef(\uou, { |out=0,freq=440,sustain=1,pan=0,accelerate=0,hold=0.5,begin=0,end=1, speed=1|
  var line = Line.ar(begin, end, sustain*(end-begin), doneAction: Done.freeSelf);
  var env = Env.adsr;
  var volume = IEnvGen.ar(env, line);
  var mod = LFNoise1.kr(LFNoise0.kr(8).range(10,20)).range(0.9,1.1).distort;
  var sig = VarSaw.ar(freq * DirtFreqScale.kr(speed, accelerate, sustain) * mod, accelerate, hold);

  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, volume));
}).add;
);

(
SynthDef(\zonta, { |out=0,freq=440,pan=0,detune=0,attack=0.001,release=0.5,sustain=1,begin=0,end=1,speed=1,accelerate=0|
  var line = Line.ar(begin, end, sustain*(end-begin), doneAction: Done.freeSelf);
  var env = Env.perc(attack, release, 8);
  var volume = IEnvGen.ar(env, line);
  var width = LFNoise0.kr(0.5).range(0.3,0.7);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var sig = (
    Pulse.ar(basefreq + (detune * 3), width) +
    Saw.ar(basefreq/4 + (detune * 3), width.sin) +
    SinOsc.ar(basefreq/2 + (detune * 3), pi/2) +
    Phaser.ar(basefreq*4 + (detune * 3), width.cos)
  )/4;

  sig = MoogLadder.ar(sig, basefreq*8, width);

  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, volume));
}).add;
);

(
SynthDef(\pingz, { |out,pan,freq=440,attack=0.00001,release=1|
	var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	var signal = Resonz.ar(env, freq, 0.99);

	OffsetOut.ar(out, DirtPan.ar(signal * 2 , ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\pingm, { |out,pan,freq=440,attack=0.00001,release=1|
	var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	var signal = MoogLadder.ar(env, freq, 0.99);

	OffsetOut.ar(out, DirtPan.ar(signal*2, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\pingr, { |out,pan,freq=440,attack=0.00001,release=1|
	var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	var signal = RLPFD.ar(env, freq, 1/freq, 0.5);

	OffsetOut.ar(out, DirtPan.ar(signal*8, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\pings, { |out,pan,freq=440,attack=0.00001,release=1|
	var env = EnvGen.ar(Env.perc(attack, release), doneAction:2);
	var signal = Streson.ar(env, 1/freq, 0.5, 0.8);

	OffsetOut.ar(out, DirtPan.ar(signal/3, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\pulsa, { |out=0, freq=220, attack=0.1, release=1, pan=0, accelerate=0, speed=1, sustain=1|
  var env = EnvGen.kr(Env.perc(attack, release), doneAction: 2);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var signal = Pulse.ar(basefreq, SinOsc.kr(3000/basefreq));
  signal = (LocalIn.ar(1).distort) + (Delay1.ar(signal));
  signal = MoogLadder.ar(signal, basefreq*2.7, 0);

  LocalOut.ar(signal);

  Out.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan) * env);
}).add;
);

(
SynthDef(\addi, { |out=0, pan=0, freq=440, attack=0.01, release=0.4, sustain=1, accelerate=0, speed=1|
	var env = EnvGen.kr(Env.asr(attack, sustain, release), doneAction: 2);
	var comp = 35; // numero dei componenti
	var res = 0.1; // risoluzione in semitoni
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
	var signal = Mix.new(Array.fill(comp, { |i|
		SinOsc.ar(freq: ((basefreq/7.333)+(i*res)).midicps, phase: i/2pi, mul: 4.0/comp )}
	));

	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan, env));
}).add;
);

(
SynthDef(\sbaum, { |out=0,freq=440,pan=0,attack=0.001,release=0.5,sustain=1,begin=0,end=1, accelerate=0, speed=1|
  var line = Line.ar(begin, end, sustain*(end-begin), doneAction: Done.freeSelf);
  var env = Env.perc(attack, release, 8);
  var volume = IEnvGen.ar(env, line);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var sig = Impulse.ar(basefreq, SinOsc.kr(basefreq/4), 0.5) + Saw.ar(basefreq/2, 0.5);
  sig = LPF18.ar(sig, 2400, 0.7);

  Out.ar(out, DirtPan.ar(sig*volume, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\dk, { |out=0, sustain=1, freq=440, pan=0, attack=0.01, release=0.5, accelerate=0, speed=1|
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var sub = Pulse.ar(basefreq/2);
  var noise = PinkNoise.ar(1);

  //var ani = Fold.ar(LFTri.ar(basefreq, 0), 0.2, 1);
  var ani = Pulse.ar(basefreq, SinOsc.kr(0.8).range(0.2,0.8));
  var sig = (sub * 0.45) + (noise * 0.05) + (ani * 0.5);

  var env = EnvGen.ar(Env.perc(attack, release));

  var cutoff = 2500.0;
  sig = LPF.ar(sig, cutoff + ((cutoff/10) * LFNoise0.kr(5).range(-2,2)));

  OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
);

(
// metallic bouncing marbles: from Bana on Patch and Tweak book
SynthDef(\mbm, { |out=0, freq=440, pan=0, attack=0.01, release=0.4, sustain=1, accelerate=0, speed=0|
  var env = EnvGen.ar(Env.perc(attack, release * LFTri.kr(2).range(0.5, 1.5)));
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);
  var carrier = SinOsc.ar(basefreq*16);
  var signal = SinOsc.ar(basefreq);
  var sig = signal * carrier;

  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
);

(
SynthDef(\cuerda, { |out=0, freq=440, pan=0, attack=0.01, release=0.4, sustain=1, accelerate=0, speed=0|
	var env = EnvGen.ar(Env.asr, doneAction: 2);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

	var sig = ((Pulse.ar(basefreq, LFSaw.kr(200/basefreq).range(0.2, 0.8)) * SinOsc.ar(basefreq*8)) * 0.5)
	  + ((Saw.ar(basefreq)) * 0.47)
	  + WhiteNoise.ar(0.03);

	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env));
}).add;
);

(
SynthDef(\friab, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0|
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

  var env = Env.asr;
  var sig = (Impulse.ar(basefreq) + VarSaw.ar(basefreq/2) + Impulse.ar(basefreq, LFTri.kr(line*4)))/2;

  var volume = IEnvGen.ar(env, line);
  Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\sin, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,feedback=0|
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

  var env = Env.asr;
  var sig = SinOscFB.ar(basefreq, feedback);

  var volume = IEnvGen.ar(env, line);
  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, volume));
}).add;
);

(
SynthDef(\abbass, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,feedback=0|
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

  var env = Env.asr;
  var sig = (Saw.ar(basefreq*2) + Pulse.ar(basefreq/2) + SinOscFB.ar(basefreq/4, feedback)) * 0.5;

  var volume = IEnvGen.ar(env, line);
  Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
}).add;
);

(
SynthDef(\supersub, {|out=0,freq=440,sustain=1,pan=0,model=0,begin=0,end=1,speed=1,accelerate=0, harm=0, phase=0|
  var envLength = sustain*(end-begin)/speed;
  var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
  var rate = max(0, speed * (1 + (accelerate * line)));

  var env = Env.asr;
  var basefreq = freq * DirtFreqScale.kr(speed, accelerate, sustain);

  var sig = Select.ar(model, [
    SinOsc.ar(basefreq, phase),
    SinOscFB.ar(basefreq),
    Saw.ar(basefreq),
    VarSaw.ar(basefreq, phase),
    SyncSaw.ar(basefreq, basefreq),
    Impulse.ar(basefreq, phase),
    Blip.ar(basefreq, harm),
    Pulse.ar(basefreq),
  ]);

  var volume = IEnvGen.ar(env, line);
  Out.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, volume));
}).add;
);
