'use babel'

export default function(p) {

  this.onOscMessage(onMessage)

  let orbits = {}
  let cps = 0;
  let showCycles = 4; // 1/speed
  let lastCycle = 0;
  let lastTimestamp = 0;

  p.setup = (() => {
    p.smooth();
    p.frameRate(30);
  })

  p.draw = (() => {
    let now = new Date();
    let elapsed = now - lastTimestamp;
    let cycle = ((elapsed * cps)/1000) + lastCycle;
    let rowHeight = p.windowHeight / Object.keys(orbits).length
    p.background(0);

    for (var orbitNumber in orbits) {
      if (orbits.hasOwnProperty(orbitNumber)) {
        let orbit = orbits[orbitNumber]
        p.translate(0, orbit * rowHeight)
        orbit.draw(cycle, rowHeight)
      }
    }
  })

  p.windowResized = () => {
    p.resizeCanvas(p.windowWidth, p.windowHeight);
  }

  function onMessage(oscMessage) {
    let timestamp = new Date();

    let arguments = oscMessage.args;
    let message = {}
    for (var i = 0; i < arguments.length; i+=2) {
      message[arguments[i]] = arguments[i+1]
    }

    let orbit = message.orbit;
    let cycle = message.cycle;
    if (message.cps) {
      cps = message.cps
    }

    if (!(orbit in orbits)) {
      orbits[orbit] = new Orbit(orbit)
    }

    if (orbit >= 0 && cycle >= 0) {
      let event = { cycle, timestamp }
      lastCycle = cycle;
      lastTimestamp = timestamp;
      orbits[orbit].add(event);
    }
  }

  class Orbit {
    constructor(number) {
      this.number = number;
      this.state = false;
      this.events = [];
    }

    add(event) {
      this.events.push(event)
      this.state = !this.state
    }

    draw(cycle, rowHeight) {
      let roundedCycle = Math.round(cycle);
      let orbitFactor = roundedCycle + (this.number*15);
      let width = window.innerWidth;
      // let height = this.heightLfo(cycle);
      let height = rowHeight
      let y = (rowHeight * this.number)

      p.noFill();
      p.beginShape();
      // p.fill(p.color(orbitFactor%255, (orbitFactor%126)*2, (orbitFactor*3)%255));
      // p.fill(200);
      p.stroke(200);

      p.vertex(width-(orbitFactor % width), y + (this.state ? height/10 : height));
      // p.vertex(width-(orbitFactor % width), y + (height));

      this.events.forEach(event => {
        let pos = (event.cycle-(cycle-showCycles))/showCycles;
        if (pos < 0) {
          const index = this.events.indexOf(event);
          if (index > -1) {
            this.events.splice(index, 1);
          }
        }
        else {
          // p.vertex(width * pos, y + (this.state ? height/10 : height));
          // p.vertex(width * pos, y + (this.state ? height/10 : height));
          p.vertex(width * pos, y + height);
          p.vertex(width * pos, y + height);
          this.state = !this.state;
        }
      })

      // p.vertex(0, y + (this.state ? height : height/10));
      p.vertex(this.heightLfo(cycle), y + height/10);
      p.endShape();
    }

    heightLfo(cycle) {
      return sin((cycle * this.number), 0, this.height());
    }

    height() {
      let orbitCount = Object.keys(orbits).length
      return orbitCount > 0
        ? window.innerHeight / orbitCount
        : 0;
    }
  }

  function sin(value, from, to) {
    let usin = (Math.sin(value/10) + 1) / 2
    return Math.round((usin + from) * (to - from));
  }

}
