import Data.Char (isDigit)
import Data.List (transpose)

main = do
  input <- getContents
  let races = map toTuple $ transpose $ map readNumbers $ lines input
  print $ product $ map (length . race) races
  let bigRace = toTuple $ map (read . filter isDigit) $ lines input :: (Int, Int)
  print $ length $ race bigRace

readNumbers :: String -> [Int]
readNumbers [] = []
readNumbers input =
  let digits = takeWhile isDigit input
   in if null digits
        then readNumbers $ tail input
        else read digits : readNumbers (drop (length digits) input)

toTuple (a : b : xs) = (a, b)

race :: (Int, Int) -> [(Int, Int)]
race (time, record) =
  filter (\(_, distance) -> distance > record) $
    map (\x -> (x, (time - x) * x)) [1 .. time - 1]
