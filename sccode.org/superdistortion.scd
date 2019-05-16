b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
{
    var snd, envTime, knee, out;
    snd = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
    envTime = MouseX.kr(1.0e-3, 0.1e-3);
    knee = MouseY.kr(0, -90).dbamp;
    out = DelayC.ar(snd, 0.01, envTime * 0.5) * EnvFollow.ar(snd, 1 - (envTime * SampleRate.ir).reciprocal).max(knee).reciprocal;
    out * 0.1!2
}.play;
)