import Data.Bifunctor qualified
import Data.Char (isDigit, isSpace)
import Data.Map qualified as Map

main = do
  input <- getContents
  let digits = filter (isDigit . fst) $ zip strippedInput [0 ..]
      strippedInput = filter (not . isSpace) input
      numbers = zip digits $ tail digits ++ [last digits]
      numNeighbourPairs = splitWhen (\(a, b) -> 1 < abs (snd a - snd b)) numbers
      numChars = map (map fst) numNeighbourPairs
      nums :: [(Int, (Int, Int))]
      nums =
        map
          ( \x ->
              let value = read $ map fst x
                  coords = map snd x
               in (value, (head coords, last coords))
          )
          numChars
      partNums = filter (any (hasSymbolNeighbour input)) nums
  print $ sum $ map fst partNums

  let isGear (c, _) = c == '*'
      gears =
        foldl
          ( \acc (index, value) ->
              foldl
                ( \acc (_, key) ->
                    let list = Map.lookup key acc
                        newList = maybe [index] (++ [index]) list
                     in Map.insert key newList acc
                )
                acc
                value
          )
          Map.empty
          $ map (Data.Bifunctor.second (filter (\(c, _) -> c == '*') . neighbours input)) partNums

  print $ sum $ Map.map product $ Map.filter (\x -> length x == 2) gears

splitWhen :: (a -> Bool) -> [a] -> [[a]]
splitWhen predicate xs = f xs []
  where
    f [] agg = [agg]
    f (y : ys) agg =
      if predicate y
        then (agg ++ [y]) : f ys []
        else f ys (agg ++ [y])

neighbourCoords :: Int -> (Int, Int) -> [Int]
neighbourCoords len (start, end) =
  let startCoords =
        map
          (+ start)
          [ -1,
            -len - 1,
            len - 1
          ]
      endCoords =
        map
          (+ end)
          [ 1,
            -len + 1,
            len + 1
          ]
      verticalCoords = concatMap (\x -> [x + len, x - len]) [start .. end]
   in filter (>= 0) (startCoords ++ endCoords ++ verticalCoords)

neighbours :: String -> (Int, Int) -> [(Char, Int)]
neighbours input pos =
  let len = length $ head (lines input)
      strippedInput = filter (not . isSpace) input
      coords = filter (< length strippedInput) $ neighbourCoords len pos
   in map (\x -> (strippedInput !! x, x)) coords

hasSymbolNeighbour :: String -> (Int, Int) -> Bool
hasSymbolNeighbour input pos = any (\(x, _) -> not (isDigit x || x == '.')) $ neighbours input pos
