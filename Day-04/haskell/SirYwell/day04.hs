import Data.Char (isDigit)
main = do
  input <- readFile "input/day04.txt"
  let l = lines input
  let cards = map parseCard l
  print $ sum $ map (foldr (\_ r -> if r == 0 then 1 else r * 2) 0 . (\(_, w, o) -> filter (`elem` w) o)) cards
  print $ sum $ map fst $ explode cards

type Card = (Int, [Int], [Int])

explode :: [Card] -> [(Int, Card)]
explode cards = explode' (map (\v -> (1, v)) cards)
  where
    explode' [] = []
    explode' (c@(n, (_, w, o)):r) =
      let overlap = length $ filter (`elem` w) o
      in c : explode' (mapWithIndex (\i d@(m, v) -> if i < overlap then (n + m, v) else d) r)

mapWithIndex :: (Int -> a -> a) -> [a] -> [a]
mapWithIndex = mapWithIndex' 0
 where
  mapWithIndex' _ _ [] = []
  mapWithIndex' i f (h:t) = f i h : mapWithIndex' (i + 1) f t

parseCard :: String -> Card
parseCard str =
  let
    (cardNum, r0) = parseNum $ dropWhile (not . isDigit) str
    (winningNumbers, r1) = parseNums r0
    (ourNumbers, _) = parseNums r1
  in
    (cardNum, winningNumbers, ourNumbers)

parseNums :: String -> ([Int], String)
parseNums s = parseNums' ([], searchFirst s)
  where
    searchFirst = dropWhile (not . isDigit)
    parseNums' (acc, []) = (acc, [])
    parseNums' (acc, l@(h:t))
      | h == ' ' = parseNums' (acc, t)
      | isDigit h = let (n, rem) = parseNum l in parseNums' (n : acc, rem)
      | otherwise = (acc, l)

parseNum :: String -> (Int, String)
parseNum = parseNum' 0
  where
    parseNum' acc [] = (acc, [])
    parseNum' acc (h:t) = if isDigit h then parseNum' (acc * 10 + (fromEnum h - fromEnum '0') ) t else (acc, t)
