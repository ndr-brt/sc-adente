import java.util.Iterator;
import java.util.Map;

import oscP5.*;
import netP5.*;

OscP5 osc;

float centerX = 0;
float centerY = 0;
int noteSpectre = 9 * 12; // octaves * notes per octave
ArrayList<Shape> shapes = new ArrayList<Shape>();

void setup() {
  smooth();
  frameRate(50);
  fullScreen(0); // mettere 0 per fare su schermo grande
  centerX = width/2;
  centerY = height/2;
  osc = new OscP5(this, 57121);
}

void draw() {
  background(0);
  synchronized(shapes) {
    // pushMatrix();
    for (Shape shape : shapes) {
      if (shape.alpha > 0) {
        fill(shape.distanceX() + shape.distanceY(), shape.cycle % 256, 0, shape.alpha);
        circle(shape.x, shape.y, shape.size);
        shape.doStep();
      }
    }
    // popMatrix();
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
  float cycle = -1;

  for (i = 0; i < m.typetag().length(); ++i) {
    String name = m.get(i).stringValue();
    switch(name) {
      case "cycle": cycle = m.get(i+1).floatValue(); break;
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

  float offset = cycleNumber % 2 == 0 ? (1 - cycleOffset) : cycleOffset;
  float angle = PI/1.5 * (offset + quadrant);

  float cathetusX = distanceFromCenter * cos(angle) + (pan * centerX);
  float cathetusY = distanceFromCenter * sin(angle);

  synchronized(shapes) {
    shapes.add(new Shape(
      10 * (legato/4+0.75) * (20/octave) + (30/speed) + (10/(1+note)),
      speed,
      cycleNumber,
      255,
      centerX + cathetusX,
      centerY + cathetusY
    ));
  }

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

  float distanceX() {
    return abs(this.x - centerX);
  }

  float distanceY() {
    return abs(this.y - centerY);
  }

  void doStep() {
    this.alpha = this.alpha - this.speed;
    this.x -= (this.x - centerX)/255;
    this.y -= (this.y - centerY)/255;
  }
}
