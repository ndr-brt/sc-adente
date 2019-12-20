module BootTidalCustom where

import qualified Sound.Tidal.Scales as Scales
import qualified Sound.Tidal.Chords as Chords
import Sound.Tidal.Utils
import Sound.Tidal.Params
import Data.Maybe
import Control.Applicative

-- ranged continuous
rsin i o = rg' i o sin -- ranged' sine
rcos i o = rg' i o cos -- ranged' cosine
rtri i o = rg' i o tri -- ranged' triangle
rsaw i o = rg' i o saw -- ranged' saw
risaw i o = rg' i o isaw -- ranged' inverted saw
rsq i o = rg' i o sq -- ranged' square
-- rpw i o w = rg' i o pw w -- ranged' pulse
-- rpw' i o w = rg' i o pw' w -- ranged' pulse'
rrand i o = rg' i o rand -- ranged' rand
rxsin i o = rgx i o sin -- ranged' exponential sine
rxcos i o = rgx i o cos -- ranged' exponential cosine
rxtri i o = rgx i o tri -- ranged' exponential triangle
rxsaw i o = rgx i o saw -- ranged' exponential saw
rxisaw i o = rgx i o isaw -- ranged' exponential inverted saw
rxsq  i o = rgx i o sq -- ranged' exponential sqaure
rxpw i o w = rgx i o pw w -- ranged' exponential pulse
rxpw' i o w = rgx i o pw' w -- ranged' exponential pulse'
rxrand i o = rgx i o rand -- ranged' exponential rand

-- ranged continuous at freq
rsinf i o f = fast f $ rsin i o -- ranged' sine at freq
rcosf i o f = fast f $ rcos i o -- ranged' cosine at freq
rtrif i o f = fast f $ rtri i o -- ranged' triangle at freq
rsawf i o f = fast f $ rsaw i o -- ranged' saw at freq
risawf i o f = fast f $ risaw i o  -- ranged' inverted saw at freq
rsqf i o f = fast f $ rsq i o  -- ranged' square at freq
-- rpwf i o w f = fast f $ rpw' i o w -- ranged' pulse at freq
rrandf i o f = fast f $ rrand i o -- ranged' rand at freq
rxsinf i o f = fast f $ rxsin i o -- ranged' exponential sine at freq
rxcosf i o f = fast f $ rxcos i o -- ranged' exponential cosine at freq
rxtrif i o f = fast f $ rxtri i o -- ranged' exponential triangle at freq
rxsawf i o f = fast f $ rxsaw i o -- ranged' exponential saw at freq
rxisawf i o f = fast f $ rxisaw i o -- ranged' exponential inverted saw at freq
rxsqf i o f = fast f $ rxsq i o -- ranged' exponential square at freq
rxpwf i o w f = fast f $ rxpw i o w -- ranged' exponential pulse at freq
rxpwf' i o w f = fast f $ rxpw' i o w -- ranged' exponential pulse' at freq
rxrandf i o f = fast f $ rxrand i o  -- ranged' exponential random at freq

-- prime functions (not needed?)
-- ssin'  i o = sc'  i o sin  -- scaled' sine
-- scos'  i o = sc'  i o cos  -- scaled' cosine
-- stri'  i o = sc'  i o tri  -- scaled' triangle
-- ssaw' i o = sc'  i o saw  -- scaled' saw
-- ssq'   i o = sc'  i o sq   -- scaled' square
-- srand' i o = sc' i o rand  -- scaled' rand
-- ssinf' i o f = fast f $ ssin'   i o -- scaled' sine at freq
-- scosf' i o f = fast f $ scos'   i o -- scaled' cosine at freq
-- strif' i o f = fast f $ stri'   i o -- scaled' triangle at freq
-- ssawf' i o f = fast f $ ssaw'  i o -- scaled' saw at freq
-- ssqf'   i o f = fast f $ ssq'   i o -- scaled' square at freq
-- srandf' i o f = fast f $ srand' i o -- scaled' rand at freq

-- random shit
screw l c p = loopAt l $ chop c $ p
-- mute p = (const $ sound "~") p
toggle t f p = if (1 == t) then f $ p else id $ p
tog = toggle

-- sound bank protoype https://github.com/tidalcycles/Tidal/issues/231
-- bank p = with s_p (liftA2 (++) (p::Pattern String))
-- b = bank

-- shorthands
str = striate
str' = striate'
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
-- (>) = (#)
deg = degrade
degBy = degradeBy
seg = segment

-- limit values in a Pattern to n equally spaced divisions of 1.
-- quantise' :: (Functor f, RealFrac b) => b -> f b -> f b
quantise' n = fmap ((/n) . (fromIntegral :: RealFrac b => Int -> b) . round . (*n))

-- convert continuous functions to floats, ints, melodies x / x' (struct version)
c2f  t p = seg t $ p -- continuous to floats
c2f' t p = struct t $ p -- continuous to structured floats
c2i  t p = quantise' 1 $ c2f t p -- continuous to ints
c2i' t p = quantise' 1 $ c2f' t p -- continuous to structured ints
c2m  s t p = scale s $ round <$> (c2f t p) -- continuous to melodic scale
c2m' s t p = scale s $ round <$> (c2f' t p) -- continuous to structured melodic scale

-- harmony
chordTable = Chords.chordTable
scaleList = Scales.scaleList
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
