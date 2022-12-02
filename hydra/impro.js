a.show()
a.setSmooth(0.2)
a.setBins(4);

osc(4, 2)
  .add(osc().rotate(2, 3))
  .mask(noise(({time}) => time/2))
  .out()

osc(({time}) => time/10, 0.2, 2)
  .add(osc(99, 0.5, 0.9).rotate(({time}) => time/10))
  // .mask(noise(({time}) => time % 10))
  .out()
