from operator import mul
from functools import reduce

games = {}
for x in open("input.txt").readlines():
    game, r_sets = x.split(":")
    sets = []
    for y in r_sets.split(";"):
        sets.append({z[1]: int(z[0]) for z in [z.strip().split(" ") for z in y.split(",")]})
    games[int(game.split(" ")[1])] = sets

bag = {"red": 12, "green": 13, "blue": 14}

powers = []
for game, sets in games.items():
    try:
        for set in sets:
            for color, count in set.items():
                if count > bag[color]:
                    raise ValueError(f"{count}/{bag[color]} {color}")
    except ValueError as e:
        pass
    else:
        powers.append(game)

print(f"Part 1: {sum(powers)}")

powers = []
for game, sets in games.items():
    min_cubes = {e: 0 for e in ["green", "red", "blue"]}
    for set in sets:
        for color, count in set.items():
            min_cubes[color] = max(min_cubes[color], count)
    powers.append(reduce(mul, min_cubes.values()))

print(f"Part 2: {sum(powers)}")
