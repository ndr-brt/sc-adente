'use babel'

const osc = require('osc')

let orbits = {}
let cps = 0;
let showCycles = 4; // 1/speed
let lastCycle = 0;
let lastTimestamp = 0;

export default class Sketch {

  handle(p) {
    if (!this.udpPort) {
      this.udpPort = new osc.UDPPort({
        localAddress: "0.0.0.0",
        localPort: 2020
      });

      this.udpPort.on("ready", function () {
        console.log("Listening for OSC over UDP.");
      });

      this.udpPort.on("error", function (err) {
        console.log(err);
      });

      this.udpPort.open()
    }

    if (this.messageListener) {
      this.udpPort.removeListener("message", this.messageListener)
    }

    this.messageListener = function(oscMessage) {
      onMessage(oscMessage);
    }

    this.udpPort.on("message", this.messageListener);

    p.setup = (() => {
      p.smooth();
      p.frameRate(30);
    })

    p.draw = (() => {
      let now = new Date();
      let elapsed = now - lastTimestamp;
      let cycle = ((elapsed * cps)/1000) + lastCycle;
      p.background(0);

      // p.push();
      for (var orbitNumber in orbits) {
        // check if the property/key is defined in the object itself, not in parent
        if (orbits.hasOwnProperty(orbitNumber)) {
          let orbit = orbits[orbitNumber]
          if (orbit.number > 0) {
            p.translate(0, orbitHeight());
          }
          orbit.draw(p, cycle)
        }
      }
      // p.pop();
    })

    p.windowResized = () => {
      p.resizeCanvas(p.windowWidth, p.windowHeight);
    }
  }
}

function onMessage(oscMessage) {
  let timestamp = new Date();
  let orbit = -1;
  let cycle = -1;
  let arguments = oscMessage.args;
  for (var i = 0; i < arguments.length; i++) {
    let name = arguments[i];
    switch (name) {
      case 'orbit':
        orbit = arguments[i+1]
        break;
      case 'cycle':
        cycle = arguments[i+1]
        break;
      case 'cps':
        cps = arguments[i+1]
        break;
    }
  }
  // console.log(`Message parsed: orbit ${orbit}, cycle ${cycle}, cps ${cps}`)

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

  draw(p, cycle) {
    let roundedCycle = Math.round(cycle);
    let orbitFactor = roundedCycle + (this.number*15);
    let width = window.innerWidth;
    let height = this.heightLfo(cycle);
    //let height = window.innerHeight;

    p.beginShape();
    p.fill(p.color(orbitFactor%255, (orbitFactor%126)*2, (orbitFactor*3)%255));

    p.vertex(width-(orbitFactor % width), this.state ? height/10 : height);

    this.events.forEach(event => {
      let pos = (event.cycle-(cycle-showCycles))/showCycles;
      if (pos < 0) {
        const index = this.events.indexOf(event);
        if (index > -1) {
          this.events.splice(index, 1);
        }
      }
      else {
        p.vertex(width * pos * pos, this.state ? height/10 : height);
        p.vertex(width * pos, this.state ? height : height/10); // triangles!
        this.state = !this.state;
      }
    })

    p.vertex(0, this.state ? height : height/10);
    p.endShape();
  }

  heightLfo(cycle) {
    return sin((cycle + this.number)*15, orbitHeight()/500, orbitHeight());
  }
}

function orbitHeight() {
  let orbitCount = Object.keys(orbits).length
  return orbitCount > 0
    ? window.innerHeight / orbitCount
    : 0;
}

function sin(value, from, to) {
  return Math.round((Math.sin(value/10) + from) * (to - from));
}
