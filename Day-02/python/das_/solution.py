import functools
import re

id_count = 0
powers = 0

for g in open("input.txt"):
    draws = re.split("; ?|: ", g)
    colors = {"red": 0, "green": 0, "blue": 0}

    for draw in draws:
        for color in colors.keys():
            if draw.count(color) > 0:
                number = int(re.search("(\\d+) " + color, draw).group(1))
                colors[color] = max(colors[color], number)

    # Part 1
    if colors["red"] <= 12 and colors["green"] <= 13 and colors["blue"] <= 14:
        id_count += int(re.match("Game (\\d+)", g).group(1))

    # Part 2
    powers += functools.reduce(lambda x, y: x * y, colors.values())

print(f"Part 1: {id_count}")
print(f"Part 2: {powers}")
