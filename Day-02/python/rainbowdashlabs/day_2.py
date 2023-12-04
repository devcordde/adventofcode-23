from pprint import pprint

games = {}
for x in open("input.txt").readlines():
    game, r_sets = x.split(":")
    sets = []
    for y in r_sets.split(";"):
        sets.append({z[1]: int(z[0]) for z in [z.strip().split(" ") for z in y.split(",")]})
    games[int(game.split(" ")[1])] = sets

pprint(games)

bag = {"red": 12, "green": 13, "blue": 14}

powers = []
for game, sets in games.items():
    try:
        for set in sets:
            for k, v in set.items():
                if v > bag[k]:
                    raise ValueError(f"{v}/{bag[k]} {k}")
    except ValueError as e:
        print(e.args[0])
        pass
    else:
        powers.append(game)

print(f"Part 1: {sum(powers)}")

colors = ["green", "red", "blue"]


def power(arr) -> int:
    power = arr[0]
    for num in arr[1:]:
        power *= num
    return power


powers = []
for game, sets in games.items():
    min_cubes = {e: 0 for e in colors}
    for set in sets:
        for k, v in set.items():
            min_cubes[k] = max(min_cubes[k], v)
    powers.append(power(list(min_cubes.values())))

print(f"Part 2: {sum(powers)}")
