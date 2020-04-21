'use babel'

export default function(p) {

  let width = p.windowWidth;
  let height = p.windowHeight;

  p.setup = () => {
    p.frameRate(20);
  }

  p.draw = () => {
    p.background(10);

    p.stroke(125);
    p.noFill();
    // p.strokeWeight(3);


    p.curve(
      p.random(width),
      p.random(height),
      p.random(10),
      p.random(width),
      p.random(height),
      p.random(100),
      p.random(width),
      p.random(height),
      p.random(10),
      p.random(width),
      p.random(height),
      p.random(10)
    )

  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

}
