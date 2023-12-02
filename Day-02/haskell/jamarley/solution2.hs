
import Data.List.Split (splitOn)
import Data.List (dropWhileEnd)

countColorMin :: (Integer, Integer, Integer) -> [(Integer, String)] -> Integer
countColorMin (x,y,z) [] = x * y * z 
countColorMin (m1,m2,m3) (x:xs) = case snd x of
        "red" -> if fst x > m1 then countColorMin (fst x, m2, m3) xs else countColorMin (m1, m2, m3) xs 
        "green" -> if fst x > m2 then countColorMin (m1, fst x, m3) xs else countColorMin (m1, m2, m3) xs 
        "blue" -> if fst x > m3 then countColorMin (m1, m2, fst x) xs else countColorMin (m1, m2, m3) xs 
        _ -> undefined

extractColorCounts :: String -> [(Integer, String)]
extractColorCounts = extractColor . map (dropWhileEnd (== ',') . dropWhileEnd (== ';')) . words . drop 2 . dropWhile (/= ':')

extractColor :: [String] -> [(Integer, String)]
extractColor (x:y:xs) = (read x, y) : extractColor xs
extractColor _ = []

main :: IO ()
main = do
        content <- readFile "input"
        print (sum $ map (countColorMin (0,0,0) . extractColorCounts) (lines content))

