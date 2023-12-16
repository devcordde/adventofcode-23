def energized_beam_count(start_position):
    beams = [start_position]
    past_beams = set()
    while len(beams) > 0:
        current_beam = beams.pop(0)
        if current_beam in past_beams:
            continue

        ((x, y), direction) = current_beam
        if x < 0 or y < 0 or x > len(lines[0]) - 1 or y > len(lines) - 1:
            continue

        current_tile = lines[y][x]

        match current_tile:
            case "\\":
                new_direction = backslash_map[direction]
                beams.append(((directions[new_direction][0] + x, directions[new_direction][1] + y), new_direction))
            case "/":
                new_direction = slash_map[direction]
                beams.append(((directions[new_direction][0] + x, directions[new_direction][1] + y), new_direction))
            case "-":
                if direction == "W" or direction == "E":
                    beams.append(((directions[direction][0] + x, directions[direction][1] + y), direction))
                else:
                    beams.append(((directions["W"][0] + x, directions["W"][1] + y), "W"))
                    beams.append(((directions["E"][0] + x, directions["E"][1] + y), "E"))
            case "|":
                if direction == "N" or direction == "S":
                    beams.append(((directions[direction][0] + x, directions[direction][1] + y), direction))
                else:
                    beams.append(((directions["N"][0] + x, directions["N"][1] + y), "N"))
                    beams.append(((directions["S"][0] + x, directions["S"][1] + y), "S"))
            case ".":
                beams.append(((directions[direction][0] + x, directions[direction][1] + y), direction))

        past_beams.add(current_beam)

    return len(set(map(lambda beam: beam[0], past_beams)))


lines = open("input16.txt").read().split("\n")
directions = {"N": (0, -1), "S": (0, 1), "W": (-1, 0), "E": (1, 0)}
backslash_map = {"N": "W", "S": "E", "E": "S", "W": "N"}
slash_map = {"N": "E", "S": "W", "E": "N", "W": "S"}

energized_beam_counts = []
for x in range(len(lines[0])):
    energized_beam_counts.append(energized_beam_count(((x, len(lines) - 1), "N")))
    energized_beam_counts.append(energized_beam_count(((x, 0), "S")))

for y in range(len(lines)):
    energized_beam_counts.append(energized_beam_count(((0, y), "E")))
    energized_beam_counts.append(energized_beam_count(((len(lines[0]) - 1, y), "W")))

print(f"Part 1: {energized_beam_count(((0, 0), 'E'))}")
print(f"Part 2: {max(energized_beam_counts)}")
