# Tidal cheatsheet

## Silence
* (not a lot to say... shut up that sound!) **silence**
* (shut up everything) **hush**

## Oscillators
### Wave
* (output 0 to 1) **sine**, **cosine**, **square**, **tri**, **saw**, **isaw**

### Random
* (output 0 to 1) **rand**
* (int output 0 to N) **irand** N
* (smooth noise) **perlin**
* (smooth noise with input) **perlinWith** (saw * 4)
* (2d noise with custom pattern as 2nd dimension) **perlin2** (sine*4)
* (2d noise with custom dimensions) **perlin2With** (cosine*2) (sine*2)

### Choose
* (choose an item from a list) **choose** [0,1,...]
* (use pattern to choose) **chooseBy** "0 0.25 0.5" [0, 2, 3]
* (weight choice) **wchoose** [(0,0.25),(2,0.5),(3,0.25)]
* (weight choice by pattern) **wchooseBy** "0 0.4 0.7" [(0,0.25),(2,0.5),(3,0.25)]

## Functions
### Control
* (change fade-in time) **attack** "0 1"
* (change fade-out time) **release** "<0.5 1>"
* (lower the sample rate, factor) **coarse** "<4 8 16 24>"
* (bit crusher, 1 max, 16 min) **crush** "8"
* (send effects on separate channel) **orbit** 1
* (initial signal level of delay) **delay** "0.5"
* (feedback level of delay) **delayfb** "0.7"
* (length of delay time) **delaytime** 0.7
* (change volume) **gain** 0.8
* (control dry/wet) **leslie** 2
* (leslie modulation rate) **lrate** 6.7
* (leslie cabinet size in meters) **lsize** 3.4
* (play sample N times in loop) **loop** "2.3"
* (make sample fit the given number of cycles) **loopAt** 4
* (convert midi to note) **midinote** 62
* (give swing feel, 0 human, 1 machine) **nudge** 0.7
* (change pan) **pan** 0.7
* (change how much reverb in mix) **room** 0.8
* (change reverb size) **size** 0.7
* (waveshape distortion. 1 is louuud!) **shape** 0.7
* (pitch raise with crazy stuffy, from 1 to inf) **squiz** "1 2 8 256"
* (voice effect) **vowel** "a e i o u"
* (divide audio into segments and discard a fraction of them from 0 to 100) **waveloss** "20 0.6 100"

#### Sample
* (load a sample) **s** "bd"
* (change sample ordinality) **n** 2
* (change start time of pattern) **begin** "<0 0.25 0.5>"
* (change finish time of pattern) **end** "<0 0.25 0.5>"

#### Filter
* (bandpass filter, cutoff frequency) **bpf** 3000
* (bandpass filter, q-factor) **bpq** 0.5
* (lowpass filter, cutoff frequency) **lpf** 3000
* (lowpass filter, resonance) **lpq** 0.5
* (hipass filter, cutoff frequency) **hpf** 3000
* (hipass filter, resonance) **hpq** 0.5

#### Speed
* (change tempo, factor) **cps** "<1 0.5 2>"
* (change sample speed) **speed** "<1 -1>"
* (speed up or down sample) **accelerate** "<0 1 -1>"
* (change pitch, in semitones) **up** "<0 1 5>"
* (change how speed parameter is considered):
  * "r" (default): multiplies sample playback rate
  * "c": playback rate relative to cycle length
  * "s": playback length in seconds

#### Cut
* (cut sample when another starts on same cutgroup) **cut** "1"
* (cut only sample when it recours) **cut** "-1"
* (creative use of cut) sound "bev(3,8)" # **cut** "[1 2 4]*2"

### Hi Order

