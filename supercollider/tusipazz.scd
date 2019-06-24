p = ProxySpace.push(s.boot);

~out.play;

(
~out = {
	var caboos = LFNoise0.kr(15);
	var sig = SinOsc.ar(
		Pulse.kr(
			LFPulse.kr(SinOsc.kr(0.3).range(1, caboos.fold(1, 4)), pi/2),
			LFNoise1.kr(7).range(0, caboos.slew(0.3, 0.9))
		).exprange(LFNoise2.kr(3).range(Line.kr(100, 500, 17), caboos).range(500, 1000))
	)!4;
	sig = FreeVerb.ar(sig);
	[sig, sig + Delay1.ar(sig)]
}
)