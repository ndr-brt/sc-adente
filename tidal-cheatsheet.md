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
* (change start time of pattern) **begin** "<0 0.25 0.5>"
* (change finish time of pattern) **end** "<0 0.25 0.5>"
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
* (convert midi to note) **midinote** 62
* (change sample ordinality) **n** 2
* (give swing feel, 0 human, 1 machine) **nudge** 0.7
* (change pan) **pan** 0.7
* (change how much reverb in mix) **room** 0.8
* (change reverb size) **size** 0.7
* (waveshape distortion. 1 is louuud!) **shape** 0.7
* (load a sample) **s** "bd"
* (pitch raise with crazy stuffy, from 1 to inf) **squiz** "1 2 8 256"
* (voice effect) **vowel** "a e i o u"
* (divide audio into segments and discard a fraction of them from 0 to 100) **waveloss** "20 0.6 100"

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