* (apply another function conditionally) **every** 3 (fun)
* (apply function to some cycles) **whenmod** 4 3 (fast 4) $ s "bd sn"
* (add offset to every) **every'** 3 1 (fun)
* (applies another function to matching events in a pattern) **fix** (# crush 3) (n "[1,4]")
* (run every with different arguments) **foldEvery** [3,4,5] (fast 2)
* (apply one or another function conditionally) **ifp** (rand > 0.7) (striate 4) (# coarse "24 48")
* (applies stereo effects with a function) **jux** (rev)
* (parametrize pan of jux with values from 0 to 1) **juxBy** 0.5 (rev)
* (apply a function over the same pattern) **superimpose** (fast 2)
* (apply different functions to same pattern) **layer** [id, rev, fast 2]
* (superimpose but with an offset in cycle time) **off** 0.25 (# crush 2)
* (apply different functions for every cycle) **spread** ($) [rev, fast 2]
* (apply different functions for every cycle, randomly) **spreadr** ($) [rev, fast 2]
* (apply different functions in a single cycle) **fastspread** (s) [(# speed 2), striate 3]
* (run pattern of patterns) **ur**
* (apply one control pattern to list of patterns) **weave** 4 (pan sine) [s "bd", s "casio"]
* (apply a list of functions to a pattern) **weaveWith** 3 (s "bd sn") [fast 2, chop 16]
* (apply a function only on a part of a pattern) **within** (0, 0.5) (fast 2)

#### Sometimes
Apply function to a pattern with different possibility
* (100%) **always** (# crush 2)
* (90%) **almostAlways** (fast 2)
* (75%) **often** (slow 3)
* (50%) **sometimes** (rev)
* (25%) **rarely** (# speed 2)
* (10%) **almostNever** (# accelerate 2)
* (0%) **never** (# cut 1)
* (can choose percentual) **sometimesBy** 0.93 (jux (rev))

* (as sometimes but on cycles) **someCycles** (# crush 3)
* (as sometimes but with probabilty) **someCyclesBy** 0.64 (# speed 3)

### Randomness and chance
* (randomly remove events from a pattern, 50% of the time) **degrade**
* (randomly remove events from a pattern with probability) **degradeBy** 0.7
* (play pattern randomly) **randcat** [s "bd*2 sn", sound "jvbass*3"]
* (chop the sample into pieces and play a random one each cycle) **randslice** 32
* (repeat each cycle a given number of times) **repeatCycles** 3
* (divide the pattern into number of parts and combine them radomly) **scramble** 3
* (divide the pattern into number of parts and combine without replacement) **shuffle** 3
* (repeat a pattern at random speeds) **stripe** 2
* (repeat a pattern at random speeds but also slow down by n) **slowstripe** 3

### Time Functions
* (make pattern sound a bit like breakbeat) **brak** "bd sn"
* (divides a pattern into a number of pats then cycles apply function) **chunk** 4 (# speed 2)
* (chunk in reverse direction) **chunk'**
* (speed up pattern) **fast** 2
* (slow down pattern) **slow** 2
* (shift pattern backward in time) every 4 (0.25 **<~**)
* (shift pattern foreward in time) every 4 (0.25 **~>**)
* (speed up pattern and increase speed control) **hurry** 3
* (divide a pattern, play the subdivisions and increment them each cycle) **iter** 4
* (iter in reverse direction) **iter'** 3
* (truncate a pattern) **trunc** 0.75
* (like truncate but fill the cycle) **linger** 0.25
* (applies rev to a pattern every other cycle) **palindrome**
* (reverse the pattern) **rev**
* (breaks each cycles and then delay every piece by n) **swingBy** (1/4)
* (alias for swingBy (1/3)) **swing**
* (play a portion of a pattern) **zoom** (0.25, 0.75)

### Granularization
* (cuts each sample into parts) **chop** 16
* (like cuts but bits organized differently) **striate** 8
* (specify the length of the parts) **striate'** 16 (1/4)
* (granulate every sample but every other grain is silent) **gap** 8

### Other Functions
* (append two patterns) **append** (s "bd sn") (s "arpy jvbass")
* (append two patterns into single cycle) **fastAppend** (s "bd sn") (s "arpy jvbass")

### Transitions
* (trigger a pattern at the specified number of cycles) **anticipate** 1
* (trigger a pattern at the specified number of cycles with time) **anticipate** 1 4
* (degrade the current pattern to while another undegrading next) ** **clutch** 1
* (degrade the current pattern to while another undegrading next with time) ** **clutchIn** 1 7
* (pan the last n version of the pattern across the field) **histpan** 3
* (interpolate between patterns) **interpolate** 2
* (interpolate between patterns in time) **interpolateIn** 2 8
* (jump directly into given pattern without transitions) **jump**
* (jump after number of cycles) **jumpIn** 3
* (jump after at least the specified number of cycles passed) **jumpIn'** 4
* (jump after cycle count mod given integer is zero) **jumpMod** 5
* (degrade pattern until ends in silence) **mortal** 1
* (wash away the current pattern applying a function then switching to next) **wash** (chop 8) 4
* (washes away the current pattern after a certain delay by applying a function to it over time then switching over to the next pattern) **superwash** (# accelerate "4 2") (striate 2) 1 4 6
* (stop a bit before playing new pattern) **wait** 2
* (crossfade between old and new pattern over the next two cycles) **xfade** 1
* (crossfade between old and new pattern over the next n cycles) **xfadeIn** 1  16