(
b = Buffer.readChannel(s, "/home/andrea/Downloads/Owl_GreatHornedAlarmedAdult.wav", channels:1);

SynthDef(\Granny, {

	arg bufnum,
		freq = 10, fvar = 1,
		dur = 0.1, durvar = 0,
		pos = 0, posvar = 0,
		pitch = 1, pitchvar = 0,
		width = 0.2,
		gain = 0.5,
		lpfFreq = 400,
	mix = 0.3, room = 0.3, damp = 0.3
	;
	var signal;

	signal = GrainBuf.ar(
		numChannels: 2, // we want stereo!
		trigger: Impulse.kr(freq + (freq * (fvar * LFNoise2.kr(freq)))), // a UGen?
		dur: dur + (durvar * LFNoise2.kr(freq)), // in seconds
		sndbuf: bufnum,
		rate: pitch + (pitchvar * LFNoise2.kr(5)), // pitch !! WHAT IS THE SPEED OF VARIATIONS? setable??
		pos: pos + (posvar * LFNoise2.kr(freq)), // position 0-1
		interp: 2, // interpolation for pitchshifting
		pan: LFNoise1.kr(10).range(width.neg, width), // if numChannels=2, similar to Pan2, -1 left, +1 right
		//		envbunum: -1, // the buffer number cont. grain envelope
		maxGrains: 512,
		mul: gain,
		add: 0
	);

	signal = LPF.ar(
			in: signal,
			freq: lpfFreq);

	signal = FreeVerb.ar(signal, mix, room, damp);

	Out.ar(0, signal);

}).send(s)
)


// TESTS ////////////////////////////////////////////////////////////////
// execute these one line at the time to test
// if seting parameters through arguments work
x = Synth(\Granny, [\bufnum, b]); // construct the object / create a synth

// parameters:
x.set(\freq, 200);
x.set(\fvar, 0);
x.set(\dur, 0.3);
x.set(\durvar, 0.1);
x.set(\pos, 0.9);
x.set(\posvar, 0.01);
x.set(\pitch, 0.1);
x.set(\pitchvar, 0.01);
x.set(\width, 0.8);
x.set(\gain, 0.7);
x.set(\lpfFreq, { SinOsc.kr(5).range(100, 800) })
x.map(\lpfFreq, { SinOsc.kr(5).range(100, 800) });
x.set(\damp, 0.9);
x.free;


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// GUI time

(

// general color palette
QtGUI.palette = QPalette.dark;

// main window (for now)
~gwin = Window.new(
	"Granulators",
	Rect( left:20, top:20,
		width: 1000, height: 400 ));
~gwin.background = Color.gray(0.3,1);

~gwin.layout = HLayout(

	VLayout(

		StaticText().string_("GRANULATOR"),
		Button()
			.states_([
				["OFF", Color.gray(0.2), Color.gray(0.8)],
				["ON", Color.gray(0.8), Color.grey(0.2)] ])
			.mouseDownAction_({
				arg state;
				state.value.postln;
				if (state.value == 0) {
					~granSynth = Synth(\Granny, [\bufnum, b]);
				} {
					~granSynth.free;
				}
			})
			.minHeight_(70)
			.minWidth_(70),
		nil
	),

	VLayout(
		PopUpMenu().items_(["buffer1","file2","file3"]).font_(Font("Sans",20)),
		StaticText().string_("Filter vs. Position"),
		Slider2D()
			.x_(0.05)
			.y_(0.05)
			.action_({ arg slider;
				~granSynth.set(\pos, slider.x);
				~granSynth.set(\lpfFreq, slider.y.value.linexp(0,1,30,20000,nil))}),
		StaticText().string_("Position variation"),
		Slider(nil,Rect(0,0,50,10))
			.minHeight_(20)
			.thumbSize_(50)
			.action_({ arg posvar;
				posvar = posvar.value;
				~granSynth.set(\posvar, posvar.value);
				})
	),

	VLayout(

		StaticText().string_("Frequency of grains"),
		HLayout(
			Slider(nil,Rect(0,0,2,1)).minHeight_(50).thumbSize_(50)
				.action_({ arg freq;
					freq =  ((freq.value * 200) + 1).asInt;
					~granSynth.set(\freq, freq.value); freq.value.postln;
					~nbf.value_(freq)}),
			VLayout(nil,
				~nbf = NumberBox(nil,Rect(0,0,1,1))
					.font_(Font("Sans",20))
					.maxWidth_(50)
					.minHeight_(30);
				)
		),
		HLayout(
			StaticText().string_("variation"),
			Slider(nil,Rect(0,0,2,1)).thumbSize_(50)
			.action_({ arg fvar;
				fvar = fvar.value * 2;
				~granSynth.set(\fvar, fvar.value);
				})
		),
		nil,
		StaticText().string_("Duration of grains"),
		HLayout(
			Slider(nil,Rect(0,0,2,1)).minHeight_(50).thumbSize_(50)
				.action_({ arg dur;
					dur = dur.value;
					~granSynth.set(\dur, dur.value);
					~nbd.value_((dur.value * 100).asInt); }),
			VLayout(nil,
				~nbd = NumberBox(nil,Rect(0,0,1,1))
					.font_(Font("Sans", 20))
					.maxWidth_(50)
					.minHeight_(30);)
		),
		HLayout(StaticText().string_("variation"),
			Slider(nil,Rect(0,0,2,1)).thumbSize_(50)
				.action_({ arg durvar;
					durvar = durvar.value * 2;
					~granSynth.set(\durvar, durvar.value);
					})
		),
		nil,
		StaticText().string_("Pitch"),
		HLayout(
			Slider(nil,Rect(0,0,2,1)).minHeight_(20).thumbSize_(50)
				.action_({ arg pitch;
					pitch = pitch.value * 2;
					~granSynth.set(\pitch, pitch.value);
					~nbp.value_(pitch.value); }),
			VLayout(nil,
				~nbp = NumberBox()
					.font_(Font("Sans", 20))
					.maxWidth_(50)
					.minHeight_(30);)
		),
		HLayout(StaticText().string_("variation"),
			Slider(nil,Rect(0,0,2,1)).thumbSize_(50)
				.action_({ arg pitchvar;
					pitchvar = pitchvar.value;
					~granSynth.set(\pitchvar, pitchvar.value);
					})
		),
		nil,
		StaticText().string_("Width (Stereo)"),
		HLayout(
			Slider(nil,Rect(0,0,2,1)).minHeight_(20).thumbSize_(50).maxHeight_(20)
				.action_({ arg width;
					width = width.value;
					~granSynth.set(\width, width.value);
					~nbw.value_(width.value);
					}),
			VLayout(nil,
				~nbw = NumberBox()
					.font_(Font("Sans", 12))
					.maxWidth_(50).maxHeight_(20)
					.minHeight_(20);)
			)
	),
	VLayout(
		StaticText().string_("Gain")
			.align_(\center),
		Slider(nil, Rect(0,0,1,2))
			.minWidth_(50)
			.thumbSize_(50)
			.action_({ arg gain;
				~granSynth.set(\gain, gain.value.linexp(0,1,0.01,10,nil)-0.01 * 0.05)})
			.valueAction_(0)
		;
	)
);

~gwin.front;

~gwin.onClose_({
	~granSynth.free;
})

)