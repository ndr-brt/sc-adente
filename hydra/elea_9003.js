vid = document.createElement('video')
vid.autoplay = true
vid.loop = true
// vid.src = 'https://localhost:8000/elea_9003.mp4'
vid.src = '/home/andrea/Videos/elea_9003.mp4'

s0.init({ src: vid })

a.show()
a.setSmooth(0.2)
a.setBins(4);

src(s0)
  // .kaleid(({time}) => ((time%60)/10)+1)
  .kaleid(({time}) => ((time%20)/60)+2)
  .scale(({time}) => (time%20)/40 + 0.3)
  .rotate(220, ({time}) => Math.sin(time%100)/50000)
  .thresh(0.5)
  .contrast(1)
  .brightness(({time}) => a.fft[3] - 0.9) //  - 0.8
  // .brightness(({time}) => -0.2) //  - 0.8
  .out()
