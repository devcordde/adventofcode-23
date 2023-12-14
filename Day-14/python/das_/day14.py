import copy


def shift(input, direction):
    result = []

    for i in range(len(input[0])):
        if direction == 0 or direction == 2:
            row = "".join(map(lambda x: x[i], input))

        if direction == 3 or direction == 1:
            row = input[i]

        if direction == 2 or direction == 3:
            row = "".join(reversed(row))

        stone_indexes = [-1, *[k for k, char in enumerate(row) if char == "#"], len(row)]

        for j in range(len(stone_indexes) - 1):
            part = row[stone_indexes[j] + 1:stone_indexes[j + 1]]
            count = part.count("O")
            if count > 0:
                row = row[:stone_indexes[j] + 1] + (count * "O" + (len(part) - count) * ".") + row[stone_indexes[j + 1]:]

        if direction == 2 or direction == 3:
            row = "".join(reversed(row))

        result.append(row)

    if direction == 0 or direction == 2:
        new_result = []
        for i, row in enumerate(result):
            new_result.append("".join(map(lambda x: x[i], result)))

        result = new_result

    return result


input = open("input.txt").read().split("\n")
original_input = copy.deepcopy(input)
result = input
previous_results = []
found = False

for y in range(1_000_000_000):
    for z in range(4):
        result = shift(result, z)

        if z == 0:
            for previous_result in previous_results:
                if previous_result[0] == result:
                    cycle_start = previous_result[1]
                    found = True
                    break

            previous_results.append((result, y))

    if found:
        break

for y in range(((1_000_000_000 - cycle_start) % (y - cycle_start)) - 1):
    for i in range(4):
        result = shift(result, i)

value = lambda x: sum([(len(result) - i) * line.count('O') for i, line in enumerate(x)])
print(f"Part 1: {value(shift(original_input, 0))}")
print(f"Part 2: {value(result)}")
