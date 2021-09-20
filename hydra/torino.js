vid = document.createElement('video')
vid.autoplay = true
vid.loop = true
vid.src = '/home/andrea/Videos/duepiedi.mp4'

s0.init({ src: vid })

a.show()
a.setSmooth(0.8)
a.setBins(4);

// noise(3,0.1)
src(s0)
.brightness(()=>(a.fft[3]-0.3)/2)
.add(src(s0).kaleid(() => 4))
// .mult(src(s0).modulateScale(o0).luma(()=>a.fft[1]).blend(o0))
// .add(src(s0).modulateScale(o0).blend(o0))
.contrast(5)
.luma(0.1, ()=>a.fft[1])
// .diff(src(o0).diff(osc(1, 0.3)))
// .luma(() => 1-a.fft[0],0.8)
// osc(1)
// .rotate(() => a.fft[0],-a.fft[1])
// .mask(shape(() => (100 * a.fft[2])+10))
// .colorama(() => (Math.sin(time/100)+1) * (a.fft[0]/3))
// .colorama(() => 0.2)
// .modulateScale(o0,() => a.fft[3] * 2)
// .modulateScale(o0)
// .blend(o0)
.blend(o0)
.blend(o0)
.blend(o0)
// .diff(o0)
// .mask(shape(10, 0.3, 2))
.out(o0)
