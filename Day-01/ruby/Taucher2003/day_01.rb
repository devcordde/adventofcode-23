input = ARGF.read.lines.map { |line| line.chomp }

def first_and_last_num(str)
  numbers = str.chars.map { |char| Integer(char, exception: false) }.compact
  "#{numbers.first}#{numbers.last}".to_i
end

puts "Part 1: #{input.map(&method(:first_and_last_num)).sum}"

letter_nums = %w[one two three four five six seven eight nine].map
  .with_index(1) { |num, index| [num, "#{num}#{index}#{num}"] }
  .to_h

input_with_numbers = letter_nums.each_with_object(input.dup) do |nums, strs|
  strs.map! { |str| str.gsub(nums.first, nums.last.to_s) }
end

input_with_numbers_map = input_with_numbers.map(&method(:first_and_last_num))

puts "Part 2: #{input_with_numbers_map.sum}"
