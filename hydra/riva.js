a.show()
a.setSmooth(0.8)
a.setBins(4);

noise(3,0.1)
.rotate(() => a.fft[0],-a.fft[1])
.mask(shape(() => (100 * a.fft[2])+10))
.colorama(() => (Math.sin(time/100)+1) * (a.fft[0]/3))
.modulateScale(o0,() => a.fft[3] * 2)
.modulateScale(o0)
.blend(o0)
// .blend(o0)
.blend(o0)
.blend(o0)
// .diff(o0)
.out(o0)
