games = String.split(File.read!("input.txt"), "\n", trim: true)

limits = %{"red" => 12, "green" => 13, "blue" => 14}

defmodule Day02 do
  def max_colors(bag) do
    Enum.map(bag, &String.split(&1, ",", trim: true))
    |> List.flatten()
    |> Enum.map(&String.split/1)
    |> Enum.reduce(Map.new(), fn [amount, color], acc ->
      if Map.get(acc, color, 0) < String.to_integer(amount) do
        Map.put(acc, color, String.to_integer(amount))
      else
        acc
      end
    end)
  end
end

# part 1
Enum.map(games, fn game ->
  ["Game " <> id | sets] = String.split(game, [":", ";"])

  max = Day02.max_colors(sets)

  if Enum.map(limits, fn {color, limit} -> Map.get(max, color) <= limit end)
     |> Enum.all?() do
    String.to_integer(id)
  else
    0
  end
end)
|> Enum.sum()
|> IO.puts()

# part 2
Enum.map(games, fn game ->
  ["Game " <> _id | sets] = String.split(game, [":", ";"])

  Day02.max_colors(sets) |> Enum.reduce(1, fn {_, amount}, acc -> acc * amount end)
end)
|> Enum.sum()
|> IO.puts()
