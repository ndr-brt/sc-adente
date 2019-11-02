const Hydra = require('hydra-synth')
const loop = require('raf-loop')

function init () {
  const canvas = document.createElement('canvas')
  canvas.style.backgroundColor = "#000"
  canvas.width = 800
  canvas.height = 200
  canvas.style.width = '100%'
  canvas.style.height = '100%'

  document.body.appendChild(canvas)

  var hydra = new Hydra({
    canvas: canvas,
    enableStreamCapture: true,
    detectAudio: true
  })

  window.hydra = hydra

  a.show()
  a.setScale(10)
  a.setBins(6)
  a.settings[0].cutoff = 1
  a.settings[1].cutoff = 2
  a.settings[2].cutoff = 4
  a.settings[3].cutoff = 6
  a.settings[4].cutoff = 8
  a.settings[5].cutoff = 9

  // osc(322).color(0,0,0)
  // .add(shape(2).color(2,2,2).scale(0.006).rotate(0.000001))
  // .scale(1.2,1,3)
  // //.scale(()=> a.fft[3]*0.1 -2)
  // //.repeat(1,5)
  // //.rotate(1,()=> a.fft[3]*1 +0.01)
  // .out(o0)

  voronoi(4, 1.8)
    .modulate(noise(()=> a.fft[2]*10 +0.01).scale(5,0.1))
    .rotate(1.57, 0.0)
    .thresh(0.3)
    .out(o1)

  src(o1)
    .mult(
      osc(10)
      .rotate(1.58))
    .out(o2)

  src(o2)
    .modulateRotate(o3, 2)
    .out(o3)

  src(o3)
    .scale(1.2)
    .modulateRotate(
      osc(200, -0.02)
      .rotate(0.5), -0.3)
      .out()

// render()

  loop((dt) => {
    hydra.tick(dt)
  }).start()

}

window.onload = init
