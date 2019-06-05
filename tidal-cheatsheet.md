# Tidal cheatsheet

## Oscillators
### Wave
* (output 0 to 1) **sine**, **cosine**, **square**, **tri**, **saw**, **isaw**

### Random
* (output 0 to 1) **rand**
* (int output 0 to N) **irand** N

### Choose
* (choose an item from a list) **choose** [0,1,...]
* (use pattern to choose) **chooseBy** "0 0.25 0.5" [0, 2, 3]
* (weight choice) **wchoose** [(0,0.25),(2,0.5),(3,0.25)]
* (weight choice by pattern) **wchooseBy** "0 0.4 0.7" [(0,0.25),(2,0.5),(3,0.25)]
