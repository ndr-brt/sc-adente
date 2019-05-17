(
var inputs = 2;
var outputs = 2;
Window.closeAll;

w = Window.new("Monitoring");

ServerMeterView.new(s, w, Point(0,0), inputs, outputs);

f = Buffer.alloc(s,1024,2);
b = Bus.audio(s,1);

c = ScopeView(w.view, Rect(ServerMeterView.getWidth(inputs, outputs), 0, 200, ServerMeterView.height));
c.bufnum = f.bufnum;
c.server_(s);
c.start;


w.alwaysOnTop = true;
w.front;
CmdPeriod.doOnce { w.close };

{ ScopeOut2.ar(In.ar(0, outputs), f.bufnum) }.play;

)

// try it!
{SinOsc.ar}.play;