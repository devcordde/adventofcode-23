from shared.paul2708.output import *
from shared.paul2708.input_reader import *

engine_schematic = list(map(lambda line: [c for c in line], read_plain_input(day=3)))


def is_adjacent_to_symbol(x, y):
    for i in range(-1, 2):
        for j in range(-1, 2):
            pos_x = min(max(x + i, 0), len(engine_schematic[0]) - 1)
            pos_y = min(max(y + j, 0), len(engine_schematic) - 1)

            if engine_schematic[pos_y][pos_x] != "." and not engine_schematic[pos_y][pos_x].isdigit():
                return True

    return False


def find_adjacent_gear(x, y):
    for i in range(-1, 2):
        for j in range(-1, 2):
            pos_x = min(max(x + i, 0), len(engine_schematic[0]) - 1)
            pos_y = min(max(y + j, 0), len(engine_schematic) - 1)

            if engine_schematic[pos_y][pos_x] == "*":
                return True, pos_x, pos_y

    return False, -1, -1


def next_number(line, start_index):
    num = ""
    indices = []

    for i in range(start_index, len(line)):
        if line[i].isdigit():
            num += line[i]
            indices.append(i)

        if not line[i].isdigit() and len(num) != 0:
            return int(num), indices, i + 1

    if len(num) != 0:
        return int(num), indices, len(line)

    return None, [], -1


missing_parts = 0
gears = {}

for i, row in enumerate(engine_schematic):
    next_num, indices, start_index = next_number(row, 0)

    while next_num is not None:
        for index in indices:
            x, y = index, i

            if is_adjacent_to_symbol(x, y):
                missing_parts += next_num
                break

        next_num, indices, start_index = next_number(row, start_index)

write(f"The total sum of the missing parts is <{missing_parts}>.")

for i, row in enumerate(engine_schematic):
    next_num, indices, start_index = next_number(row, 0)

    while next_num is not None:
        for index in indices:
            x, y = index, i
            next_to_gear, gear_x, gear_y = find_adjacent_gear(x, y)

            if next_to_gear:
                if (gear_x, gear_y) in gears:
                    gears[(gear_x, gear_y)].append(next_num)
                else:
                    gears[(gear_x, gear_y)] = [next_num]
                break

        next_num, indices, start_index = next_number(row, start_index)

gears_ratio = sum([gears[loc][0] * gears[loc][1] for loc in gears if len(gears[loc]) == 2])
write(f"The total sum of the gear ratios is <{gears_ratio}>.")
