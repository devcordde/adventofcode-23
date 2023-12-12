import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

grid = [[c for c in line] for line in read_plain_input(day=11)]

empty_columns = []
for j in range(len(grid[0])):
    col = []
    for i in range(len(grid)):
        col.append(grid[i][j])

    if col.count(".") == len(col):
        empty_columns.append(j)

galaxies = []
for i in range(len(grid[0])):
    for j in range(len(grid)):
        if grid[j][i] == "#":
            galaxies.append((j, i))


def distance(from_i, from_j, to_i, to_j, additional_steps):
    steps = 0
    i = from_i
    j = from_j

    while not (i == to_i and j == to_j):
        steps += 1

        if i < to_i:
            steps += additional_steps if grid[i].count(".") == len(grid[i]) else 0
            i += 1
        elif i > to_i:
            steps += additional_steps if grid[i].count(".") == len(grid[i]) else 0
            i -= 1
        elif j < to_j:
            steps += additional_steps if j in empty_columns else 0
            j += 1
        elif j > to_j:
            steps += additional_steps if j in empty_columns else 0
            j -= 1

    return steps


def calculate_distances(additional_steps):
    total = 0
    for i, g1 in enumerate(tqdm.tqdm(galaxies)):
        for j, g2 in enumerate(galaxies):
            if i > j:
                total += distance(*g1, *g2, additional_steps)

    return total


write("Start computation...")

part_1 = calculate_distances(1)
part_2 = calculate_distances(999999)

write(f"done. The total sum of all shortest paths is <{part_1}>.")
write(f"Considering the huge expansion, the total sum of all shortest paths is <{part_2}>.")
