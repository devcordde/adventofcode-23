input = ARGF.read.lines.map { |line| line.chomp }

collector = {}
input.each_with_object(collector) do |line, obj|
  line.match(/Game (\d+): /) do |match|
    obj[match[1].to_i] = line.delete_prefix("Game #{match[1]}: ").split(';').map do |game|
      color_collector = {}
      game.split(',').each_with_object(color_collector) do |color, inner_obj|
        split_color = color.split(' ').map { |split| split.strip }
        color_collector[split_color.last] = color_collector.fetch(split_color.last, 0) + split_color.first.to_i
      end
    end
  end
end

def possible_game?(game, limits)
  game.all? do |grab|
    grab.all? do |color, count|
      limits.fetch(color, 0) >= count
    end
  end
end

cube_limits = { 'red' => 12, 'green' => 13, 'blue' => 14 }.freeze
possible_games = collector.select { |id, game| possible_game?(game, cube_limits) }.map { |id, game| id }
puts "Part 1: #{possible_games.sum}"

def calculate_power(game)
  collector = {}
  game.each_with_object(collector) do |grab|
    grab.each do |color, count|
      collector[color] = count unless collector.fetch(color, 0) > count
    end
  end

  collector.values.inject(:*)
end

game_powers = collector.map { |id, game| calculate_power(game) }
puts "Part 2: #{game_powers.sum}"
