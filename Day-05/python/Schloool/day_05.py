import re

input = open('input.txt').readlines()
seeds = [int(x) for x in re.findall(r'\d+', input[0])]

maps, current_stack = [], []
for line in input[3:]:
    matches = re.findall(r'\d+', line)
    if re.match(r'\D', line):
        maps.append(current_stack)
        current_stack = []
        continue
    current_stack.append([int(n) for n in matches])
maps.append(current_stack)


def get_mapping(num: int, stacks: list[list[int]]) -> int:
    for stack in stacks:
        if len(stack) == 0:
            continue

        source_range = range(stack[1], stack[1] + stack[2] + 1)
        if num in source_range:
            return stack[0] + source_range.index(num)


def get_seed_location(seed: int) -> int:
    for map_index in range(len(maps)):
        seed = get_mapping(seed, maps[map_index]) or seed
    return seed


# Part 1
seed_mappings = [get_seed_location(seed) for seed in seeds]
print(min(seed_mappings))

ranges = [range(x[0], x[0] + x[1]) for x in list(zip(*[iter(seeds)] * 2))]

lowest = float('inf')
for r in ranges:
    for seed in r:
        lowest = min(get_seed_location(seed), lowest)

# Part 2 (we do not talk about time lmaooo)
# No seriously, if you ask anything about the time I waited, I will make you calculate this shit by hand
print(lowest)
