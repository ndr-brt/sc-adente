:set -XOverloadedStrings
:set prompt ""
:set prompt-cont ""

import Sound.Tidal.Context

-- total latency = oLatency + cFrameTimespan
tidal <- startTidal (superdirtTarget {oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cFrameTimespan = 1/20})

:{
let p = streamReplace tidal
    hush = streamHush tidal
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetI tidal
    setB = streamSetB tidal
    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13
    d14 = p 14
    d15 = p 15
    d16 = p 16
:}

-- benjolis params
:{
let
    oscA = pF "oscA"
    oscB = pF "oscB"
    runA = pF "runA"
    runB = pF "runB"
    runF = pF "runF"
    res = pF "res"
    freq = pF "freq"
:}

-- shortcuts taken from BootTidalCustom
:{
let
  bps b = setcps (b/2)
  bpm b = setcps (b/2/120)

  adsr = grp [mF "attack",  mF "decay", mF "sustain", mF "release"]
  del  = grp [mF "delay",   mF "delaytime", mF "delayfeedback"]
  scc  = grp [mF "shape",   mF "coarse", mF "crush"]
  lp  = grp [mF "lpf",  mF "lpq"]
  bp  = grp [mF "bpf",   mF "bpq"]
  hp  = grp [mF "hpf", mF "hpq"]
  spa  = grp [mF "speed",   mF "accelerate"]
  rvb  = grp [mF "room",    mF "size"]
  gco  = grp [mF "gain",    mF "cut"]
  glo  = grp [mF "gain",    mF "legato"]
  io   = grp [mF "begin",   mF "end"]
  eq   = grp [mF "cutoff",  mF "resonance", mF "bandf", mF "bandq", mF "hcutoff", mF "hresonance"]
  tremolo = grp [mF "tremolorate", mF "tremolodepth"]
  phaser  = grp [mF "phaserrate", mF "phaserdepth"]
  -- FX groups' function version
  adsr' a d s r = attack a # decay d # sustain s # release r
  del' l t f = delay l # delaytime t # delayfeedback f
  scc' s c c' = shape s # coarse c # crush c'
  lp' c r = cutoff c # resonance r
  bp' f q = bandf f # bandq q
  hp' c r = hcutoff c # hresonance r
  spa' s a = speed s # accelerate a
  gco' g c = gain g # cut c
  glo' g l = gain g # legato l
  rvb' r s = room r # size s
  io' i o  = begin i # end o
  eq' h b l q = cutoff l # resonance q # bandf b # bandq q # hcutoff h # hresonance q
  tremolo' r d = tremolorate r # tremolodepth d
  phaser' r d = phaserrate r # phaserdepth d
:}

:set prompt "tidal> "
