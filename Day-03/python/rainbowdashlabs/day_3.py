import operator
from dataclasses import dataclass
from functools import reduce
from typing import Tuple

grid = [[x for x in e.strip()] for e in open("input.txt").readlines()]


def is_symbol(sym: str):
    return sym != "." and not sym.isnumeric()


@dataclass
class Number:
    num: int
    xy: list[Tuple[int, int]]

    def has_adjascent(self):
        min_x = min([a[0] for a in self.xy]) - 1
        max_x = max([a[0] for a in self.xy]) + 2
        min_y = min([a[1] for a in self.xy]) - 1
        max_y = max([a[1] for a in self.xy]) + 2
        for x in range(max(0, min_x), min(max_x, len(grid[0]))):
            for y in range(max(0, min_y), min(max_y, len(grid))):
                if is_symbol(grid[y][x]):
                    return True
        return False

    def is_adjascent(self, xy: Tuple[int, int]):
        return any([abs(a[0] - xy[0]) <= 1 for a in self.xy]) and any([abs(a[1] - xy[1]) <= 1 for a in self.xy])


numbers: list[Number] = []
gears = []
for y, line in enumerate(grid):
    nums, xy = [], []
    for x, char in enumerate(line):
        if char == "*":
            gears.append((x, y))
        if char.isnumeric():
            nums.append(char)
            xy.append((x, y))
        else:
            if nums and xy:
                numbers.append(Number(int("".join(nums)), xy))
                nums, xy = [], []
    if nums and xy:
        numbers.append(Number(int("".join(nums)), xy))
        nums, xy = [], []

print(f"Part 1: {sum([x.num for x in numbers if x.has_adjascent()])}")

true_gears = []

for gear in gears:
    matching = [num for num in numbers if num.is_adjascent(gear)]
    if len(matching) == 2:
        true_gears.append((gear, reduce(operator.mul, [num.num for num in matching])))

print(f"Part 2: {sum([x[1] for x in true_gears])}")
