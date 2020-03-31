import qualified Sound.Tidal.Chords as Chords
import Data.Maybe
import Sound.Tidal.Utils
import Sound.Tidal.Params
import Control.Applicative

ac = accelerate
c = choose
deg = degrade
degBy = degradeBy
dis = distort
ev = every
fE = foldEvery
fa = fast
g = gain
i = id
m = mute
o = orbit
oa = offadd
seg = segment
sl = slow
sp = speed
str = striate
strBy = striateBy
u = up

cyc = (toRational . floor) <$> sig id

-- plays a sample in reverse at speed a every b cycles, timing the playback so it ends exactly when the next cycle begins.
-- rinse a b p = ((1/a) <~) $ struct (slow b "t") $ loopAt (-1/a) $ p
-- rinse' a b c = every b (const $ ((1/a) <~) $ slow a $ loopAt (-1/a) $ sound (c))
-- rinse a b c d = every b (const $ ((1/a) <~) $ slow a $ loopAt (-1/a) $ sound c # n (irand d))

bps b = setcps (b/2)
bpm b = setcps (b/2/120)

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

-- FX groups' function version
adsr' = adsr
asr' = asr
ar' = ar
del' = del
scc' = scc
lp' = lp
bp' = bp
hp' = hp
spa' = spa
gco' = gco
glo' = glo
rvb' = rvb
io' = io
eq' = eq
tremolo' = tremolo
phaser' = phaser
lesl' = lesl
fshi' = fshi
rmod' = rmod
oct' = oct
sdel' = sdel
kru' = kru
scon' = scon

-- runs of numbers
r = run
ri a = rev (r a) -- run inverted
rodd a = (((r a) + 1) * 2) - 1 -- run of odd numbers
reven a = ((r a) + 1) * 2 -- run of even numbers
roddi a = rev (rodd a) -- run of odd inverted
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

-- convert continuous functions to floats, ints, melodies x / x' (struct version)
c2f  t p = seg t $ p -- continuous to floats
c2f' t p = struct t $ p -- continuous to structured floats
c2i  t p = quantise 1 $ c2f t p -- continuous to ints
c2i' t p = quantise 1 $ c2f' t p -- continuous to structured ints
c2m  s t p = scale s $ round <$> (c2f t p) -- continuous to melodic scale
c2m' s t p = scale s $ round <$> (c2f' t p) -- continuous to structured melodic scale


-- harmony
chordTable = Chords.chordTable
majork = ["major", "minor", "minor", "major", "major", "minor", "dim7"]
minork = ["minor", "minor", "major", "minor", "major", "major", "major"]
doriank = ["minor", "minor", "major", "major", "minor", "dim7", "major"]
phrygiank = ["minor", "major", "major", "minor", "dim7", "major", "minor"]
lydiank = ["major", "major", "minor", "dim7", "major", "minor", "minor"]
mixolydiank = ["major", "minor", "dim7", "major", "minor", "minor", "major"]
locriank = ["dim7", "major", "minor", "minor", "major", "major", "minor"]
keyTable = [("major", majork),("minor", minork),("dorian", doriank),("phrygian", phrygiank),("lydian", lydiank),("mixolydian", mixolydiank),("locrian", locriank),("ionian", majork),("aeolian", minork)]
keyL p = (\name -> fromMaybe [] $ lookup name keyTable) <$> p
-- | @chord p@ turns a pattern of chord names into a pattern of
-- numbers, representing note value offsets for the chords
-- chord :: Num a => Pattern String -> Pattern a
chord p = flatpat $ Chords.chordL p
harmonise ch p = scale ch p + chord (flip (!!!) <$> p <*> keyL ch)

-- mute/solo
mutePatterns g = mapM (streamMute tidal) g
muteIntPatterns g = mutePatterns (map show g)
mutePatterns' s g = mutePatterns (fromJust $ lookup g s)
unmutePatterns g = mapM (streamUnmute tidal) g
unmuteIntPatterns g = unmutePatterns (map show g)
unmutePatterns' s g = unmutePatterns (fromJust $ lookup g s)
soloPatterns g = mapM (streamSolo tidal) g
soloPatterns' s g = soloPatterns (fromJust $ lookup g s)
unsoloPatterns g = mapM (streamUnsolo tidal) g
unsoloPatterns' s g = unsoloPatterns (fromJust $ lookup g s)
muteTrackPatterns t g = mapM (streamMute tidal) (map ((t ++ "-") ++) g)
muteTrackIntPatterns t g = muteTrackPatterns t (map show g)
muteTrackPatterns' t s g = muteTrackPatterns (fromJust $ lookup (map ((t ++ "-") ++) g) s)
unmuteTrackPatterns t g = mapM (streamUnmute tidal) (map ((t ++ "-") ++) g)
unmuteTrackIntPatterns t g = unmuteTrackPatterns t (map show g)
unmuteTrackPatterns' t s g = unmuteTrackPatterns (fromJust $ lookup (map ((t ++ "-") ++) g) s)
soloTrackPatterns t g = mapM (streamSolo tidal) (map ((t ++ "-") ++) g)
soloTrackPatterns' t s g = soloTrackPatterns (fromJust $ lookup (map ((t ++ "-") ++) g) s)
unsoloTrackPatterns t g = mapM (streamUnsolo tidal) (map ((t ++ "-") ++) g)
unsoloTrackPatterns' t s g = unsoloTrackPatterns (fromJust $ lookup (map ((t ++ "-") ++) g) s)
mp  = mutePatterns
md  = muteIntPatterns
mp' = mutePatterns'
ump = unmutePatterns
umd = unmuteIntPatterns
ump' = unmutePatterns'
-- sp = soloPatterns
-- sp' = soloPatterns'
usp = unsoloPatterns
usp' = unsoloPatterns'
mtp = muteTrackPatterns
mtd = muteTrackIntPatterns
mtp' = muteTrackPatterns'
umtp = unmuteTrackPatterns
umtd = unmuteTrackIntPatterns
umtp' = unmuteTrackPatterns'
stp = soloTrackPatterns
stp' = soloTrackPatterns'
ustp = unsoloTrackPatterns
ustp' = unsoloTrackPatterns'

-- naming patterns based on tracks
trackPatternName track patternName = p (track ++ "-" ++ patternName)
trackIntPattern track patternName = p (track ++ "-" ++ (show patternName))
tp = trackPatternName
td = trackIntPattern

-- named patterns or numbered patterns
track t mx dn ps p f = td t dn $ f $ (fromJust $ lookup p ps) # g (mx!!(dn-1)) # o (fromList [dn] -1)
track' t mx ps dn f = td t dn $ f $ (fromJust $ lookup dn ps) # g (mx!!(dn-1)) # o (fromList [dn] -1)
track'' t mx ps dn f = td t dn $ f $ (ps!!(dn-1)) # g (mx!!(dn-1)) # o (fromList [dn] -1)
tr = track
tr' = track'
tr'' = track''

-- apply function from map
f fs n = fromJust $ lookup n fs
