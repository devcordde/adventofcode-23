numbers = %{
  "1" => 1,
  "one" => 1,
  "2" => 2,
  "two" => 2,
  "3" => 3,
  "three" => 3,
  "4" => 4,
  "four" => 4,
  "5" => 5,
  "five" => 5,
  "6" => 6,
  "six" => 6,
  "7" => 7,
  "seven" => 7,
  "8" => 8,
  "eight" => 8,
  "9" => 9,
  "nine" => 9
}

IO.read(:stdio, :all)
  |> String.split("\n")
  |> Enum.map(fn line ->
    first_number = numbers
      |> Map.keys
      |> Enum.map(&({numbers[&1], :binary.match(line, &1)}))
      |> Enum.filter(&(is_tuple(elem(&1, 1))))
      |> Enum.min_by(&(elem(elem(&1, 1), 0)), &<=/2, fn -> {0, 0} end)

    rev = String.reverse(line)
    last_number = numbers
      |> Map.keys
      |> Enum.map(&String.reverse/1)
      |> Enum.map(&({numbers[String.reverse(&1)], :binary.match(rev, &1)}))
      |> Enum.filter(&(is_tuple(elem(&1, 1))))
      |> Enum.min_by(&(elem(elem(&1, 1), 0)), &<=/2, fn -> {0, 0} end)

    elem(first_number, 0) * 10 + elem(last_number, 0)
  end)
  |> Enum.sum
  |> IO.puts
