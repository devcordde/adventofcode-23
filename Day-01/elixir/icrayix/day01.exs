lines =
  String.split(File.read!("input.txt"), "\n", trim: true)

# part 1
Enum.map(lines, fn line ->
  # 57 is the unicode codepoint for '9'
  line = String.to_charlist(line) |> Enum.filter(fn char -> char <= 57 end)

  (Enum.take(line, 1) ++ Enum.take(line, -1))
  |> List.to_integer()
end)
|> Enum.sum()
|> IO.puts()

# part 2
defmodule Part2 do
  def parse_nums(""), do: []
  def parse_nums(<<c>> <> rest) when c <= 57, do: [c - ?0, parse_nums(rest)]

  digits =
    Enum.with_index(
      [
        "one",
        "two",
        "three",
        "four",
        "five",
        "six",
        "seven",
        "eight",
        "nine"
      ],
      1
    )

  for {digit, index} <- digits do
    def parse_nums(<<unquote(digit)>> <> _ = all) do
      <<_>> <> rest = all
      [unquote(index), parse_nums(rest)]
    end
  end

  def parse_nums(<<_>> <> rest), do: [parse_nums(rest)]
end

Enum.map(lines, fn line ->
  line = Part2.parse_nums(line) |> List.flatten()

  Enum.at(line, 0) * 10 + Enum.at(line, -1)
end)
|> Enum.sum()
|> IO.puts()
