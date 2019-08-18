(
s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
s.options.memSize = 16384 * 16; // increase this if you get "alloc failed" messages
s.options.maxNodes = 2048 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary

s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	// ~dirt.loadSoundFiles;   // do not load basic samples on the shitty laptop!
	// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
	~dirt.loadSoundFiles("~/.sam-ples/*");
	// s.sync; // optionally: wait for samples to be read
	loadRelative("synths/*.scd");
	~dirt.start(57120, 0!6);

	(
		~d1 = ~dirt.orbits[0];
		~d2 = ~dirt.orbits[1];
		~d3 = ~dirt.orbits[2];
		~d4 = ~dirt.orbits[3];
		~d5 = ~dirt.orbits[4];
		~d6 = ~dirt.orbits[5];
	);
};

s.latency = 0.3; // increase this if you get "late" messages

FreqScope.new(500, 50 , 0, server: s);
s.meter;
s.scope;
s.makeGui;
);
