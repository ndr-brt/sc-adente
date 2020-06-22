'use babel'

export default function(p) {

  let width = p.windowWidth;
  let height = p.windowHeight;
  let centerX = width/2;
  let centerY = height/2;
  let divisorX = 13;
  let divisorY = 11;
  let maxPoints = 1000;
  let strokeWeight = 9;
  let stroke = 50;
  let points = []

  p.setup = () => {
    p.frameRate(20);
  }

  p.draw = () => {
    p.background(10);
    p.noFill();

    let shiftX = p.sin(p.frameCount/divisorX)* centerX
    let shiftY = p.cos(p.frameCount/divisorY) * centerY

    points.push(p.createVector(centerX + shiftX, centerY + shiftY))

    for (var i = 1; i < points.length; i++) {
      let prec = points[i-1]
      let actual = points[i]
      p.stroke(stroke*(p.sin(p.frameCount/i)+1))
      p.strokeWeight(strokeWeight*(i/points.length));
      p.line(prec.x, prec.y, actual.x, actual.y)
    }

    if (p.frameCount % maxPoints == 0) {
      divisorX = p.random(10) + 5
      divisorY = p.random(10) + 5
    }

    if (points.length > maxPoints) {
      points.shift()
    }
  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

}
