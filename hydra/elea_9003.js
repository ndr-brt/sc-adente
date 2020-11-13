

vid = document.createElement('video')
vid.autoplay = true
vid.loop = true
vid.src = '/home/andrea/Videos/elea_9003.mp4'

s0.init({ src: vid })

src(s0)
  // .rotate(({time}) => (time/4)%360,0.2)
  // .rotate(({time}) => time/200%3, 2)
  .kaleid(({time}) => (time/20)%3 + 4)
  // .luma(0.3, 0.2)
  .thresh(0.5)
  .contrast(0.7)
  .saturate(({time}) => time%200)
  .out()
