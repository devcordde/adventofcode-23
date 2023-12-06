from shared.paul2708.output import *
from shared.paul2708.input_reader import *

lines = read_plain_input(day=5, example=None)

# Parse seeds and maps
seeds = [int(s) for s in lines[0].split(" ") if s.isdigit()]

maps = {}
current_map = None
for line in lines:
    if "map" in line:
        current_map = line
        maps[current_map] = []
        continue

    if line.strip() and current_map is not None:
        maps[current_map].append([int(s) for s in line.split(" ") if s.isdigit()])


def from_to(source_type, dest_type, source_number):
    if f"{source_type}-to-{dest_type} map:" in maps:
        mapping = maps[f"{source_type}-to-{dest_type} map:"]

        for rule in mapping:
            dest_start = rule[0]
            source_start = rule[1]
            length = rule[2]

            if source_start <= source_number < source_start + length:
                return dest_start + (source_number - source_start)

        return source_number
    else:
        mapping = maps[f"{dest_type}-to-{source_type} map:"]

        for rule in mapping:
            source_start = rule[0]
            dest_start = rule[1]
            length = rule[2]

            if source_start <= source_number < source_start + length:
                return dest_start + (source_number - source_start)

        return source_number


type_chain = ["seed", "soil", "fertilizer", "water", "light", "temperature", "humidity", "location"]

# Part 1
locations = []

for seed in seeds:
    num = seed
    for i in range(len(type_chain) - 1):
        num = from_to(type_chain[i], type_chain[i + 1], num)

    locations.append(num)

write(f"The minimal location number is <{min(locations)}>,")

# Part 2
location_num = 0
while True:
    num = location_num

    for i in range(len(type_chain) - 1, 0, -1):
        num = from_to(type_chain[i], type_chain[i - 1], num)

    for i in range(0, len(seeds) - 1, 2):
        if seeds[i] <= num < seeds[i] + seeds[i + 1]:
            write(f"After waiting for too long, the new minimal location number is <{location_num}>.")
            exit(0)

    location_num += 1
