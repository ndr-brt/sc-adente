(
p = ProxySpace.push(s.boot);
p.fadeTime = 3;
)
(

~inpleasure = { |mix=0.33, room=0.5, damp=0.5|
	var in = SoundIn.ar(0, 1);
	in = FreeVerb.ar(in, mix, room, damp);
	in = in + Delay1.ar(in);
	in = Pan2.ar(in);
	Limiter.ar(in);
};

~mixMouse = { [MouseX.kr(0, 5)] };
~roomMouse = { [MouseY.kr(0, 5)] };
~dampMouse = { [sqrt(MouseX.kr(0, 5) * MouseY.kr(0,5))] };

~inpleasure.map(\mix, ~mixMouse);
~inpleasure.map(\room, ~roomMouse);
~inpleasure.map(\damp, ~dampMouse);
)

(
~inpleasure.play;
~inpleasure.vol = 6;
)

~inpleasure.end(5);

p.clear;
