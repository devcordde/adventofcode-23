import Data.List (find, tails)
import Data.List.Utils (startswith)
import Data.Maybe

main = do
  input <- readFile "input/day01.txt"
  let preprocessed1 = extractNumbers directMappings (lines input)
  let preprocessed2 = extractNumbers mappings (lines input)
  print $ postprocess preprocessed1
  print $ postprocess preprocessed2

postprocess pre = sum $ map (\l -> fst l * 10 + snd l) pairs
  where
    pairs = map pair pre
    pair str = (head str, last str)

directMappings = [(show i, i) | i <- [1 .. 9]]

mappings = directMappings ++ zip ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"] [1..9]

extractNumbers :: [(String, Int)] -> [String] -> [[Int]]
extractNumbers m = map extractNumbers'
  where
    extractNumbers' str = processList extractNumber (tails str)
    extractNumber str = snd <$> find (\(a, _) -> startswith a str) m

processList :: (a -> Maybe b) -> [a] -> [b]
processList f = foldr (\x acc -> maybeToList (f x) ++ acc) []
