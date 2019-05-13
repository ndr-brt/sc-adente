{ Blip.ar(Latch.ar(SinOsc.ar, Impulse.ar(9)) * 400 + 500, 4, 0.2) }.play;



{LPF.ar(Blip.ar(Latch.kr(Saw.kr(LFNoise0.kr(320)), Impulse.kr(5)) * 100, LFNoise1.kr(5).range(1, 200), Rand(0.0, 1.0))!2)}.play;

(
Ndef('x', {
    x = Ndef('x').ar + 0.01;
    a = BPF.ar(x, 6 * Latch.ar(x, Dust.ar(x)) * 200, 0.1).sin;
    9.do {
        a = AllpassN.ar(a,0.2,{0.2.rand}!2,9)};
        a + a.mean
    }
).play;
)


{x=Array.fill(5,{[0.00001,0.03].asSpec.map(LFNoise2.kr(3))});Splay.ar(Friction.ar(LFTri.ar(50),friction:x,mass:x*30000))}.play

play{a=Duty.kr(0.1,0,Dseq(fib(32).wrap(20,55).midicps,inf));HPF.ar(LeakDC.ar(Splay.ar(LFCub.ar([-1,a,a/3,-2])))*9).clip2/9};

(
SynthDef("help-Dust", { arg out=0;
    Out.ar(out,
        Dust.ar(200, 0.5)
    )
}).play;
)

{Dust.ar(200, 0.5)}.scope;

{ AllpassN.ar(WhiteNoise.ar(0.1), 0.01, XLine.kr(0.0001, 0.01, 20), 0.2) }.play;


(
{
    z = WhiteNoise.ar(0.2);
    z + AllpassN.ar(z, 0.01, XLine.kr(0.0001, 0.01, 20), 0.2)
}.play)

{ AllpassN.ar(Decay.ar(Dust.ar(1,0.5), 0.2, WhiteNoise.ar), 0.2, 0.2, 3) }.play;

play({ SinOsc.ar(XLine.kr(200,17000,10),0,0.1) });