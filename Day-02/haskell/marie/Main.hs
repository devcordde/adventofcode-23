import Data.Char (isDigit, isLetter)
import Data.List (find)
import Data.Maybe (fromMaybe)

main = do
  input <- getContents
  let games = map game $ lines input
  print $ sum (map gid (filter isPossible games))
  print $ sum (map power games)

data Game = Game
  { gid :: Int,
    cubes :: [CubeReveal]
  }

data CubeReveal = Cubes
  { red :: Int,
    green :: Int,
    blue :: Int
  }

isPossible :: Game -> Bool
isPossible game =
  let (r, g, b) = maxCubes game
   in r <= 12 && g <= 13 && b <= 14

power :: Game -> Int
power game =
  let (r, g, b) = maxCubes game
   in r * g * b

maxCubes :: Game -> (Int, Int, Int)
maxCubes game =
  let c = cubes game
      m color = maximum $ map color c
   in (m red, m green, m blue)

game :: String -> Game
game line =
  let parts = split line ':'
      gameId = head parts
      gid = read $ filter isDigit gameId
      cubes = map parseCube $ split (last parts) ';'
   in Game {gid, cubes}

parseCube :: String -> CubeReveal
parseCube input =
  let elements = split input ','
      findElement :: String -> Int
      findElement color =
        let letters =
              find
                ( \ele ->
                    let eleColor = filter isLetter ele
                     in eleColor == color
                )
                elements
            digits = fmap (read . filter isDigit) letters
         in fromMaybe 0 digits

      red = findElement "red"
      green = findElement "green"
      blue = findElement "blue"
   in (Cubes {red, green, blue})

split :: String -> Char -> [String]
split [] _ = []
split input c =
  let part = takeWhile (/= c) input
   in part : split (drop (length part + 1) input) c
