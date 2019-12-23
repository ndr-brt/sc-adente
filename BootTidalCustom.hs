module BootTidalCustom where

import qualified Sound.Tidal.Scales as Scales
import qualified Sound.Tidal.Chords as Chords
import Sound.Tidal.Utils
import Sound.Tidal.Params
import Data.Maybe
import Control.Applicative

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
