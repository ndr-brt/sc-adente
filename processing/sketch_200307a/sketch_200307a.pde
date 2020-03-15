import java.util.Iterator;
import java.util.Map;

import oscP5.*;
import netP5.*;

OscP5 osc;

Map<Integer, Orbit> orbits = new HashMap<Integer, Orbit>();
float cps = 0;
float showCycles = 4; // 1/speed
float lastCycle = 0;
float lastTime = 0;

void setup() {
  surface.setTitle("");
  smooth();
  size(960, 1020);
  osc = new OscP5(this, 2020);
}

void draw() {
  float now = millis();
  float elapsed = now - lastTime;
  float cycle = ((elapsed * cps)/1000) + lastCycle;
  // background(sin(now/20, 0.0, 205.0));
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
  int orbit = -1;
  float cycle = -1;

  for(i = 0; i < m.typetag().length(); ++i) {
    String name = m.get(i).stringValue();
    switch(name) {
      case "orbit":
        orbit = m.get(i+1).intValue();
        break;
      case "cycle":
        cycle = m.get(i+1).floatValue();
        break;
      case "cps":
        cps = m.get(i+1).floatValue();
        break;
    }
    ++i;
  }

  if (!orbits.containsKey(orbit)) {
    synchronized(orbits) {
      orbits.put(orbit, new Orbit(orbit));
    }
  }

  if (orbit >= 0 && cycle >= 0) {
    synchronized(orbits) {
      Event event = new Event(cycle, t);
      Orbit o = orbits.get(orbit);
      lastCycle = cycle;
      lastTime = t;
      o.add(event);
    }
  }
}

class Orbit {
  Boolean state = false;
  ArrayList<Event> events = new ArrayList<Event>();
  final int number;

  Orbit(int number) {
    this.number = number;
  }

  void add (Event event) {
    events.add(0,event);
    state = !state;
  }

  void draw(float cycle) {
    Boolean state = this.state;
    int roundedCycle = Math.round(cycle);
    int orbitFactor = roundedCycle + (number*15);
    // noFill();
    beginShape();
    fill(color(orbitFactor%255, (orbitFactor%126)*2, (orbitFactor*3)%255));
    // strokeWeight(4);
    // stroke(orbitFactor%255);
    vertex(width-(orbitFactor % width), state ? heightLfo(cycle)/10 : heightLfo(cycle));
    Iterator<Event> i = events.iterator();
    while (i.hasNext()) {
      Event event = i.next();
      float pos = (event.cycle-(cycle-showCycles))/showCycles;
      if (pos < 0) {
        i.remove();
      }
      else {
        vertex(width * pos * pos, state ? heightLfo(cycle)/10 : heightLfo(cycle));
        vertex(width * pos, state ? heightLfo(cycle) : heightLfo(cycle)/10); // triangles!
        state = !state;
      }
    }
    vertex(0, state ? heightLfo(cycle) : heightLfo(cycle)/10);
    endShape();
  }

  float heightLfo(float cycle) {
    return sin((cycle + number)*15, orbitHeight()/500, orbitHeight());
  }
}

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
