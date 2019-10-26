shape(6.0, 0.1, 0)
  .mult(osc(10).rotate(({time}) => time % 360))
  .out()
