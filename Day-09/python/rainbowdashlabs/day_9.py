numbers = [list(map(int, e.strip().split(" "))) for e in open("input.txt")]

dist = lambda l, r: r - l


def deduce(values: list[int]):
    return [dist(values[i], values[i + 1]) for i in range(len(values) - 1)]


def extrapolate(values: list[int]):
    deduced = deduce(values)
    extrapolated = extrapolate(deduced) if any(deduced) else deduced + [0]
    return values + [values[-1] + extrapolated[-1]]


print(f"Part 1: {sum([extrapolate(e)[-1] for e in numbers])}")


def extrapolate_back(values: list[int]):
    deduced = deduce(values)
    extrapolated = extrapolate_back(deduced) if any(deduced) else [0] + deduced
    return [values[0] - extrapolated[0]] + values


print(f"Part 2: {sum([extrapolate_back(e)[0] for e in numbers])}")
