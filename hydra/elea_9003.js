vid = document.createElement('video')
vid.autoplay = true
vid.loop = true
vid.src = 'https://localhost:8000/elea_9003.mp4'
// vid.src = '/home/andrea/Videos/elea_9003.mp4'

s0.init({ src: vid })

a.show()
a.setSmooth(0.7)
a.setBins(4);

src(s0)
  .rotate(({time}) => (time/50)%360, 0.4)
  .pixelate(({time}) => 1920*a.fft[1], ({time}) => 1080*a.fft[2])
  .kaleid(3)
  .thresh(0.5)
  .contrast(0.7)
  .brightness(({time}) => a.fft[1] - 0.8)
  .out()
