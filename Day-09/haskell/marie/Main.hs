import Data.Char (isSpace)

main = do
  input <- getContents
  let nums = map readNumbers $ lines input
  print $ sum $ map next nums
  print $ sum $ map (next . reverse) nums

diff :: [Int] -> [Int]
diff input = zipWith (flip (-)) input $ tail input

next :: [Int] -> Int
next values =
  last values
    + if all (== 0) values
      then 0
      else next (diff values)

readNumbers :: String -> [Int]
readNumbers [] = []
readNumbers input =
  let digits = takeWhile (not . isSpace) input
   in if null digits
        then readNumbers $ tail input
        else read digits : readNumbers (drop (length digits) input)
