// https://stream.p-node.org/kernel-lecture.ogg
// wget https://stream.p-node.org/kernel-lecture.ogg --no-check-certificate

~kernelLecture = Buffer.read(s,"/tmp/kernel-lecture.ogg");

(
SynthDef("playbuf",{ |out=0,bufnum=0, rate=1, trigger=1, startPos=0, loop=1, pan=0|
	var signal = PlayBuf.ar(1,bufnum, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop);
	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan));
	/*
	Out.ar(out,
		Pan2.ar(signal,0.0)
	)*/

}).add;
)

(
~kernelLecture = Buffer.read(s,"/tmp/kernel-lecture.ogg");
SynthDef("lecture",{ |out=0, bufnum=0, rate=1, trigger=1, startPos=0, loop=1, pan=0|
	var signal = PlayBuf.ar(1, ~kernelLecture, BufRateScale.kr(bufnum)*rate, trigger, BufFrames.ir(bufnum)*startPos, loop);
	OffsetOut.ar(out, DirtPan.ar(signal, ~dirt.numChannels, pan));
	/*
	Out.ar(out,
		Pan2.ar(signal,0.0)
	)*/

}).add;
)

x = Synth(\playbuf, [\bufnum, ~kernelLecture]);
x.set(\out, y);


(
SynthDef("dirt_fm", { |out, fm, fmf |
	var signal, mod;
	signal = In.ar(out, 2);
	mod = SinOsc.ar(fmf * (1.0 + fm * signal), mul:fm);
	ReplaceOut.ar(out, mod + (1.0-fm)*signal);
}).add;
)

y = Synth(\dirt_fm, [\out, 0, \fm, 0.8, \fmf, 220]);
