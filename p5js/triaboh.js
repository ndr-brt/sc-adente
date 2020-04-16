'use babel'

export default function(p) {

  let count = 100;
  let range = 5;
  let centerX = p.windowWidth / 2;
  let centerY = p.windowHeight / 2;
  let rotation = 0;
  let index = 0;
  let functions = [
    (v) => v + 0.02,
    (v) => v + 2/v,
    (v) => 1/v,
    (v) => v + 1/p.frameCount,
    (v) => v + Math.sqrt(v) * 3,
  ]

  this.points = []

  p.setup = () => {
    this.points.push({ x:centerX, y:centerY })
    p.frameRate(10);
  }

  p.draw = () => {
    p.background(30);

    let rangeX = centerX/range;
    let rangeY = centerY/range;

    if (this.points.length > count) {
      this.points.shift()
    }

    this.points.push({
      x: centerX + p.random(-rangeX, rangeX),
      y: centerY + p.random(-rangeY, rangeY)
    })

    rotation = functions[index](rotation)

    this.points.forEach((item, i) => {
      p.strokeWeight(16);
      p.fill((185 - (index*20))*rotation * p.random(-rangeX, rangeX));
      // p.point(item.x, item.y);
      // p.noStroke();
      p.translate (p.windowWidth/2*rotation, p.windowHeight/2*rotation);
      p.rotate(rotation);
      let x1 = p.re
      p.triangle(item.x, item.y+functions[index](item.y), item.x-index, item.y/(index+1), item.x*p.random(Math.sin(i),Math.sqrt(i)), item.y+index)
    });

  }

  this.onOscMessage(oscMessage => {
    let args = oscMessage.args;
    let message = {}
    for (var i = 0; i < args.length; i+=2) {
      message[args[i]] = args[i+1]
    }
    // console.log(message)
    let orbit = message.orbit
    // this.points.push({
    //   x: centerX + p.random(-rangeX, rangeX) * (1 + orbit),
    //   y: centerY + p.random(-rangeY, rangeY) * (1 + orbit)
    // })
    index = Math.round(message.cycle) % 5
    range = orbit + 1
  })

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

}
