def divide_chunks(l):
    for i in range(0, len(l), 2):
        yield l[i:i + 2]


def find_valid_maps(conversion, seed, n):
    return list(filter(lambda r: r.start < r.stop, [range(max(conversion.start, seed.start) + n, min(conversion.stop, seed.stop) + n)]))


def find_mapping(conversion, seed, n):
    return find_valid_maps(conversion, seed, n), find_valid_maps(conversion, seed, 0)


def solve(seeds, maps):
    for m in maps:
        conversions = m.split("\n")
        conversions.pop(0)
        conversions = list(map(lambda x: [int(y) for y in x.split()], conversions))

        new_seeds = []

        for i, seed in enumerate(seeds):
            mapped_seeds = []

            for conversion in conversions:
                n = conversion[0] - conversion[1]
                conversion_range = range(conversion[1], conversion[1] + conversion[2])
                split = find_mapping(conversion_range, seed, n)
                if split[0]:
                    mapped_seeds.append(split)

            mapped_seeds = sorted(mapped_seeds, key=lambda x: x[1][0].start)

            current_start = seed.start
            unmapped_seeds = []
            for element in mapped_seeds:
                if current_start == element[1][0].start:
                    current_start = element[1][0].stop
                    continue
                unmapped_seeds.append(range(current_start, element[1][0].start))
                current_start = element[1][0].stop

            if current_start != seed.stop:
                unmapped_seeds.append(range(current_start, seed.stop))

            new_seeds.extend(unmapped_seeds)
            new_seeds.extend(map(lambda x: x[0][0], mapped_seeds))

        seeds = new_seeds

    return min(map(lambda x: x.start, seeds))


maps = open("input.txt").read().split("\n\n")
seed_data = [int(x) for x in maps[0].split(": ")[1].split()]
seeds = [range(y[0], y[0] + y[1]) for y in divide_chunks(seed_data)]
maps.pop(0)

part1 = solve([range(x, x + 1) for x in seed_data], maps)
part2 = solve(seeds, maps)

print(f"Part 1: {part1}")
print(f"Part 2: {part2}")
