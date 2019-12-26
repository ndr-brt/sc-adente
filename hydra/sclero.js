osc(15)
  .color(0.5,3.8,0.8)
  .rotate(a.fft[2], 0.1)
  .modulate(
  	osc(10)
  		.rotate(0.3)
  		.add(o0, 0.1)
  )
  .add(
   	osc(2,0.01,1)
  		.color(a.fft[1],0.8,1)
  ).out(o0)

s0.initScreen()

osc(5,0.05, 0.7)
  .color(0.9,() => a.fft[3]*3.7,0.5)
  .mult(o0)
  .modulate(o1,0.55)
  .out(o1)

a.show()

shape(4, ({time}) => 100/(time%2000+1), 0.02)
  .mult(o1)
  .scrollX(1, -0.25)
  .rotate(({time}) => (time*a.fft[0])%31 )
  .modulate(s0, ({time}) => (time%10)/10)
  .out(o2)

render(o2)
