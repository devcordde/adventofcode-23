def partial_product(l, size, tuple=()):
    if size == 0:
        return [tuple]

    b = []
    for i, a in enumerate(l[:len(l) - size + 1]):
        for c in partial_product(l[i + 1:], size - 1, (*tuple, a)):
            b.append([*c])

    return b


def solve(x):
    combinations = partial_product(x[3], x[2])
    counter = 0

    for combination in combinations:
        for index in x[3]:
            if index in combination:
                x[0] = x[0][0:index] + "#" + x[0][index + 1:]
            else:
                x[0] = x[0][0:index] + "." + x[0][index + 1:]

        valid = True
        for i, chain in enumerate(filter(lambda y: len(y) > 0, x[0].split("."))):
            if len(chain) != x[1][i]:
                valid = False
                break

        if valid:
            counter += 1

    return counter


input = list(map(lambda x: [*x, sum(x[1]) - len([char for char in x[0] if char == "#"]), [i for i, char in enumerate(x[0]) if char == "?"]], map(lambda line: [line[0], list(map(lambda number: int(number), line[1].split(",")))], map(lambda line: line.split(), open("input12.txt").read().split("\n")))))
print(sum(map(solve, input)))
