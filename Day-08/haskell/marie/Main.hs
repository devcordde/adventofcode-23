import Data.Bifunctor (bimap)
import Data.Char (isAlphaNum)
import Data.Map (Map, empty, insert, keys)
import Data.Map qualified as Map
import Data.Maybe (fromJust)

main = do
  input <- getContents
  let directions = cycle $ map direction $ head $ lines input
      nodes = parseNodes $ drop 2 $ lines input
  print $ takeDirectionWith (== "ZZZ") "AAA" directions nodes
  let startNodes = filter (\x -> last x == 'A') $ keys nodes
      times = map (\x -> takeDirectionWith (\c -> last c == 'Z') x directions nodes) startNodes
  print $ foldr lcm 1 times

direction 'R' = snd
direction 'L' = fst

type Direction = (String, String) -> String

takeDirectionWith :: (String -> Bool) -> String -> [Direction] -> NodeMap -> Int
takeDirectionWith goal current directions nodes =
  if goal current
    then 0
    else
      let next = head directions (fromJust $ Map.lookup current nodes)
       in 1 + takeDirectionWith goal next (tail directions) nodes

type NodeMap = Map String (String, String)

parseNodes :: [String] -> NodeMap
parseNodes = foldl f empty
  where
    f :: NodeMap -> String -> NodeMap
    f acc line =
      let (k, v) = splitAt 4 line
          filterLetters = filter isAlphaNum
          key = filterLetters k
          value = bimap filterLetters filterLetters (splitAt 6 v)
       in insert key value acc
