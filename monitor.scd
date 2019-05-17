(
var inputs = 2;
var outputs = 2;
var port = StaticText();
port.string = "Listen port: " + NetAddr.langPort;

Window.closeAll;

w = Window.new("Monitoring");

f = Buffer.alloc(s,1024,2);
b = Bus.audio(s,1);

c = ScopeView();
c.bufnum = f.bufnum;
c.server_(s);
c.start;

m = ServerMeterView.new(s, w, numIns: inputs, numOuts: outputs).view;
m.minHeight_(ServerMeterView.height);
m.minWidth_(ServerMeterView.getWidth(inputs, outputs, s));

w.layout = HLayout(VLayout(port, m), c);
w.alwaysOnTop = true;
w.front;
CmdPeriod.doOnce { w.close };

{ ScopeOut2.ar(In.ar(0, outputs), f.bufnum) }.play;

)

// try it!
{SinOsc.ar}.play;