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
~dirt.addModule('clouds', { |dirtEvent|
	dirtEvent.sendSynth('clouds' ++ ~dirt.numChannels,
		[
      cpit: ~cpit,
			cpos: ~cpos,
			csize: ~csize,
			cdens: ~cdens,
			ctex: ~ctex,
			cdrywet: ~cdrywet,
			cspread: ~cspread,
			crvb: ~crvb,
			cfb: ~cfb,
			cfreeze: ~cfreeze,
			cmode: ~cmode,
			clofi: ~clofi
		]
	)
}, {~cmode.notNil});

SynthDef("clouds" ++ ~dirt.numChannels, { |out, cpit=0, cpos=0.5, csize=0.25, cdens=0.4, ctex=0.5, cdrywet=0.5, cspread=0.5, crvb=0, cfb=0, cfreeze=0, cmode=0, clofi=0|
	var signal = In.ar(out, ~dirt.numChannels);
	signal = MiClouds.ar(signal, cpit, cpos, csize, cdens, ctex, cdrywet, 1, cspread, crvb, cfb, cfreeze, cmode, clofi);
	ReplaceOut.ar(out, signal)
	}).add;
);

~dirt.orderModules(['clouds']);
