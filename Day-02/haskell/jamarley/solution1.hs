
import Data.List.Split (splitOn)
import Data.List (dropWhileEnd)

elimRow :: [(Integer, String)] -> [Bool] 
elimRow (x:xs) = case snd x of
        "red" -> (fst x < 13) : elimRow xs
        "green" -> (fst x < 14) : elimRow xs 
        "blue" -> (fst x < 15) : elimRow xs
        _ -> True : elimRow xs
elimRow _ = []

extractColorCounts :: String -> [(Integer, String)]
extractColorCounts = extractColor . map (dropWhileEnd (== ',') . dropWhileEnd (== ';')) . words . drop 2 . dropWhile (/= ':')

extractColor :: [String] -> [(Integer, String)]
extractColor (x:y:xs) = (read x, y) : extractColor xs
extractColor _ = []

main :: IO ()
main = do
        content <- readFile "input"
        print (sum . map fst . filter snd . zip [1..] $ map (and . elimRow . extractColorCounts) (lines content))

