(
p = ProxySpace.push(s.boot);
~out.play;
)

(
~out = {
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
	LPF.ar(sig, LFSaw.kr(1).range(800, 1600));
}
)
