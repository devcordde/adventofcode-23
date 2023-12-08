import functools
import math
import re

def solve(current_nodes):
    final_step_counts = []
    i = -1
    step_count = 0

    while len(current_nodes) != 0:
        step_count, i = step_count + 1, i + 1
        current_nodes = [nodes[node][0 if sequence[i % len(sequence)] == "L" else 1] for node in current_nodes]

        for node in current_nodes:
            if node.endswith("Z"):
                final_step_counts.append(step_count)
                current_nodes.remove(node)

    return final_step_counts


lines = open("input8.txt").read().split("\n")
sequence = lines.pop(0)
nodes = functools.reduce(lambda x, y: {**x, **y},[{match.group(1): (match.group(2), match.group(3))} for node in lines[1:] if (match := re.search(r"(\w{3}) = \((\w{3}), (\w{3})\)", node))])

print(f"Part 1: {solve(['AAA'])[0]}")
print(f"Part 2: {math.lcm(*solve([node for node in nodes.keys() if node.endswith('A')]))}")
