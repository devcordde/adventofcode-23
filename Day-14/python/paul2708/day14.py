from copy import deepcopy

from shared.paul2708.input_reader import *
from shared.paul2708.output import *


def tilt_north(grid):
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "O":

                def find_free_spot():
                    if i == 0:
                        return -1

                    for k in range(i - 1, -1, -1):
                        if grid[k][j] != ".":
                            return -1 if k + 1 == i else k + 1

                    return 0

                if find_free_spot() == -1:
                    continue

                grid[find_free_spot()][j] = "O"
                grid[i][j] = "."


def tilt_south(grid):
    for i in range(len(grid) - 1, -1, -1):
        for j in range(len(grid[0])):
            if grid[i][j] == "O":

                def find_free_spot():
                    if i == len(grid) - 1:
                        return -1

                    for k in range(i + 1, len(grid), 1):
                        if grid[k][j] != ".":
                            return -1 if k - 1 == i else k - 1

                    return len(grid) - 1

                if find_free_spot() == -1:
                    continue

                grid[find_free_spot()][j] = "O"
                grid[i][j] = "."


def tilt_east(grid):
    for i in range(len(grid)):
        for j in range(len(grid[0]) - 1, -1, -1):
            if grid[i][j] == "O":

                def find_free_spot():
                    if j == len(grid[0]) - 1:
                        return -1

                    for k in range(j + 1, len(grid[0]), 1):
                        if grid[i][k] != ".":
                            return -1 if k - 1 == j else k - 1

                    return len(grid[0]) - 1

                if find_free_spot() == -1:
                    continue

                grid[i][find_free_spot()] = "O"
                grid[i][j] = "."


def tilt_west(grid):
    for i in range(len(grid)):
        for j in range(len(grid[0])):
            if grid[i][j] == "O":

                def find_free_spot():
                    if j == 0:
                        return -1

                    for k in range(j - 1, -1, -1):
                        if grid[i][k] != ".":
                            return -1 if k + 1 == j else k + 1

                    return 0

                if find_free_spot() == -1:
                    continue

                grid[i][find_free_spot()] = "O"
                grid[i][j] = "."


def compute_load(g):
    total = 0
    for i in range(len(g)):
        for j in range(len(g[0])):
            if g[i][j] == "O":
                total += (len(g) - i)

    return total


grid = [[c for c in line] for line in read_plain_input(day=14)]

# Part 1
part1_grid = deepcopy(grid)
tilt_north(part1_grid)

write(f"After tilting the rocks to the north, the total load is <{compute_load(part1_grid)}>.")

# Part 2
grids = []
last_grid = None

while grid not in grids:
    grids.append(deepcopy(grid))

    tilt_north(grid)
    tilt_west(grid)
    tilt_south(grid)
    tilt_east(grid)

index = grids.index(grid) + ((1000000000 - grids.index(grid)) % (len(grids) - grids.index(grid)))

write(f"After running 100.00.00.000 iterations, the total load is <{compute_load(grids[index])}>.")
