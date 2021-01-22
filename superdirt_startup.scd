(

s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
s.options.memSize = 32768 * 16; // increase this if you get "alloc failed" messages
s.options.maxNodes = 2048 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.maxLogins = 8;

s.waitForBoot {
  ~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
  loadRelative("synths/*.scd");
  ~dirt.loadSoundFiles;
  ~dirt.loadSoundFiles("~/.sam-ples/*");

  ~dirt.start(57120, 0!10);

  (
    ~d1 = ~dirt.orbits[0];
    ~d2 = ~dirt.orbits[1];
    ~d3 = ~dirt.orbits[2];
    ~d4 = ~dirt.orbits[3];
    ~d5 = ~dirt.orbits[4];
    ~d6 = ~dirt.orbits[5];
    ~d7 = ~dirt.orbits[6];
    ~d8 = ~dirt.orbits[7];
    ~d9 = ~dirt.orbits[8];
    ~d10 = ~dirt.orbits[9];
  );

  ~dirt.orbits.do { |x|
    var clouds = GlobalDirtEffect(\global_mi_clouds, [\cloudspitch, \cloudspos, \cloudssize, \cloudsdens, \cloudstex, \cloudswet, \cloudsgain, \cloudsspread, \cloudsrvb, \cloudsfb, \cloudsfreeze, \cloudsmode, \cloudslofi]);
    var verb = GlobalDirtEffect(\global_mi_verb, [\verbwet, \verbtime, \verbdamp, \verbhp, \verbfreeze, \verbdiff, \verbgain]);
    x.globalEffects = x.globalEffects
      .addFirst(clouds)
      .addFirst(verb);

    x.initNodeTree;
  };

};

s.latency = 0.3; // increase this if you get "late" messages

// FreqScope.new(500, 50 , 0, server: s);
// s.meter;
s.makeGui;

// ~dirt.startSendRMS;

);


(
var on, off, cc;
var osc;

osc = NetAddr.new("127.0.0.1", 6010);

MIDIClient.init;
MIDIIn.connectAll;

on = MIDIFunc.noteOn({ |val, num, chan, src|
  postf("noteon (val %, num %, chan %, src %)", val, num, chan, src);
	osc.sendMsg("/ctrl", num.asString, val/127);
});

off = MIDIFunc.noteOff({ |val, num, chan, src|
  postf("noteoff (val %, num %, chan %, src %)", val, num, chan, src);
	osc.sendMsg("/ctrl", num.asString, 0);
});

cc = MIDIFunc.cc({ |val, num, chan, src|
  postf("cc (val %, num %, chan %, src %)", val, num, chan, src);
	osc.sendMsg("/ctrl", num.asString, val/127);
});

if (~stopMidiToOsc != nil, {
	~stopMidiToOsc.value;
});

~stopMidiToOsc = {
	on.free;
	off.free;
	cc.free;
};
)

// Evaluate the line below to stop it.
~stopMidiToOsc.value;
