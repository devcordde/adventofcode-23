input = ARGF.read.lines.map { |line| line.chomp }.join("\n").split("\n\n")

seeds = input.first.delete_prefix('seeds: ').split(' ').map(&:to_i)
maps = input.last(input.length - 1).map do |section|
  section.lines.drop(1).each_with_object({}) do |line, collector|
    numbers = line.split(' ').map(&:to_i)
    collector[numbers[1]..(numbers[1] + numbers[2] - 1)] = numbers[0]
  end
end

def locations(maps, seeds)
  maps.reduce(seeds) do |acc, cur|
    acc.map do |value|
      range = cur.detect { |(r, _)| r.include?(value) }
      next value if range.nil?

      range.last + (value - range.first.first)
    end
  end
end

puts "Part 1: #{locations(maps, seeds).min}"

#minimum_location = seeds.each_slice(2).map.with_index do |slice, index|
#  puts "Calculating slice #{index}"
#  locations(maps, (slice[0]..(slice[0] + slice[1] - 1)).to_a).min
#end.min

#puts "Part 2: #{minimum_location}"
