import re

lines = open("input.txt").read().split("\n")

for y, element in enumerate(lines):
    if element.count("S") == 1:
        x = element.index("S")
        break

current_positions = []
if lines[y][x + 1] in ["-", "7", "J"]:
    current_positions.append(((x + 1, y), (x, y)))
if lines[y][x - 1] in ["-", "L", "F"]:
    current_positions.append(((x - 1, y), (x, y)))
if lines[y + 1][x] in ["|", "L", "J"]:
    current_positions.append(((x, y + 1), (x, y)))
if lines[y - 1][x] in ["|", "7", "F"]:
    current_positions.append(((x, y - 1), (x, y)))

tiles = {(x, y), current_positions[0][0], current_positions[1][0]}
mapping = {"-": [(1, 0), (-1, 0)], "|": [(0, 1), (0, -1)], "7": [(0, 1), (-1, 0)], "L": [(0, -1), (1, 0)], "F": [(1, 0), (0, 1)], "J": [(0, -1), (-1, 0)]}
counter = 1

while current_positions[0][0] != current_positions[1][0]:
    counter += 1
    for i, step in enumerate(current_positions):
        position = step[0]
        letter = lines[position[1]][position[0]]
        next_position = next(filter(lambda f: step[1] != f, map(lambda z: (position[0] + z[0], position[1] + z[1]), mapping[letter])))
        current_positions[i] = (next_position, position)
        tiles.add(next_position)

sorted_tiles = sorted(list(tiles), key=lambda x: (x[1], x[0]))
area = 0

for y in range(sorted_tiles[0][1], sorted_tiles[-1][1]):
    inside = False
    for x in range(min(filter(lambda z: z[1] == y, sorted_tiles), key=lambda z: z[0])[0], max(filter(lambda z: z[1] == y, sorted_tiles), key=lambda z: z[0])[0]):
        if (x, y) in tiles:
            if lines[y][x] == "-":
                continue

            if not re.match(r"^(L-*7)|(F-*J)", lines[y][x:]):
                inside = not inside

        elif inside:
            area += 1

print(f"Part 1: {counter}")
print(f"Part 2: {area}")
