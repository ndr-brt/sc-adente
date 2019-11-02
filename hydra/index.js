const Hydra = require('hydra-synth')
const loop = require('raf-loop')

function init () {
  const canvas = document.createElement('canvas')
  canvas.style.backgroundColor = "#000"
  canvas.width = 1280
  canvas.height = 800
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
  a.setScale(1)
  a.setBins(6)

  s0.initCam()

  src(s0)
    .blend(
      voronoi(4, 1.8)
        .rotate(0.8)
    )
    .modulate(noise(() => a.fft[1] + 0.01).scale(5,0.1))
    .out(o1)

  src(o1)
    .mult(
      osc(1, 0.12)
      .rotate(1.58))
    .out(o2)

  src(o2)
    .modulateRotate(o3, 2)
    .out(o3)

  src(o3)
    .scale(2.2)
    .modulateRotate(
      osc(2000, -0.02)
      .rotate(0.8), -0.3)
      .out()

// prints o0 o1 o2 o3
// render()

  loop((dt) => {
    hydra.tick(dt)
  }).start()

}

window.onload = init
