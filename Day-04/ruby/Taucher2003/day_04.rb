input = ARGF.read.lines.map { |line| line.chomp.gsub(/Card \d+:/, '').strip }

numbers = input.map do |line|
  parts = line.split(' | ')
  parts.map do |part|
    part.split(' ').map { |num| Integer(num.strip, exception: false) }
  end
end

card_values = numbers.map do |card|
  winning_numbers, having_numbers = card
  matching_numbers = winning_numbers & having_numbers
  next 0 if matching_numbers.empty?

  2 ** (matching_numbers.length - 1)
end

puts "Part 1: #{card_values.sum}"

card_copies = numbers.each_with_object(numbers.map.with_index { |num, index| [index, 1] }.to_h).with_index do |(card, collector), index|
  winning_numbers, having_numbers = card
  matching_number_amount = (winning_numbers & having_numbers).length

  ((index + 1)..(index + matching_number_amount)).each do |i|
    collector[i] = collector.fetch(i, 0) + collector.fetch(index, 1)
  end
end

puts "Part 2: #{card_copies.values.sum}"
