import operator
from collections import namedtuple
from dataclasses import dataclass
from functools import reduce

Coord = namedtuple("Coord", ["x", "y"])
grid = [[x for x in e.strip()] for e in open("input.txt").readlines()]


@dataclass
class Number:
    num: int
    xy: list[Coord]

    def has_adjascent(self):
        _x = [e.x for e in self.xy]
        _y = [e.y for e in self.xy]
        for x in range(max(0, min(_x) - 1), min(max(_x) + 2, len(grid[0]))):
            for y in range(max(0, min(_y) - 1), min(max(_y) + 2, len(grid))):
                if grid[y][x] != "." and not grid[y][x].isnumeric():
                    return True
        return False

    def is_adjascent(self, coord: Coord):
        return any([abs(a.x - coord.x) <= 1 for a in self.xy]) and any([abs(a.y - coord.y) <= 1 for a in self.xy])


numbers: list[Number] = []
gears: list[Coord] = []
for y, line in enumerate(grid):
    nums, xy = [], []
    for x, char in enumerate(line):
        if char == "*":
            gears.append(Coord(x, y))
        if char.isnumeric():
            nums.append(char)
            xy.append(Coord(x, y))
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
        true_gears.append(reduce(operator.mul, [num.num for num in matching]))

print(f"Part 2: {sum(true_gears)}")
