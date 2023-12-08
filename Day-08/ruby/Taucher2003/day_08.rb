input = ARGF.read.lines.map(&:chomp).reject(&:empty?)

instructions = input.first.split('')
nodes = input.drop(1).map do |node|
  id, connections = node.split(' = ')

  connections = connections.delete_prefix('(').delete_suffix(')').split(',').map(&:strip)
  [id, { 'L' => connections.first, 'R' => connections.last }]
end.to_h

def count_steps(instructions, nodes, start_node: 'AAA', end_node_pred: ->(node) { node == 'ZZZ' })
  current_node = start_node
  step = 0

  until end_node_pred.call(current_node) do
    current_node = nodes[current_node][instructions[step % instructions.length]]
    step += 1
  end

  step
end

def count_ghost_steps(instructions, nodes)
  start_nodes = nodes.select { |node, _| node.end_with?('A') }

  first_end_reached_counts = start_nodes.map { |node, _| count_steps(instructions, nodes, start_node: node, end_node_pred: ->(node) { node.end_with?('Z') }) }

  first_end_reached_counts.inject(1, :lcm)
end

puts "Part 1: #{count_steps(instructions, nodes)}"
puts "Part 2: #{count_ghost_steps(instructions, nodes)}"
