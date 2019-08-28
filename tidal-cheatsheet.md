# Tidal cheatsheet

## Basic
*shut up*: **silence** (one synth) / **hush** (everything)
*orbit*: **orbit** { orbit channel }

## Oscillators
*waves*: **sine**, **cosine**, **square**, **tri**, **saw**, **isaw** { output 0 to 1 }
*random*: **rand** { 0 to 1 }, **irand** { 0 to N, int }
*smooth random*: **perlin**, **perlinWith** (val), **perlin2** (val), **perlin2With** (val) (val)
*choose*: **choose** [0,1,..], **chooseBy** "0 0.25 0.5" [0, 2, 3], **wchoose** [(0,0.25),(2,0.5),(3,0.25)], **wchooseBy** "0 0.4 0.7" [(0,0.25),(2,0.5),(3,0.25)]

## Synths
*basic*: **imp**, **psin**, **pmsin**, **gabor**, **cyclo**
*input*: **in**, **inr**
*drumkit*: **superkick**, **superhat**, **supersnare**, **superclap**, **super808**
*physical*: **supermandolin**, **supergong**, **superpiano**, **superhex**
*analogue*: **supersquare**, **supersaw**, **superpwm**, **supercomparator**
*digital*: **superchip**, **supernoise**

## Functions
*asr/ahr*: **attack** { time }, **release** { time }, **sustain** { time }, **hold** { time }
*bin scrambling*: **scram** { level }
*bin shifting*: **binshift** { level }
*bitcrush*: **crush** { level [0:15] }
*delay (del')*: **delay** { level }, **delayt** { level }, **delayfb** { level }
*distortion*: **shape** { level }, **distort** { level }, **triode** { level }
*frequency shifter (fshi')*: **fshift** { freqHz }, **fshiftnote** { note }, **fshiftphase** { phase }
*kursh (kru')*: **krush** { level[0:inf] }, **kcutoff** { freq }
*leslie (lesl')*: **leslie** { level }, **lrate** { rate }, **lsize** { size }
*magnitude freeze*: **freeze** { [0,1] }
*magnitude smearing*: **smear** { level }
*octer (oct')*: **octer** { level }, **octersub** { level }, **octersubsub** { level }
*reverb (rvb')*: **room** { level }, **size** { level}, **dry** { level }
*ring modulator (rmod')*: **ring** { level }, **ringf** { freq }, **ringdf** { slide }
*sample rate*: **coarse** { factor }
*squiz*: **squiz** { level [0:inf] }
*vowel*: **vowel** { [a,e,i,o,u] }
*waveloss*: **waveloss** { level [0:100] }

## Spectral
*spectral comb*: **comb** { level }
*spectral delay (sdel')*: **xsdelay** { level }, **tsdelay** { level }
*spectral hpass*: **hbrick** { level }
*spectral lpass*: **lbrick** { level }
*spectral conformer (scon')*: **real** { level }, **imag** { level }
*spectral enhancer*: **enhance** { level }

## Volume
*gain*: **gain** { level }
*amp*: **amp** { level }
*pan*: **pan** { level }

### Control

#### Scale
* (list scales) **scaleList**
* (get notes from scale) n (**scale** "major" "0..7")

#### Sample
* (load a sample) **s** "bd"
* (change sample ordinality) **n** 2
* (convert midi to note) **midinote** 62
* (change start time of sample) **begin** "<0 0.25 0.5>"
* (change finish time of sample) **end** "<0 0.25 0.5>"
* (play sample N times in loop) **loop** "2.3"

#### Binary
* (tell a pattern when it should play with true or false) **struct** "t ~ f t"
* (convert a number to binary, 8 bit) **binary** 132
* (convert a number to binary, n bit) **binaryN** n 132
* (convert an ascii char to binary, 8 bit each char) **ascii** "hey"

#### Filter
*lowpass*: **lpf** { freq }, **lpq** { resonance }
*hipass*: **hpf** { freq }, **hpq** { resonance }
*bandpass*: **bpf** { freq }, **bpq** { q-factor }
*djfilter*: **djf** { level }

#### Speed
* (change tempo, factor) **cps** "<1 0.5 2>"
* (change sample speed) **speed** "<1 -1>"
* (speed up or down sample) **accelerate** "<0 1 -1>"
* (give swing feel, 0 human, 1 machine) **nudge** 0.7
* (change pitch, in semitones) **up** "<0 1 5>"
* (change how speed parameter is considered):
  * "r" (default): multiplies sample playback rate
  * "c": playback rate relative to cycle length
  * "s": playback length in seconds

#### Cut
* (cut sample when another starts on same cutgroup) **cut** "1"
* (cut only sample when it recours) **cut** "-1"
* (creative use of cut) sound "bev(3,8)" # **cut** "[1 2 4]*2"
* (handle duration of the space 1 is until next note) # legato "1"

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
* (repeats each event the given number of times) **ply** 3 $ s "bd sn"
* (add a sort of delay to pattern elements with reduction and time) **stut** 4 0.5 0.1 $ s "bd sn"
* (like stut by applying a function every step) **stutWith** 4 0.5 (|* speed 1.5) $ s "bd sn"

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
* (make sample fit the given number of cycles) **loopAt** 4
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
* (turn a continuous pattern into a discrete one) **segment** 2 $ range 0 32 $ sine

### Granularization
* (cuts each sample into parts) **chop** 16
* (like cuts but bits organized differently) **striate** 8
* (specify the length of the parts) **striate'** 16 (1/4)
* (granulate every sample but every other grain is silent) **gap** 8
* (cuts sample into pieces and rearrange into pattern) **slice** 8 "7 2 4 1 2 [0..4]"

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
