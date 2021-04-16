'use babel'

export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2
  let noteSpectre = 9 * 12; // octaves * notes per octave
  let shapes = []

  p.setup = (() => {
    p.smooth();
    p.frameRate(1);
  })

  p.draw = (() => {
    p.background(0);
    p.stroke('green');
    p.noFill();

    var freq = 1/50
    var ampl = 1/4
    var strokeWeight = 2
    var count = 20

    for (var i = 0; i < count; i++) {
      p.strokeWeight(strokeWeight-i/count);
      sine(freq*(1+i/20), ampl + (i/80), i*6)
    }

  })

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

  let sine = (freq, ampl, phase) => {
    for (var x = 0; x < p.windowWidth; x++) {
      let y = p.sin(x*freq + phase)*ampl*p.windowHeight + centerY
      p.point(x, y);
      let x2 = x+1;
      let y2 = p.sin(x2*freq + phase)*ampl*p.windowHeight + centerY
      p.line(x, y, x2, y2)
    }
  }
}
