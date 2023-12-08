import numpy as np

from shared.paul2708.output import *
from shared.paul2708.input_reader import *

lines = read_plain_input(day=8)

# Parse input
instructions = lines[0]

nodes = {}
for i in range(2, len(lines)):
    line = lines[i]
    nodes[line.split(" ")[0]] = line.split(" ")[2].replace("(", "").replace(",", ""), \
                                line.split(" ")[3].replace(")", "")

# Part 1
steps = 0
node = "AAA"

while node != "ZZZ":
    instruction = instructions[steps % len(instructions)]
    node = nodes[node][0 if instruction == "L" else 1]

    steps += 1

write(f"Starting at 'AAA', it takes <{steps}> steps to get to 'ZZZ'.")

# Part 2
start_nodes = [node for node in nodes if node.endswith("A")]
start_steps = []

for node in start_nodes:
    steps = 0

    while not node.endswith("Z"):
        instruction = instructions[steps % len(instructions)]
        node = nodes[node][0 if instruction == "L" else 1]

        steps += 1

    start_steps.append(steps)

least_common_steps = np.lcm.reduce(np.array(start_steps, dtype='int64'))
write(f"Starting with '{', '.join(start_nodes)}', it takes <{least_common_steps}> steps to end in trailing Z nodes.")
