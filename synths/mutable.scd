// https://github.com/v7b1/mi-UGens

(
  SynthDef(\braids, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,timbre=0.5,color=0.5,model=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiBraids.ar(pitch: freq.cpsmidi, timbre: timbre, color: color, model: model);

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
  SynthDef(\elements, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,pit=48, strength=0.5, contour=0.2, bow_level=0,
                blow_level=0, strike_level=0, flow=0.5, mallet=0.5, bow_timb=0.5, blow_timb=0.5,
                strike_timb=0.5, geom=0.25, bright=0.5, damp=0.7, pos=0.2, space=0.3, model=0,
                easteregg=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiElements.ar(pit: freq.cpsmidi, strength: strength, contour: contour, bow_level: bow_level,
                blow_level: blow_level, strike_level: strike_level, flow: flow, mallet: mallet, bow_timb: bow_timb, blow_timb: blow_timb,
                strike_timb: strike_timb, geom: geom, bright: bright, damp: damp, pos: pos, space: space, model: model,
                easteregg: easteregg);

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
  SynthDef(\omi, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiOmi.ar(pit: freq.cpsmidi);

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
  SynthDef(\tides, {|out=0,freq=440,sustain=1,pan=0,begin=0,end=1,speed=1,accelerate=0,tidesshape=0.5,slope=0.5,tidessmooth=0.5,shift=0.5,mode=2|
    var envLength = sustain*(end-begin)/speed;
    var line = Line.ar(begin, end, envLength, doneAction: Done.freeSelf);
    var env = Env.asr;
    var volume = IEnvGen.ar(env, line);
    var sig;

    freq = max(0, freq * speed * (1 + (accelerate * line)));
    sig = MiTides.ar(
      freq: freq,
      shape: tidesshape,
      slope: slope,
      smooth: tidessmooth,
      shift: shift,
      output_mode: mode,
      ramp_mode: 1,
      rate: 1
    );

    Out.ar(out, DirtPan.ar(sig * volume, ~dirt.numChannels, pan));
  }).add;
);

(
~dirt.addModule('rings', { |dirtEvent|
	dirtEvent.sendSynth('rings' ++ ~dirt.numChannels,
		[
			rtrig: ~rtrig,
			rfreq: ~rfreq,
			rstruct: ~rstruct,
			rbright: ~rbright,
			rdamp: ~rdamp,
			rpos: ~rpos,
			rmodel: ~rmodel,
			rpoly: ~rpoly,
			rintern_exciter: ~rintern_exciter,
			reasteregg: ~reasteregg,
			rbypass: ~rbypass,
			out: ~out
		]
	)
}, {~rbright.notNil});
);

(
SynthDef("rings" ++ ~dirt.numChannels, { |out, rtrig=0, rfreq=60.0, rstruct=0.75, rbright=0.75, rdamp=0.4, rpos=0.9, rmodel=0, rpoly=1,rintern_exciter=0, reasteregg=0, rbypass=0|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiRings.ar(signal, rtrig, rfreq, rstruct, rbright, rdamp, rpos, rmodel, rpoly,rintern_exciter, reasteregg, rbypass);
  ReplaceOut.ar(out, signal)
}).add;

);


(

(1..SuperDirt.maxSampleNumChannels).do { |numChannels|

  SynthDef("global_mi_verb" ++ numChannels, { |dryBus, effectBus, verbwet=0, verbtime=0, verbdamp=0, verbhp=0, verbfreeze=0, verbdiff=0.625, verbgain=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    Out.ar(effectBus, MiVerb.ar(
      signal,
      verbtime,
      verbwet,
      verbdamp,
      verbhp,
      verbfreeze,
      verbdiff
    ) * verbgain);
  }, [\ir, \ir]).add;

  SynthDef("global_mi_clouds" ++ numChannels, { |dryBus, effectBus, cloudspitch=0, cloudspos=0, cloudssize=0, cloudsdens=0, cloudstex=0, cloudswet=0, cloudsgain=0, cloudsspread=0, cloudsrvb=0, cloudsfb=0, cloudsfreeze=0, cloudsmode=0, cloudslofi=0|
    var signal = In.ar(dryBus, ~dirt.numChannels);
    Out.ar(effectBus, MiClouds.ar(
      inputArray: signal,
      pit: cloudspitch,
      pos: cloudspos,
      size: cloudssize,
      dens: cloudsdens,
      tex: cloudstex,
      drywet: cloudswet,
      in_gain: cloudsgain,
      spread: cloudsspread,
      rvb: cloudsrvb,
      fb: cloudsfb,
      freeze: cloudsfreeze,
      mode: cloudsmode,
      lofi: cloudslofi
    ));
  }, [\ir, \ir]).add;
};

);
