a.show()
a.setSmooth(0.1)
a.setBins(4);

// noise(() => 6 * a.fft[1],.05)
src(o1)
.mult( osc(9,0, ()=>Math.sin(time/1.5)+2 ) )
.mult(
    noise(9,.03).brightness(3.2).contrast(2)
    .mult(osc(9,0, ()=>Math.sin(time/3)+13 ) )
)
.diff(
    noise(15,.04).brightness(.2).contrast(1.3)
    .mult( osc(9,0, ()=>Math.sin(time/5)+13 ) )
    .rotate( ()=>time )
)
.scale( ()=>Math.sin(time/6.2)*.12+.15 )
.modulateScale(
    osc(16,() => a.fft[2],0).mult( osc(3,0,0).rotate(3.14/2) )
    .rotate( ()=>time/25 ).scale(.39).scale(1,.6,1).invert()
    , ()=>Math.sin(time/5.3)*1.5+3  )
.rotate( ()=>time/22 )
.mult(shape(100,() => a.fft[1] + 0.2,.01).scale(1,.6,1)
  .scrollX(a.fft[2]+0.9).scrollY(a.fft[3]+0.7)
)
.out()

s0.initScreen()
src(s0).out(o1)
