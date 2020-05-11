'use babel'
const EventEmitter = require('events');
// const { tidalOsc } = require('./utils');


export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2
  let axisRatio = centerX/centerY;
  let squares = []
  let background = 100;
  let shapeLimit = 200;

  p.setup = () => {
    p.frameRate(25);
    this.onOscMessage(message => {
      let tidalOscMessage = tidalOsc(message)
      let cyclePos = p.sin(tidalOscMessage.cycle/50)
      squares.push(new Shape("square", centerX, centerY, tidalOscMessage.orbit))

      if (squares.length > shapeLimit) {
        squares.shift()
      }
    })
  }

  p.draw = () => {
    p.background(background);

    p.strokeWeight(3);
    p.noFill();

    squares
      .filter(square => !square.isOut())
      .forEach(square => {
        square.draw()
        if (square.isOut()) {
          squares.shift()
        }
      })
  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

  class Shape extends EventEmitter {
    constructor(shape, x, y, orbit) {
      super()
      this.shape = shape;
      this.size = 25;
      this.x = x;
      this.y = y;
      this.stroke = background;
      this.speed = p.random(orbit, 10 + (orbit*10));
      this.orbit = orbit;
    }

    draw() {
      this.x += p.random(-this.speed, this.speed) * axisRatio
      this.y += p.random(-this.speed, this.speed) / axisRatio
      this.stroke += p.random(-8, 8)
      this.size += p.random(-3, 3)
      switch (this.orbit%4) {
        case 0: p.stroke(this.stroke); break;
        case 1: p.stroke(this.stroke, 0, 0); break;
        case 2: p.stroke(0, this.stroke, 0); break;
        case 3: p.stroke(0, 0, this.stroke); break;
      }
      // p.fill(p.lerpColor(this.stroke, background, 0.33));

      switch (this.shape) {
        case "square":
          p.square(this.x, this.y, this.size);
          break;
        case "circle":
          p.circle(this.x, this.y, this.size);
          break;
      }

    }

    isOut() {
      return this.x < 0-this.size || this.y < 0-this.size || this.x > p.windowWith || this.y > p.windowHeight
    }
  }

}

function tidalOsc(oscMessage) {
  let args = oscMessage.args;
  let message = {}
  for (var i = 0; i < args.length; i+=2) {
    message[args[i]] = args[i+1]
  }
  return message
}
