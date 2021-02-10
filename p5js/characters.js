'use babel'

export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2
  let noteSpectre = 9 * 12; // octaves * notes per octave
  let characters = []

  p.setup = (() => {
    p.smooth();
    p.frameRate(30);
  })

  p.draw = (() => {
    p.textFont('Helvetica');
    p.background(0);
    p.textSize(50);
    for (var i = 0; i < characters.length; i++) {
      var character = characters[i]
      p.textSize(character.size)
      p.fill(0, 255, 128, character.alpha);
      p.text(character.symbol, character.x, character.y);
      character.alpha = character.alpha - character.speed;
    }
  })

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

  this.onOscMessage(oscMessage => {
    let message = {};
    message['octave'] = 5;
    message['legato'] = 1;
    message['speed'] = 1;
    message['pan'] = 0.5;
    for (var i = 0; i < oscMessage.args.length; i+=2) {
      message[oscMessage.args[i]] = oscMessage.args[i+1]
    }
    console.log(message)

    // oc=1 n=0: center (centerX, centerY)
    let octave = message['octave']
    let note = message['n']
    let delta = message['delta']
    let legato = message['legato']
    let speed = message['speed']
    let pan = message['pan'] - 1

    let distanceFromCenter = centerY / noteSpectre * (octave*12 + note);
    let angle = p.random(360)
    // console.log(`angle: ${angle}. sin: ${p.sin(angle)}. cos: ${p.cos(angle)}`)
    let cathetusX = distanceFromCenter * p.cos(angle) + (pan*distanceFromCenter)
    let cathetusY = distanceFromCenter * p.sin(angle)

    characters.push({
      symbol: String.fromCharCode(delta*100*p.random(2) + 30),
      size: 40 * (legato/4+0.75),
      speed: speed,
      alpha: 255,
      x: centerX + cathetusX,
      y: centerY + cathetusY
    })
  })
}
