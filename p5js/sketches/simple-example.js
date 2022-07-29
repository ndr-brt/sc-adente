'use babel'

export default function(p) {

  let y = 100;

  p.setup = () => {
    this.onOscMessage(message => {
      console.log(`osc message received`)
      console.log(message)
    })
    p.frameRate(30)
  }

  p.draw = () => {
    p.background(0, 0, 255-y);

    p.noStroke();

    p.fill(255);
    p.ellipse(252, 844, 72, 72);

    p.fill(2, 23+y, 2);
    p.triangle(28, 18+(y*5), 1351-(y*2), 360, 188, 1360);

    p.fill(255);
    p.arc(y*5, y*(1/(y*y)+1), 280, 280, 3.14, 7.28);

    p.stroke(255);
    y = y + 1;
    if (y > 800) {
      y = 0;
    }
    p.line(20, y, window.innerWidth, window.innerHeight);
  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }
}
