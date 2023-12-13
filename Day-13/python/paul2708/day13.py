import numpy as np

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

lines = read_plain_input(day=13)
grids = []
grid = []
for line in lines:
    if line == "":
        grids.append(grid)
        grid = []
    else:
        grid.append([c for c in line])

grids.append(grid)


def find_vertical_reflection(grid, skip=None):
    for i in range(1, len(grid)):
        if i != skip and check_palindrom(grid[:i], grid[i:]):
            return i

    return 0


def find_horizontal_reflection(grid, skip=None):
    return find_vertical_reflection(np.transpose(np.array(grid)).tolist(), skip)


def check_palindrom(first, second):
    if len(first) == 0 or len(second) == 0:
        return True

    if first[-1] != second[0]:
        return False

    return check_palindrom(first[:-1], second[1:])


total = 0
perturbed_total = 0
for grid in grids:
    # Part 1
    original_vertical = find_vertical_reflection(grid)
    original_horizontal = find_horizontal_reflection(grid)

    total += 100 * original_vertical + original_horizontal

    # Part 2
    perturbed_vertical = 0
    perturbed_horizontal = 0

    for i, j in [(x, y) for x in range(len(grid)) for y in range(len(grid[0]))]:
        perturbed_grid = [row[:] for row in grid]
        perturbed_grid[i][j] = "#" if grid[i][j] == "." else "."

        found = find_vertical_reflection(perturbed_grid, skip=original_vertical)
        if found != 0:
            perturbed_vertical = found
            break

        found = find_horizontal_reflection(perturbed_grid, skip=original_horizontal)
        if found != 0:
            perturbed_horizontal = found
            break

    perturbed_total += 100 * perturbed_vertical + perturbed_horizontal

write(f"Summing up the columns and rows to the reflection line results in <{total}>.")
write(f"After identifying the smudges, the columns and rows sum up to <{perturbed_total}>.")
