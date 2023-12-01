import Data.Char (isDigit)
import Data.List (find, isPrefixOf)

main = do
  input <- getContents
  let inputLines = lines input
      numbers = findNumbers inputLines $ digits False
      numbersWithSpelled = findNumbers inputLines $ digits True
  print $ sum numbers
  print $ sum numbersWithSpelled

findNumbers :: [String] -> (String -> [Char]) -> [Int]
findNumbers lines digits =
  map
    ( \line ->
        let d = digits line
         in read [head d, last d] :: Int
    )
    lines

spelledNumbers :: [(String, Int)]
spelledNumbers =
  zip
    [ "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine"
    ]
    [1 ..]

digits :: Bool -> String -> [Char]
digits _ [] = []
digits withSpelled x =
  let rest = tail x
      first = head x
      num
        | isDigit first = [first]
        | withSpelled = case find (\(num, _) -> num `isPrefixOf` x) spelledNumbers of
            Just (_, c) -> [head $ show c]
            Nothing -> []
        | otherwise = []
   in num ++ digits withSpelled rest
