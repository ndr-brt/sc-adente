import java.util.Iterator;
import java.util.Map;

import oscP5.*;
import netP5.*;

OscP5 osc;

List<Shape> shapes = new ArrayList<>();

Map<Integer, Orbit> orbits = new HashMap<Integer, Orbit>();
float cps = 0;
float showCycles = 4; // 1/speed
float lastCycle = 0;
float lastTime = 0;

void setup() {
  smooth();
  fullScreen(1); // mettere 0 per fare su schermo grande
  osc = new OscP5(this, 57121);
}

void draw() {
  float now = millis();
  float elapsed = now - lastTime;
  float cycle = ((elapsed * cps)/1000) + lastCycle;
  // background(sin(now/20, 0.0, 205.0));
  fill(200,200,200);
  circle(100, 100, 100);
  background(0);
  synchronized(orbits) {
    pushMatrix();
    for (Integer orbitIndex : orbits.keySet()) {
      Orbit o = orbits.get(orbitIndex);
      if (orbitIndex > 0) {
        translate(0, orbitHeight());
      }
      o.draw(cycle);
    }
    popMatrix();
  }
}

void oscEvent(OscMessage m) {
  float t = millis();
  int i;
  int octave = 5;
  float legato = 1;
  float speed = 1;
  float pan = 0.5;
  float note = 0;
  float n = 0;
  float cyle = -1;

  for (i = 0; i < m.typetag().length(); ++i) {
    String name = m.get(i).stringValue();
    switch(name) {
      case "cycle": octave = m.get(i+1).floatValue(); break;
      case "octave": octave = m.get(i+1).intValue(); break;
      case "legato": legato = m.get(i+1).floatValue(); break;
      case "speed": speed = m.get(i+1).floatValue(); break;
      case "pan": pan = m.get(i+1).floatValue() - 0.5; break;
      case "note": note = m.get(i+1).floatValue(); break;
      case "n": n = m.get(i+1).floatValue(); break;
    }
    ++i;
  }

  int cycleNumber = floor(cycle);
  float cycleOffset = cycle - cycleNumber;

  float distanceFromCenter = centerY / noteSpectre * (octave*12 + note);
  float quadrant = cycleNumber + octave;

  float offset = cycleNumber % 2 == 0 ? (1 - cycleOffset) : cycleOffset
  float angle = PI/1.5 * (offset + quadrant)

  float cathetusX = distanceFromCenter * cos(angle) + (pan * centerX)
  float cathetusY = distanceFromCenter * sin(angle)

  shapes.add(new Shape(
    10 * (legato/4+0.75) * (20/octave) + (30/speed) + (10/(1+note)),
    speed,
    cycleNumber,
    255,
    centerX + cathetusX,
    centerY + cathetusY
  ));

}

class Shape {
  float size;
  float speed;
  int cycle;
  float alpha;
  float x;
  float y;

  Shape(float size, float speed, int cycle, float alpha, float x, float y) {
    this.size = size;
    this.speed = speed;
    this.cycle = cycle;
    this.alpha = alpha;
    this.x = x;
    this.y = y;
  }
}
//
// class Orbit {
//   Boolean state = false;
//   ArrayList<Event> events = new ArrayList<Event>();
//   final int number;
//
//   Orbit(int number) {
//     this.number = number;
//   }
//
//   void add (Event event) {
//     events.add(0,event);
//     state = !state;
//   }
//
//   void draw(float cycle) {
//     Boolean state = this.state;
//     int roundedCycle = Math.round(cycle);
//     int orbitFactor = roundedCycle + (number*15);
//     // noFill();
//     beginShape();
//     fill(color(orbitFactor%255, (orbitFactor%126)*2, (orbitFactor*3)%255));
//     // strokeWeight(4);
//     // stroke(orbitFactor%255);
//     vertex(width-(orbitFactor % width), state ? heightLfo(cycle)/10 : heightLfo(cycle));
//     Iterator<Event> i = events.iterator();
//     while (i.hasNext()) {
//       Event event = i.next();
//       float pos = (event.cycle-(cycle-showCycles))/showCycles;
//       if (pos < 0) {
//         i.remove();
//       }
//       else {
//         vertex(width * pos * pos, state ? heightLfo(cycle)/10 : heightLfo(cycle));
//         vertex(width * pos, state ? heightLfo(cycle) : heightLfo(cycle)/10); // triangles!
//         state = !state;
//       }
//     }
//     vertex(0, state ? heightLfo(cycle) : heightLfo(cycle)/10);
//     endShape();
//   }
//
//   float heightLfo(float cycle) {
//     return sin((cycle + number)*15, orbitHeight()/500, orbitHeight());
//   }
// }

int orbitHeight() {
  return orbits.size() > 0
    ? height / orbits.size()
    : 0;
}

class Event {
  float cycle;
  float start;

  Event(float cycle, float start) {
    this.cycle = cycle;
    this.start = start;
  }
}

float sin(float value, float from, float to) {
  return Math.round((Math.sin(Math.toRadians(value)) + from) * (to - from));
}
