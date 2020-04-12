'use babel'

export default function(p) {

  let range = 10;
  let centerX = p.windowWidth / 2;
  let centerY = p.windowHeight / 2;
  let rangeX = centerX/range;
  let rangeY = centerY/range;

  this.points = []

  p.setup = () => {
    this.points.push({ x:centerX, y:centerY })
    p.frameRate(30);
  }

  p.draw = () => {
    p.background(30);

    console.log(this.points)

    this.points.forEach((item, i) => {
      p.stroke(255);
      p.strokeWeight(10);
      p.point(item.x, item.y);
    });

    // if (this.points.length > 2) {
    //   let oldPoint = this.points.shift();
    //   let point = this.points[0];
    //   p.stroke(255);
    //   p.line(oldPoint.x, oldPoint.y, point.x, point.y);
    // } else {
    //   this.points.push({
    //     x: centerX + p.random(-rangeX, rangeX),
    //     y: centerY + p.random(-rangeY, rangeY)
    //   })
    // }

  }

  this.onOscMessage(oscMessage => {
    let args = oscMessage.args;
    let message = {}
    for (var i = 0; i < args.length; i+=2) {
      message[args[i]] = args[i+1]
    }
    console.log(message)
    let orbit = message.orbit
    this.points.push({
      x: centerX + p.random(-rangeX, rangeX) * (1 + orbit),
      y: centerY + p.random(-rangeY, rangeY) * (1 + orbit)
    })
  })

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

}
