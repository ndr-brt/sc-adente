'use babel'
const EventEmitter = require('events');


export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2
  let squares = []
  let background = 20;

  p.setup = () => {
    p.frameRate(30);
    // for (var i=0; i<50; i++) {
    //   squares.push(new Shape("square", centerX, centerY))
    // }
    this.onOscMessage(message => {
      squares.push(new Shape("square", centerX, centerY))
    })
  }

  p.draw = () => {
    p.background(background);

    p.stroke(200);
    p.strokeWeight(3);
    p.noFill();

    squares
      .filter(square => !square.isOut())
      .forEach(square => {
        square.draw()
        if (square.isOut()) {
          squares.push(new Shape("circle", centerX, centerY))
        }
      })


      if (squares > 10000) {
        squares.shift()
      }
  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

  class Shape extends EventEmitter {
    constructor(shape, x, y) {
      super()
      this.shape = shape;
      this.size = 25;
      this.x = x;
      this.y = y;
      this.stroke = 200;
      this.speed = p.random(0, 10);
    }

    draw() {
      let elo = (p.sqrt(p.frameCount))+1;
      // let elo = p.frameCount;
      this.x += p.random(-this.speed, this.speed)
      this.y += p.random(-this.speed, this.speed)
      this.stroke += p.random(-5, 5)
      this.size += p.random(-2, 2)
      p.stroke(this.stroke)
      switch (this.shape) {
        case "square":
          p.square(this.x, this.y, this.size)
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
