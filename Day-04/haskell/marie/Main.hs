import Data.Char (isDigit)
import Data.Map qualified as Map

main = do
  input <- getContents
  let cards = map card $ lines input
      cardMap = Map.fromList $ map (\c -> (cardId c, (c, 1))) cards
  print $ sum $ map cardScore cards
  print $ sum $ map snd $ Map.elems $ evalCards 1 cardMap

type CardMap = Map.Map Int (Card, Int)

data Card = Card
  { cardId :: Int,
    ours :: [Int],
    winners :: [Int]
  }

evalCards :: Int -> CardMap -> CardMap
evalCards current cards = case Map.lookup current cards of
  Nothing -> cards
  Just (c, amount) ->
    let winnerAmount = length $ cardWinners c
        extraCardIds = take winnerAmount [current + 1 ..]
        extraCards = foldl (\acc key -> Map.insertWith (\_ (c, a) -> (c, a + amount)) key (c, amount) acc) cards extraCardIds
     in evalCards (current + 1) extraCards

cardWinners :: Card -> [Int]
cardWinners card = filter (`elem` ours card) $ winners card

cardScore :: Card -> Int
cardScore card =
  let w = cardWinners card
   in if null w
        then 0
        else foldl (\acc _ -> 2 * acc) 1 $ tail w

card :: String -> Card
card input =
  let (x : xs) = split ':' input
      cardId = read $ filter isDigit x :: Int
      nums :: [[Int]]
      nums = map (map read . (filter (not . null) . split ' ')) $ split '|' (head xs)
   in Card
        { cardId,
          ours = last nums,
          winners = head nums
        }

split :: Char -> String -> [String]
split _ [] = []
split c input =
  let part = takeWhile (/= c) input
   in part : split c (drop (length part + 1) input)
