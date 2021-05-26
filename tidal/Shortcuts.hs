let ac = accelerate
    bs = binshift
    c = choose
    db = degradeBy
    deg = degrade
    degBy = degradeBy
    dis = distort
    ds = distort
    ev = every
    fE = foldEvery
    fa = fast
    g = gain
    h = hurry
    i = id
    m = mute
    o = orbit
    oc = octave
    oa = offadd
    over = superimpose
    sb = sometimesBy
    seg = segment
    shut = const $ silence
    si = superimpose
    sl = slow
    sp = speed
    str = striate
    strBy = striateBy
    u = up
    wl = waveloss

    cyc = (toRational . floor) <$> sig id
    sh t f p = superimpose ((hurry t).f) p
    so t f p = off t ((hurry t).f) p

    -- plays a sample in reverse at speed a every b cycles, timing the playback so it ends exactly when the next cycle begins.
    rinse a b p = ((1/a) <~) $ struct (slow b "t") $ loopAt (-1/a) $ p
    -- rinse' a b c = every b (const $ ((1/a) <~) $ slow a $ loopAt (-1/a) $ sound (c))
    -- rinse a b c d = every b (const $ ((1/a) <~) $ slow a $ loopAt (-1/a) $ sound c # n (irand d))

    adsr a d s r = attack a # decay d # sustain s # release r
    asr a s r = attack a # sustain s # release r
    ar a r = attack a # release r
    del l t f = delay l # delaytime t # delayfeedback f
    scc s c c' = shape s # coarse c # crush c'
    lp c r = cutoff c # resonance r
    bp f q = bandf f # bandq q
    hp c r = hcutoff c # hresonance r
    spa s a = speed s # accelerate a
    gco g c = gain g # cut c
    glo g l = gain g # legato l
    rvb r s = room r # size s
    io i o  = begin i # end o
    eq h b l q = cutoff l # resonance q # bandf b # bandq q # hcutoff h # hresonance q
    tremolo r d = tremolorate r # tremolodepth d
    phaser r d = phaserrate r # phaserdepth d
    lesl l r s = leslie l # lrate r # lsize l
    fshi f n p = fshift f # fshiftnote n # fshiftphase p
    rmod a f s = ring a # ringf f # ringdf s
    oct o s ss = octer o # octersub s # octersubsub ss
    sdel x t = xsdelay x # tsdelay t
    kru k c = krush k # kcutoff c
    scon r i = real r # imag i

    boo = hp 56 0.4
    down v = sustain v # ac "-1"

    -- runs of numbers
    r = run
    ri a = rev (r a) -- run inverted
    rodd a = (((r a) + 1) * 2) - 1 -- run of odd numbers
    reven a = ((r a) + 1) * 2 -- run of even numbers
    roddi a = rev (rodd a) -- run of odd inverted
    reveni a = rev (reven a) -- run of even numbers inv erted

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

    sinf  f = fast f $ sin -- sine at freq
    cosf  f = fast f $ cos -- cosine at freq
    trif  f = fast f $ tri -- triangle at freq
    sawf  f = fast f $ saw -- saw at freq
    isawf f = fast f $ isaw -- inverted saw at freq
    sqf   f = fast f $ sq -- square at freq
    pwf w f = fast f $ pw w -- pulse at freq
    randf f = fast f $ rand -- rand at freq

    -- range shorthands
    range' from to p = (p*to - p*from) + from
    rg = range
    rg' = range'
    rgx = rangex

    sply n = (ply n).(slow n)

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
