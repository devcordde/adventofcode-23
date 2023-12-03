defmodule ColorStruct do
  defstruct red: 0, green: 0, blue: 0

  def fetch(me, key) do
    {:ok, Map.get(me, key)}
  end
end

defmodule ColorGame do
  defstruct [:id, :bags]
end


defmodule Day2 do
  @test_bag %ColorStruct{red: 12, green: 13, blue: 14}
  @id_parser ~r/^Game (?<id>\d+)$/iu
  @bag_parser ~r/(?<num1>\d+) (?<color1>\w+)(?:\s*,\s*(?<num2>\d+) (?<color2>\w+)(?:\s*,\s*(?<num3>\d+) (?<color3>\w+))?)?/iu

  @file_name "input.txt"

  def part1() do
    readfile(@file_name)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_gamestr/1)
    |> Enum.filter(&is_possible/1)
    |> Enum.reduce(0, fn next, prev -> next.id + prev end)
    |> IO.puts()
  end

  def part2() do
    readfile(@file_name)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse_gamestr/1)
    |> Enum.map(&calculate_power/1)
    |> Enum.reduce(0, fn next, prev -> next + prev end)
    |> IO.puts()
  end

  @spec parse_gamestr(String.t()) :: ColorGame.t()
  def parse_gamestr(line) do
    [header, rounds] = String.split(line, ":") |> Enum.map(&String.trim/1)
    {id, _} = Integer.parse(Regex.named_captures(@id_parser, header)["id"])
    bags = String.split(rounds, ";") |> Enum.map(&String.trim/1) |> Enum.map(&parse_round/1)

    %ColorGame{id: id, bags: bags}
  end

  @spec parse_round(String.t()) :: ColorStruct.t()
  def parse_round(str) do
    cg = Regex.named_captures(@bag_parser, str)

    bag =
      %ColorStruct{}
      |> set_bag_color(cg["color1"], cg["num1"])
      |> set_bag_color(cg["color2"], cg["num2"])
      |> set_bag_color(cg["color3"], cg["num3"])

    bag
  end

  @spec set_bag_color(ColorStruct.t(), String.t(), String.t()) :: ColorStruct.t()
  def set_bag_color(bag, key_str, val_str) do
    if key_str == "" do
      bag
    else
      key = String.to_existing_atom(key_str)
      {val, _} = Integer.parse(val_str)

      put_in(bag, [Access.key!(key)], val)
    end
  end

  @spec is_possible(ColorGame.t()) :: boolean()
  def is_possible(game) do
    max_bag = %ColorStruct{
      red: max_key(game.bags, :red),
      green: max_key(game.bags, :green),
      blue: max_key(game.bags, :blue)
    }

    max_bag.red <= @test_bag.red &&
      max_bag.green <= @test_bag.green &&
      max_bag.blue <= @test_bag.blue
  end

  @spec max_key([ColorStruct.t()], atom()) :: integer()
  def max_key(bags, color) do
    mb = bags |> Enum.max_by(fn bag -> bag[color] end)
    mb[color]
  end

  @spec calculate_power(ColorGame.t()) :: integer()
  def calculate_power(game) do
    max_bag = %ColorStruct{
      red: max_key(game.bags, :red),
      green: max_key(game.bags, :green),
      blue: max_key(game.bags, :blue)
    }

    max_bag.red * max_bag.green * max_bag.blue
  end

  defp readfile(filename) do
    File.stream!(filename)
  end
end

Day2.part1()
Day2.part2()
