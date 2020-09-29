'use babel'

export default function(p) {

  let centerX = p.windowWidth/2
  let centerY = p.windowHeight/2
  let background = 20;
  let size = 0;

  p.setup = () => {
    p.frameRate(25);
  }

  p.draw = () => {
    p.background(background, background*2, background + 20)

    p.fill(255)

    // while (size < p.max(p.windowWidth, p.windowHeight)) {
      size++;
      p.rect(p.random(p.windowWidth), p.random(p.windowHeight), size, size)
    // }
    // size = 0;

  }

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

}
