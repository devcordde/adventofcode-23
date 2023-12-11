from pprint import pprint

import numpy as np

from shared.paul2708.output import *
from shared.paul2708.input_reader import *

grid = [[c for c in line] for line in read_plain_input(day=11, example=1)]

extended_grid = []

for row in grid:
    extended_grid.append(row)

    if row.count(".") == len(row):
        for _ in range(1000000):
            extended_grid.append(["."] * len(row))

copy = list(map(list, extended_grid))

ins = 0
for j in range(len(grid[0])):
    col = []
    for i in range(len(grid)):
        col.append(grid[i][j])

    if col.count(".") == len(col):
        for row in copy:
            for _ in range(1000000):
                row.insert(j + ins, ".")

        ins += 1

extended_grid = copy


def distance(from_i, from_j, to_i, to_j):
    steps = 0
    i = from_i
    j = from_j

    while not (i == to_i and j == to_j):
        steps += 1
        if i < to_i:
            i += 1
        elif i > to_i:
            i -= 1
        elif j < to_j:
            j += 1
        elif j > to_j:
            j -= 1

    return steps if steps == 0 else steps


galaxies = []
for i in range(len(extended_grid[0])):
    for j in range(len(extended_grid)):
        if extended_grid[j][i] == "#":
            galaxies.append((j, i))

total = 0
for g1 in galaxies:
    for g2 in galaxies:
        if g1 == g2:
            continue

        total += distance(*g1, *g2)

write_2d_array(copy)
print(galaxies)
print(distance(0, 3, 10, 7))
print(distance(2, 0, 7, 9))
print(distance(11, 0, 11, 4))

print(total / 2)
