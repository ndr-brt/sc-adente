vid = document.createElement('video')
vid.autoplay = true
vid.loop = true
vid.playbackRate = 0.8
// vid.src = 'https://localhost:8000/elea_9003.mp4'
vid.src = '/home/andrea/Videos/elea_9003.mp4'

s0.init({ src: vid })

a.show()
a.setSmooth(0.6)
a.setBins(4);

src(s0)
  .kaleid(({time}) => (Math.abs(Math.sin(time/10))+1)*4)
  .scale(({time}) => Math.sin(time/2000))
  .rotate(({time}) => Math.cos(time/10))
  .thresh(({time}) => 0.8 - a.fft[0]/2)
  .contrast(({time}) => a.fft[1]+1)
  // .add(o0)
  .blend(src(o0).rotate(({time}) => Math.sin(time/20)))
  // .blend(src(o0).rotate(4))
  // .brightness(({time}) => a.fft[3] - 0.5) //  - 0.8
  // .brightness(0.2)
  .out()


  s0.initCam()
  src(s0).out()
