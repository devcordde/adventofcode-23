import Data.List.Split (wordsBy)
import Data.Text (replace, pack, unpack)
import Data.Char (isDigit, digitToInt, isLetter)

numberWords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

getFirstLast :: [Int] -> Int
getFirstLast xs = read (show (head xs) ++ show (last xs)) 

wordReplace :: String -> String
wordReplace word = case word of 
        "one" -> "o1e"
        "two" -> "t2o"
        "three" -> "t3e"
        "four" -> "f4"
        "five" -> "f5e"
        "six" -> "s6"
        "seven" -> "s7n"
        "eight" -> "e8t"
        "nine" -> "n9e"
        _ -> word
-- This is so fucking hacky what has my life even become

containsNumberWord :: String -> Bool
containsNumberWord str = any (`elem` numberWords) (wordsBy (not . isLetter) str)

replaceNumberWords :: String -> String
replaceNumberWords content = unpack $ foldr (\w acc -> replace (pack w) (pack $ wordReplace w) acc) (pack content) numberWords


main :: IO ()
main = do
        content <- readFile "input"
        print (sum (map (getFirstLast . map digitToInt . filter isDigit) (lines (replaceNumberWords content))))


