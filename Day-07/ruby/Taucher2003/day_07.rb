input = ARGF.read.lines.map do |line|
  values = line.split(' ')
  [values.first, values.last.to_i]
end

def card_priorities(enable_joker)
  return %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze if enable_joker

  %w[A K Q J T 9 8 7 6 5 4 3 2 J].freeze
end

def card_types(enable_joker)
  {
    five_of_kind: ->(card_counts) { card_counts.length == 1 || (enable_joker && card_counts.length == 2 && card_counts.key?('J')) },
    four_of_kind: ->(card_counts) { card_counts.any? { |c, count| count == 4 || (enable_joker && c != 'J' && count + card_counts.fetch('J', 0) >= 4) } },
    full_house: ->(card_counts) { card_counts.length == 2 || (enable_joker && card_counts.length == 3 && card_counts.key?('J')) },
    three_of_kind: ->(card_counts) { card_counts.any? { |c, count| count == 3 || (enable_joker && c != 'J' && count + card_counts.fetch('J', 0) >= 3) } },
    two_pair: ->(card_counts) { card_counts.length == 3 || (enable_joker && card_counts.length == 4 && card_counts.key?('J')) },
    one_pair: ->(card_counts) { card_counts.length == 4 || (enable_joker && card_counts.length == 5 && card_counts.key?('J')) },
    high: ->(_) { true }
  }.freeze
end

def classify_hands(hand, card_types)
  card_counts = hand.first.chars.tally
  type = card_types.detect { |type| type[1].call(card_counts) }.first

  [hand, type]
end

def sort_hands(first, second, card_types, card_priorities)
  first_index, second_index = [first, second].map do |hand_type|
    card_types.find_index { |k, _| k == hand_type.last }
  end

  if first_index == second_index
    first[0][0].chars.map.with_index do |c, index|
      c2 = second[0][0].chars[index]
      next if c == c2

      first_index = card_priorities.index(c)
      second_index = card_priorities.index(c2)
      break
    end
  end

  second_index <=> first_index
end

def calculate_winnings(input, enable_joker)
  input.map { |hand| classify_hands(hand, card_types(enable_joker)) }
       .to_h
       .sort { |a, b| sort_hands(a, b, card_types(enable_joker), card_priorities(enable_joker)) }
       .map.with_index { |hand, rank| hand[0][1] * (rank + 1) }
end

puts "Part 1: #{calculate_winnings(input, false).sum}"
puts "Part 2: #{calculate_winnings(input, true).sum}"
