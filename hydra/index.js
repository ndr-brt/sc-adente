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

  osc(100)
    .blend(
      shape(3, () => a.fft[2] * 6.28, a.fft[3]/3)
        .rotate(({time})=>Math.sin(time/5)*0.5)
    )
    .modulate(noise(() => a.fft[1] + 0.01).scale(5,0.1))
    .mult(
      osc(1, 0.12, 0.2)
      .rotate(a.fft[3]*360)
    )
    .scale(() => a.fft[2] / 2)
    .modulateRotate(
      osc(2000, -0.02).rotate(() => a.fft[4]*360), 
      -0.3
    )
    .out()

// prints o0 o1 o2 o3
// render()

  loop((dt) => {
    hydra.tick(dt)
  }).start()

}

window.onload = init
