this.vid = document.createElement('video')
this.vid.autoplay = true
this.vid.loop = true
this.vid.src = '/home/andrea/Videos/airport.mp4'
this.vid.playbackRate = 0.3
s0.init({ src: this.vid })

a.show()
a.setBins(4);
a.setSmooth(0.8)

src(s0)
  // .kaleid(({time}) => (Math.abs(Math.sin(time/10))+1)*4)
  // .rotate(({time}) => Math.cos(time/10))
  // .add(o0)
  .brightness(({time}) => a.fft[0]/2 - 0.3) //  - 0.8
  .blend(src(o0).rotate(({time}) => a.fft[1]*-2))
  .blend(src(o0).rotate(({time}) => Math.sin(time/50)).scale(()=>1-a.fft[3]/10))
  .contrast(({time}) => a.fft[2]+1)
  // .blend(o0)
  // .brightness(0.2)
  .out()
