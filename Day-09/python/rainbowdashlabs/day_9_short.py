numbers = [list(map(int, e.strip().split(" "))) for e in open("input.txt")]


def extrapolate(values: list[int]):
    deduced = [values[i + 1] - values[i] for i in range(len(values) - 1)]
    return values + [values[-1] + (extrapolate(deduced) if any(deduced) else deduced + [0])[-1]]


print(f"Part 1: {sum([extrapolate(e)[-1] for e in numbers])}")


def extrapolate_back(values: list[int]):
    deduced = [values[i + 1] - values[i] for i in range(len(values) - 1)]
    return [values[0] - (extrapolate_back(deduced) if any(deduced) else [0] + deduced)[0]] + values


print(f"Part 2: {sum([extrapolate_back(e)[0] for e in numbers])}")
