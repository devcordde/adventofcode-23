import itertools


def solve(size):
    counter = 0

    for pair in product:
        x_difference = pair[0][0] - pair[1][0]
        y_difference = pair[0][1] - pair[1][1]
        if x_difference < 0 or (x_difference == 0 and y_difference < 0):
            continue

        counter += abs(x_difference) + abs(y_difference)

        for empty_row in empty_rows:
            if empty_row in range(min(pair[0][1], pair[1][1]), max(pair[0][1], pair[1][1])):
                counter += size

        for empty_column in empty_columns:
            if empty_column in range(pair[1][0], pair[0][0]):
                counter += size

    return int(counter)


lines = open("input.txt").read().split("\n")
not_empty_columns = set()
empty_rows = set()

for y, line in enumerate(lines):
    if line.count("#") == 0:
        empty_rows.add(y)

    not_empty_columns = {*not_empty_columns, *[i for i, char in enumerate(line) if char == "#"]}

empty_columns = set(range(0, len(lines[0]))).difference(not_empty_columns)
galaxies = [(x, y) for (y, line) in enumerate(lines) for (x, char) in enumerate(line) if char == "#"]
product = list(itertools.product(galaxies, galaxies))

print(f"Part 1: {solve(1)}")
print(f"Part 2: {solve(999999)}")
