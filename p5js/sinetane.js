'use babel'

export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2

  p.setup = () => {
    p.frameRate(30);
  }

  p.draw = () => {
    p.background(20);

    p.stroke(125);
    p.strokeWeight(3);

    let a = 0.0;
    let factor = 12 + p.sin(p.frameCount/200)*5
    let inc = p.TWO_PI / factor;
    for (let i = 0; i < p.windowWidth/factor; i++) {
      let sine = p.sin((i * p.frameCount)/(p.pow(factor, 2)))
      p.line(
        i * factor,
        centerY - (sine*factor*2 * p.tan(p.sqrt(p.frameCount/16)) / (p.cos(p.sqrt(p.frameCount/25) % 5) + 3)),
        i * factor,
        centerY + (sine*factor*factor / (1 + (p.tan(p.sqrt(a) * ((p.frameCount/p.pow(factor,3)) % p.pow(factor,2))+factor))))
      );
      a = a + inc;
    }
  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

}
