main = do
  input <- readFile "input/day03.txt"
  let l = lines input
  let occs = parseNumberOccurrences l
  print $ sumPartNumbers $ filter (`hasAdjacent` occs) occs
  print $ sumGearNumbers occs

data Element = NumberOccurrence Int Int Int Int | SymbolOccurrence Int Int Char

parseNumberOccurrences :: [String] -> [Element]
parseNumberOccurrences = parseNumberOccurrencesPerLine 0
  where
    parseNumberOccurrencesPerLine _ [] = []
    parseNumberOccurrencesPerLine n (x:xs) = parseLine n 0 x ++ parseNumberOccurrencesPerLine (n + 1) xs
    parseLine _ _ [] = []
    parseLine n c ('.':ts) = parseLine n (c + 1) ts
    parseLine n c (t:ts) = if t < '0' || t > '9' then SymbolOccurrence n c t : parseLine n (c + 1) ts else parseNumber n c c (digitToInt t) ts
    parseNumber n c e v [] = [NumberOccurrence n c e v]
    parseNumber n c e v l@(t:ts) = if t < '0' || t > '9' then NumberOccurrence n c e v : parseLine n (e + 1) l else parseNumber n c (e + 1) (v * 10 + digitToInt t) ts

hasAdjacent :: Element -> [Element] -> Bool
hasAdjacent o@(NumberOccurrence n c e _) = any (isAdjacent o)
hasAdjacent _ = const False

isAdjacent :: Element -> Element -> Bool
isAdjacent (NumberOccurrence n c e _) (SymbolOccurrence x y _) = abs (n - x) <= 1 && min (abs (c - y)) (abs (e - y)) <= 1
isAdjacent _ _ = False

sumPartNumbers :: [Element] -> Int
sumPartNumbers [] = 0
sumPartNumbers ((NumberOccurrence _ _ _ v):xs) = v + sumPartNumbers xs

sumGearNumbers :: [Element] -> Int
sumGearNumbers o =
  let candidates = filter isGear o
  in sum $ map (`toGearRation` o) candidates

toGearRation :: Element -> [Element] -> Int
toGearRation candidate@(SymbolOccurrence _ _ '*') all =
  let r = filter (`isAdjacent` candidate) all
  in if length r == 2 then product $ map (\(NumberOccurrence _ _ _ v) -> v) r else 0

isGear :: Element -> Bool
isGear (SymbolOccurrence _ _ '*') = True
isGear _ = False

digitToInt :: Char -> Int
digitToInt c = fromEnum c - fromEnum '0'
