:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context
import System.IO (hSetEncoding, stdout, utf8)
hSetEncoding stdout utf8

tidal <- startTidal (superdirtTarget {oLatency = 0.15, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cFrameTimespan = 1/20})

-- :{
-- tidal <- startMulti [
--     superdirtTarget {oLatency = 0.2, oAddress = "127.0.0.1", oPort = 57120},
--     superdirtTarget {oLatency = 0.2, oAddress = "127.0.0.1", oPort = 2020, oTimestamp = NoStamp}
--   ] (defaultConfig {cFrameTimespan = 1/20})
-- :}

:{
let p = streamReplace tidal
    hush = streamHush tidal
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
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

:{
let setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
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

-- shortcuts taken from BootTidalCustom, improved
:{
let
  cyc = (toRational . floor) <$> sig id

  bps b = setcps (b/2)
  bpm b = setcps (b/2/120)

  adsr = grp [mF "attack",  mF "decay", mF "sustain", mF "release"]
  asr = grp [mF "attack", mF "sustain", mF "release"]
  ar = grp [mF "attack", mF "release"]
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
  lesl = grp [mF "leslie", mF "lrate", mF "lsize"]
  fshi = grp [mF "fshift", mF "fshiftnote", mF "fshiftphase"]
  rmod = grp [mF "ring", mF "ringf", mF "ringdf"]
  oct = grp [mF "octer", mF "octersub", mF "octersubsub"]
  sdel = grp [mF "xsdelay", mF "tsdelay"]
  kru = grp [mF "krush", mF "kcutoff"]
  scon = grp [mF "real", mF "imag"]

  -- FX groups' function version
  adsr' a d s r = attack a # decay d # sustain s # release r
  asr' a s r = attack a # sustain s # release r
  ar' a r = attack a # release r
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
  lesl' l r s = leslie l # lrate r # lsize l
  fshi' f n p = fshift f # fshiftnote n # fshiftphase p
  rmod' a f s = ring a # ringf f # ringdf s
  oct' o s ss = octer o # octersub s # octersubsub ss
  sdel' x t = xsdelay x # tsdelay t
  kru' k c = krush k # kcutoff c
  scon' r i = real r # imag i

  -- runs of numbers
  r = run
  ri a = rev (r a) -- run inverted
  rodd a = (((r a) + 1) * 2) - 1 -- run of odd numbers
  reven a = ((r a) + 1) * 2 -- run of even numbers
  roddi a = rev (rodd a) -- run of odd numbers inverted
  reveni a = rev (reven a) -- run of even numbers inv erted

  c = choose
  codd a = c $ take a [1,3..] -- choose an odd number
  ceven a = c $ take a [0,2..] -- choose an even number

  -- transitions
  j p n  = jumpIn' p n
  j2 p   = jumpIn' p 2
  j4 p   = jumpIn' p 4
  j8 p   = jumpIn' p 8
  j16 p  = jumpIn' p 16
  xf p n = xfadeIn  p n
  xf2 p  = xfadeIn  p 2
  xf4 p  = xfadeIn  p 4
  xf8 p  = xfadeIn  p 8
  xf16 p = xfadeIn  p 16
  cl p n = clutchIn p n
  cl2 p  = clutchIn p 2
  cl4 p  = clutchIn p 4
  cl8 p  = clutchIn p 8
  cl16 p = clutchIn p 16

  sin = sine
  cos = cosine
  sq  = square
  pulse w = sig $ \t -> if ((snd $ properFraction t) >= w) then 1.0 else 0.0
  pw = pulse

  -- range shorthands
  range' from to p = (p*to - p*from) + from
  rg = range
  rg' = range'
  rgx = rangex

  -- continuous at freq
  sinf  f = fast f $ sin -- sine at freq
  cosf  f = fast f $ cos -- cosine at freq
  trif  f = fast f $ tri -- triangle at freq
  sawf  f = fast f $ saw -- saw at freq
  isawf f = fast f $ isaw -- inverted saw at freq
  sqf   f = fast f $ sq -- square at freq
  pwf w f = fast f $ pw w -- pulse at freq
  randf f = fast f $ rand -- rand at freq

  -- ranged continuous
  rsin i o = rg' i o sin -- ranged' sine
  rcos i o = rg' i o cos -- ranged' cosine
  rtri i o = rg' i o tri -- ranged' triangle
  rsaw i o = rg' i o saw -- ranged' saw
  risaw i o = rg' i o isaw -- ranged' inverted saw
  rsq i o = rg' i o sq -- ranged' square
  rrand i o = rg' i o rand -- ranged' rand
  rxsin i o = rgx i o sin -- ranged' exponential sine
  rxcos i o = rgx i o cos -- ranged' exponential cosine
  rxtri i o = rgx i o tri -- ranged' exponential triangle
  rxsaw i o = rgx i o saw -- ranged' exponential saw
  rxisaw i o = rgx i o isaw -- ranged' exponential inverted saw
  rxsq  i o = rgx i o sq -- ranged' exponential sqaure
  rxpw i o w = rgx i o pw w -- ranged' exponential pulse
  rxrand i o = rgx i o rand -- ranged' exponential rand

  -- ranged continuous at freq
  rsinf i o f = fast f $ rsin i o -- ranged' sine at freq
  rcosf i o f = fast f $ rcos i o -- ranged' cosine at freq
  rtrif i o f = fast f $ rtri i o -- ranged' triangle at freq
  rsawf i o f = fast f $ rsaw i o -- ranged' saw at freq
  risawf i o f = fast f $ risaw i o  -- ranged' inverted saw at freq
  rsqf i o f = fast f $ rsq i o  -- ranged' square at freq
  rrandf i o f = fast f $ rrand i o -- ranged' rand at freq
  rxsinf i o f = fast f $ rxsin i o -- ranged' exponential sine at freq
  rxcosf i o f = fast f $ rxcos i o -- ranged' exponential cosine at freq
  rxtrif i o f = fast f $ rxtri i o -- ranged' exponential triangle at freq
  rxsawf i o f = fast f $ rxsaw i o -- ranged' exponential saw at freq
  rxisawf i o f = fast f $ rxisaw i o -- ranged' exponential inverted saw at freq
  rxsqf i o f = fast f $ rxsq i o -- ranged' exponential square at freq
  rxpwf i o w f = fast f $ rxpw i o w -- ranged' exponential pulse at freq
  rxrandf i o f = fast f $ rxrand i o  -- ranged' exponential random at freq

  -- random shit
  screw l c p = loopAt l $ chop c $ p
  toggle t f p = if (1 == t) then f $ p else id $ p
  tog = toggle

  -- shortcuts
  str = striate
  strBy = striateBy
  fE = foldEvery
  ev = every
  oa = offadd
  sp = speed
  ac = accelerate
  sl = slow
  fa = fast
  m = mute
  i = id
  g = gain
  o = orbit
  u = up
  deg = degrade
  degBy = degradeBy
  seg = segment

  -- convert continuous functions to floats, ints, melodies x / x' (struct version)
  c2f  t p = seg t $ p -- continuous to floats
  c2f' t p = struct t $ p -- continuous to structured floats
  c2i  t p = quantise 1 $ c2f t p -- continuous to ints
  c2i' t p = quantise 1 $ c2f' t p -- continuous to structured ints
  c2m  s t p = scale s $ round <$> (c2f t p) -- continuous to melodic scale
  c2m' s t p = scale s $ round <$> (c2f' t p) -- continuous to structured melodic scale

:}

:set prompt "tidal> "
:set prompt-cont ""
