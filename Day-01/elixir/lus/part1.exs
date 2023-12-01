IO.read(:stdio, :all)
  |> String.split("\n")
  |> Enum.map(&to_charlist/1)
  |> Enum.map(fn chars ->
    chars
      |> Enum.map(&(&1 - ?0))
      |> Enum.filter(&(&1 >= 0 && &1 <= 9))
  end)
  |> Enum.map(&(List.first(&1, 0) * 10 + List.last(&1, 0)))
  |> Enum.sum
  |> IO.puts
