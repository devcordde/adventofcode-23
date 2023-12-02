import Data.Maybe
import Data.Text (pack, splitOn, unpack)
import Text.Read

main = do
  input <- readFile "input/day02.txt"
  let games = map createGame $ lines input
  let possible = filter isGamePossible games
  let fewestNeeded = map fewest games
  print $ sum $ map gameId possible
  print $ sum $ map (\(a, b, c) -> a * b * c) fewestNeeded

data Game = Game Int [Round]

newtype Round = Round [(String, Int)]

gameId (Game id _) = id

fewest :: Game -> (Int, Int, Int)
fewest (Game _ rounds) = minimalRound rounds
  where
    minimalRound = foldr ((\(r, g, b) (x, y, z) -> (max r x, max g y, max b z)) . colorCounts) (0, 0, 0)

isGamePossible :: Game -> Bool
isGamePossible (Game _ rounds) = all isRoundPossible rounds

isRoundPossible :: Round -> Bool
isRoundPossible round = let (red, green, blue) = colorCounts round in red <= 12 && green <= 13 && blue <= 14

colorCounts :: Round -> (Int, Int, Int)
colorCounts (Round cs) =
  let r = sum $ map snd $ filter (\(color, _) -> color == "red") cs
      g = sum $ map snd $ filter (\(color, _) -> color == "green") cs
      b = sum $ map snd $ filter (\(color, _) -> color == "blue") cs
   in (r, g, b)

createGame :: String -> Game
createGame s =
  let g = split ": " s
      r = createRounds $ last g
   in Game (toInt $ last $ words $ head g) r

split :: String -> String -> [String]
split on input = map unpack $ splitOn (pack on) (pack input)

toInt :: String -> Int
toInt s = fromJust (readMaybe s :: Maybe Int)

createRounds :: String -> [Round]
createRounds s =
  let v = split "; " s
      w = map (map ((\e -> (last e, toInt $ head e)) . words) . split ", ") v
   in map Round w
