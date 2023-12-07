input_lines = ARGF.read.lines
input = input_lines.map do |line|
  line.split(' ').drop(1).map(&:to_i)
end

races = input[0].zip(input[1])

def travel_distance(hold_time, max_time)
  (max_time - hold_time) * hold_time
end

def win_options(race)
  (0..race[0]).map { |hold_time| travel_distance hold_time, race[0] }
              .count { |distance| distance > race[1] }
end

puts "Part 1: #{races.map(&method(:win_options)).inject(:*)}"

race = input_lines.map do |line|
  line.split(' ', 2).last.gsub(' ', '').to_i
end

puts "Part 2: #{win_options race}"
