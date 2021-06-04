import qualified Sound.Tidal.Chords as Chords
import Data.Maybe
import Sound.Tidal.Utils
import Sound.Tidal.Params
import Control.Applicative

bps b = setcps (b/2)
bpm b = setcps (b/2/120)

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

--- Composite functions ------
transup n p = (|+ note n) $ p --courtesy of Guiot
transdown n p = (|- note n) $ p --courtesy of Guiot
degRange x y = degBy (range x y $ rand)
wchoose pairs = choose $ concatMap (\x -> replicate (fst x) (snd x)) pairs -- weighted choose with the syntax  wchoose [(2,'a'),(1,'b')] <- not sure who wrote this function
---------
--SIEVES--- implementation of the Xenakis' technique for pattern generation
restogen value offset amount  = [if (x `mod` value) == 0 then 1 else 0 | x <- [(0 + offset)..(amount + offset)]]
gen x y z = restogen x y z
sieveor val1 off1 val2 off2 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvor val1 off1 val2 off2 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveoror val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvoror val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveand val1 off1 val2 off2 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvand val1 off1 val2 off2 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveandand val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvandand val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveorand val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvorand val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveandor val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvandor val1 off1 val2 off2 val3 off3 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveororor val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvororor val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveororand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvororand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveorandand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvorandand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveandandand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvandandand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveandandor val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvandandor val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveandoror val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvandoror val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveandorand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvandorand val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 && (gen val2 off2 d !! x) == 1 || (gen val3 off3 d !! x) == 1 && (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sieveorandor val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then True else False | x <- [0..d-1]]
sieveinvorandor val1 off1 val2 off2 val3 off3 val4 off4 d = listToPat $ [if (gen val1 off1 d !! x) == 1 || (gen val2 off2 d !! x) == 1 && (gen val3 off3 d !! x) == 1 || (gen val4 off4 d !! x) == 1 then False else True | x <- [0..d-1]]
sor val1 off1 val2 off2 d p = slow ((fromIntegral d)/8) $ struct (sieveor val1 off1 val2 off2 d) $ p
soror val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveoror val1 off1 val2 off2 val3 off3 d) $ p
sand val1 off1 val2 off2 d p = slow ((fromIntegral d)/8) $ struct (sieveand val1 off1 val2 off2 d) $ p
sandand val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveandand val1 off1 val2 off2 val3 off3 d) $ p
sorand val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveorand val1 off1 val2 off2 val3 off3 d) $ p
sandor val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveandor val1 off1 val2 off2 val3 off3 d) $ p
sororor val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveororor val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sororand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveororand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sorandand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveorandand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sandandand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveandandand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sandandor val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveandandor val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sandoror val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveandoror val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sandorand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveandorand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sorandor val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveorandor val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvor val1 off1 val2 off2 d p = slow ((fromIntegral d)/8) $ struct (sieveinvor val1 off1 val2 off2 d) $ p
sinvoror val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveinvoror val1 off1 val2 off2 val3 off3 d) $ p
sinvand val1 off1 val2 off2 d p = slow ((fromIntegral d)/8) $ struct (sieveinvand val1 off1 val2 off2 d) $ p
sinvandand val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveinvandand val1 off1 val2 off2 val3 off3 d) $ p
sinvorand val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveinvorand val1 off1 val2 off2 val3 off3 d) $ p
sinvandor val1 off1 val2 off2 val3 off3 d p = slow ((fromIntegral d)/8) $ struct (sieveinvandor val1 off1 val2 off2 val3 off3 d) $ p
sinvororor val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvororor val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvororand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvororand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvorandand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvorandand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvandandand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvandandand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvandandor val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvandandor val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvandoror val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvandoror val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvandorand val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvandorand val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
sinvorandor val1 off1 val2 off2 val3 off3 val4 off4 d p = slow ((fromIntegral d)/8) $ struct (sieveinvorandor val1 off1 val2 off2 val3 off3 val4 off4 d) $ p
---------
--Post window functions--
replicator text1 = [putStr (text1) | x <- replicate 1000 text1]
flood text2 = sequence_(replicator text2) -- from Kindohm


--phaseShift by erwald
-- Gradually and cyclically shifts the phase of a pattern.
-- @shifts@ denotes how many times the pattern should shift before returning to its
-- original form (and is thus also the inverse of the shift's duration).
-- @shiftRepeats@ describes how many cycles the pattern should repeat between
-- shifts.
-- phaseShift :: Time -> Time -> Pattern a -> Pattern a
-- phaseShift shifts shiftRepeats = ((slow slowP (run shiftsP) / shiftsP) ~>)
-- where shiftsP = return shifts
    -- slowP = return (shifts * shiftRepeats)

rslice x p = slice x (segment (toTime <$> x) $ (irand x)) $ p
rsplice x p = splice x (segment (toTime <$> x) $ (irand x)) $ p

quieten = mapM_ (\i -> xfade i silence) [1 .. 16]
quietenIn t = mapM_ (\i -> xfadeIn i t silence) [1 .. 16]

loopStriate n k p = slow n ((linger (fromRational <$> (1/n)) . (~>) (fromRational <$> (k/n)) . striate (round <$> n)) p) |* speed (fromRational <$> (1/n)) # unit (pure "c")
