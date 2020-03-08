import java.util.Iterator;
import java.util.Map;

import oscP5.*;
import netP5.*;

OscP5 osc;

Map<Integer, Orbit> orbits = new HashMap<Integer, Orbit>();
float cps = 0;
float showCycles = 2; // 1/speed
float lastCycle = 0;
float lastTime = 0;
int sizeY = 800;

void setup() {
  surface.setTitle("");
  smooth();
  size(400, 800);
  osc = new OscP5(this, 2020);
}

void draw() {
  background(125);
  float now = millis();
  float elapsed = now - lastTime;
  float cycle = ((elapsed * cps)/1000) + lastCycle;
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
      orbits.put(orbit, new Orbit());
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

  void add (Event event) {
    events.add(0,event);
    state = !state;
  }

  void draw(float cycle) {
    Boolean state = this.state;
    int roundedCycle = Math.round(cycle);
    //noFill();
    beginShape();
    fill(color(roundedCycle%255, (roundedCycle%126)*2, (roundedCycle*3)%255));
    strokeWeight(5);
    stroke(roundedCycle%255);
    //vertex(width, state ? 0 : h);
    Iterator<Event> i = events.iterator();
    while (i.hasNext()) {
      Event event = i.next();
      float pos = (event.cycle-(cycle-showCycles))/showCycles;
      if (pos < 0) {
        i.remove();
      }
      else {
        vertex(width * pos, state ? 0 : orbitHeight());
        //vertex(width * pos, state ? h : 0); triangles!
        state = !state;
      }
    }
    vertex(0, state ? 0 : orbitHeight());
    endShape();
  }
}

int orbitHeight() {
  return orbits.size() > 0
    ? sizeY / orbits.size()
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
