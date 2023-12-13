import itertools
import math
from pprint import pprint

import numpy as np
import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *

lines = read_plain_input(day=13, example=None)
grids = []
grid = []
for line in lines:
    if line == "":
        grids.append(grid)
        grid = []
    else:
        grid.append([c for c in line])

grids.append(grid)


def find_vertical_reflection(grid):
    for i in range(1, len(grid)):

        if check_palindrom(grid[:i], grid[i:]):
            return i

    return 0


def check_palindrom(first, second):
    if len(first) == 0 or len(second) == 0:
        return True

    if first[-1] != second[0]:
        return False

    return check_palindrom(first[:-1], second[1:])


total_vertical = 0
total_horizintal = 0
for grid in grids:
    total_vertical += find_vertical_reflection(grid)
    total_horizintal += find_vertical_reflection(np.transpose(np.array(grid)).tolist())

print(total_vertical * 100 + total_horizintal)
