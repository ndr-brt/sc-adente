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
