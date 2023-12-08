from math import gcd
import re
from functools import reduce
from typing import Callable

directions, nodes = open("input.txt").read().split("\n\n")
nodes = {e.group(1): (e.group(2), e.group(3)) for e in [re.match("([A-Z]{3}) = \\(([A-Z]{3}), ([A-Z]{3})\\)", node.strip()) for node in nodes.splitlines()]}
directions = [e for e in directions.strip()]


def first(start: str, dirs: list[str], cond: Callable[[str], bool]):
    curr = start
    steps = 0

    while not cond(curr):
        c_dir = dirs.pop(0)
        dirs.append(c_dir)
        steps += 1
        curr = nodes[curr][0] if c_dir == 'L' else nodes[curr][1]
    return steps


print(f"Part 1: {first('AAA', directions, lambda x: x == 'ZZZ')}")

steps = [first(e, directions, lambda x: x.endswith("Z")) for e in nodes.keys() if e.endswith("A")]

print(f"Part 2: {reduce(lambda num1, num2: abs(num1 * num2) // gcd(num1, num2), steps)}")
