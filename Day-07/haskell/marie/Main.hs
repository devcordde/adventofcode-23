import Data.Bifunctor (bimap)
import Data.List (elemIndex, find, group, sort, sortBy)
import Data.Maybe (fromJust)

main = do
  input <- getContents
  print $ winnings $ parseHands hand input
  print $ winnings $ parseHands (hand . replace 'J' 'λ') input

winnings :: [(Hand, Int)] -> Int
winnings pairs = sum $ zipWith (curry (\(rank, (_, bid)) -> rank * bid)) [1 ..] (sort pairs)

parseHands :: ([Char] -> Hand) -> String -> [(Hand, Int)]
parseHands hand input = map (bimap hand read . splitAt 5) (lines input)

data Card where
  Card :: Char -> Card
  deriving (Eq)

instance Ord Card where
  (Card a) `compare` (Card b) = f b `compare` f a
    where
      f x = fromJust $ elemIndex x ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'λ']

data Hand = Hand [Card] HandType deriving (Eq)

instance Ord Hand where
  (Hand a aType) `compare` (Hand b bType) =
    if aType /= bType
      then bType `compare` aType
      else maybe EQ (uncurry compare) (find (uncurry (/=)) $ zip a b)

hand :: [Char] -> Hand
hand chars = Hand (map Card chars) $ handType chars

handType :: [Char] -> HandType
handType chars =
  if length chars == 5
    then
      let jokerCount = length $ filter (== 'λ') chars
          withoutJokers = filter (/= 'λ') chars
          cardCounts = sortBy (flip compare) $ map length $ group $ sort withoutJokers
       in if null withoutJokers
            then FiveOfAKind
            else case head cardCounts + jokerCount : tail cardCounts of
              [5] -> FiveOfAKind
              [4, 1] -> FourOfAKind
              [3, 2] -> FullHouse
              [3, 1, 1] -> ThreeOfAKind
              [2, 2, 1] -> TwoPair
              [2, 1, 1, 1] -> OnePair
              _ -> HighCard
    else error "Invalid hand."

data HandType = FiveOfAKind | FourOfAKind | FullHouse | ThreeOfAKind | TwoPair | OnePair | HighCard deriving (Eq, Ord)

replace :: (Eq a) => a -> a -> [a] -> [a]
replace a b = map $ \c -> if c == a then b else c
