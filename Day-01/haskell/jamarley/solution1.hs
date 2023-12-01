import Data.List
import Data.Char (isDigit, digitToInt)

getFirstLast :: [Int] -> Int
getFirstLast xs = read (show (head xs) ++ show (last xs)) 


main :: IO ()
main = do
        content <- readFile "input"
        print (sum (map (getFirstLast . map digitToInt . filter isDigit) (lines content)))
