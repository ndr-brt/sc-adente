'use babel'

export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2
  let noteSpectre = 8 * 12; // octaves * notes per octave
  let characters = []

  p.setup = (() => {
    p.smooth();
    p.frameRate(30);
    for (var i = 0; i< 10; i++) {
      characters.push({
        symbol: '~',
        alpha: 255,
        x: p.random(p.windowWidth),
        y: p.random(p.windowHeight)
      })
    }
  })

  p.draw = (() => {
    p.background(0);
    p.textSize(50);
    for (var i = 0; i < characters.length; i++) {
      var character = characters[i]
      p.fill(0, 255, 128, character.alpha);
      p.text(character.symbol, character.x, character.y);
      character.alpha--;
      // TODO: pulizia array quando l'alpha è sotto zero
    }
  })

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

  this.onOscMessage(oscMessage => {
    let message = {};
    message['octave'] = 5;
    for (var i = 0; i < oscMessage.args.length; i+=2) {
      message[oscMessage.args[i]] = oscMessage.args[i+1]
    }
    console.log(message)

    // oc=1 n=0: center (centerX, centerY)



    characters.push({
      symbol: '#',
      alpha: 255,
      x: p.random(p.windowWidth),
      y: p.random(p.windowHeight)
    })
  })
}
