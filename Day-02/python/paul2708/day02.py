from shared.paul2708.output import *
from shared.paul2708.input_reader import *

lines = read_plain_input(day=2)


def parse_line(line: str):
    line = line.replace(":", "")
    game_id = int(line.split(" ")[1])
    sets = line.replace(f"Game {game_id}", "").split(";")

    set_colors = []

    for single_set in sets:
        r, g, b = 0, 0, 0
        for color in single_set.split(","):
            color = color.strip()

            if "blue" in color:
                b = int(color.split(" ")[0])
            elif "red" in color:
                r = int(color.split(" ")[0])
            elif "green" in color:
                g = int(color.split(" ")[0])

        set_colors.append((r, g, b))

    return game_id, set_colors


games = [parse_line(line) for line in lines]

id_sum = 0
power = 0

for game_id, sets in games:
    valid = True
    min_r, min_g, min_b = 0, 0, 0

    for single_set in sets:
        min_r = max(min_r, single_set[0])
        min_g = max(min_g, single_set[1])
        min_b = max(min_b, single_set[2])

        if not (single_set[0] <= 12 and single_set[1] <= 13 and single_set[2] <= 14):
            valid = False

    if valid:
        id_sum += game_id

    power += min_r * min_g * min_b

write(f"The sum of possible game ids is <{id_sum}>.")
write(f"The sum of the power is <{power}>.")
