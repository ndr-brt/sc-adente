(

// (1..SuperDirt.maxSampleNumChannels).do { |numChannels|
//
//   SynthDef("global_saw" ++ numChannels, { |dryBus, effectBus, sawgain=0, sawfreq1=440, sawfreq2=440, sawcutoff = 440, sawresonance = 0, sawpan = 0.5|
//     var drySignal = In.ar(dryBus, ~dirt.numChannels);
//     var signal = drySignal + (Saw.ar(sawfreq1) + Saw.ar(sawfreq2)) * sawgain;
//     var filtered = RLPF.ar(signal, sawcutoff, sawresonance);
//
//     Out.ar(effectBus, DirtPan.ar(filtered, ~dirt.numChannels, sawpan));
//   }, [\ir, \ir]).add;
//
// }

);
