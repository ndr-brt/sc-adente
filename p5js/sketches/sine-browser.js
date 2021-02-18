let centerX = 0;
let centerY = 0;
let noteSpectre = 9 * 12; // octaves * notes per octave
let shapes = [];

function setup() {
  smooth();
  frameRate(30);
  centerX = windowWidth/2;
  centerY = windowHeight/2;
}

function draw() {
  background(0);
  for (var i = 0; i < shapes.length; i++) {
    let shape = shapes[i]

    let distanceX = abs(shape.x - centerX)
    let distanceY = abs(shape.y - centerY)

    fill(distanceX + distanceY, shape.cycle % 256, 0, shape.alpha);
    circle(shape.x, shape.y, shape.size)

    shape.alpha = shape.alpha - shape.speed;

    let speedX = distanceX/255
    let speedY = distanceY/255

    if (shape.x > centerX) {
      shape.x -= speedX
    } else {
      shape.x += speedX
    }

    if (shape.y > centerY) {
      shape.y -= speedY
    } else {
      shape.y += speedY
    }

    if (shape.alpha < 0) {
      shapes.splice(shapes.indexOf(shape), 1)
    }
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
}

oscPort = new osc.WebSocketPort({
  url: "ws://localhost:8081"
});

oscPort.open();

oscPort.socket.onmessage = function (e) {
    console.log("message", e);
};

oscPort.on("message", function (oscMessage) {
  let message = {};
  message['octave'] = 5;
  message['legato'] = 1;
  message['speed'] = 1;
  message['pan'] = 0.5;
  message['note'] = 0;
  message['n'] = 0;
  for (var i = 0; i < oscMessage.args.length; i+=2) {
    message[oscMessage.args[i]] = oscMessage.args[i+1]
  }
  // console.log(message)

  let cycle = message['cycle']
  let octave = message['octave']
  let note = message['n'] + message['note']
  let legato = message['legato']
  let speed = message['speed']
  let pan = message['pan'] - 0.5

  let cycleNumber = floor(cycle)
  let cycleOffset = cycle - cycleNumber

  let distanceFromCenter = centerY / noteSpectre * (octave*12 + note);
  let quadrant = cycleNumber + octave

  let offset = cycleNumber % 2 == 0 ? (1 - cycleOffset) : cycleOffset
  let angle = PI/1.5 * (offset + quadrant)

  let cathetusX = distanceFromCenter * cos(angle) + (pan * centerX)
  let cathetusY = distanceFromCenter * sin(angle)

  shapes.push({
    size: 10 * (legato/4+0.75) * (20/octave) + (30/speed) + (10/(1+note)),
    speed: speed,
    cycle: cycleNumber,
    alpha: 255,
    x: centerX + cathetusX,
    y: centerY + cathetusY
  })
})
