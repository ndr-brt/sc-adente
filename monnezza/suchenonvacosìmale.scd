p = ProxySpace.push(s.boot);
p.fadeTime = 4;

~z = { FreeVerb.ar(LPF.ar(Ringz.ar(Saw.ar([140, 142]), Rand(200, 400), Rand(0.5, 1.5)), 160)* 0.06, Rand(0.5, 1.3), Rand(0.5, 1.2), Rand(0.5, 1.8)) }

~z.play;
~z.fadeTime = 60;
~z.end(60);

~z.send;

(
{
	inf.do {
		~z.send;
		exprand(4,8).wait;
	}
}.fork;
)

~z.end(3);

(
~y = {
	BPF.ar(max(LFSaw.ar(5), SinOsc.ar(LFNoise0.kr(2).exprand(220, 480), SinOsc.kr(5).range(0, 2pi))), LFSaw.kr(8).range(100, 500), Saw.kr(5).range(0.5, 1.5)) * 0.2
}
)
~y.meld = 2;
~y.play(0,2);
~y.end(60);

(
~x = {
	Pan2.ar(Ringz.ar(Impulse.ar(SinOsc.kr(Rand(3, 6)).exprange(0.5, 2.5)), LFSaw.kr(Rand(1,4)).exprange(100, 500), LFNoise2.kr(Rand(3, 9)).exprange(0.2, 1)).distort, 0) * WhiteNoise.kr(880) * 0.6
}
)

~x.play;
~x.end(1);

(
{
	inf.do {
		~x.send;
		exprand(3,6).wait;
	}
}.fork;
)