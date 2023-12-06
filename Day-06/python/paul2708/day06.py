from shared.paul2708.output import *
from shared.paul2708.input_reader import *


def compute_combinations(time, distance):
    start = 0

    while (time - start) * start <= distance:
        start += 1

    end = time - start

    return end - start + 1


lines = read_plain_input(day=6)

# Part 1
times = [int(d.strip()) for d in lines[0].replace("Time:", "").split(" ") if d]
distances = [int(d.strip()) for d in lines[1].replace("Distance:", "").split(" ") if d]
races = list(zip(times, distances))

combinations = 1
for time, distance in races:
    combinations *= compute_combinations(time, distance)

write(f"The multiplied combinations result in <{combinations}>.")

# Part 2
time = int(lines[0].replace("Time: ", "").replace(" ", ""))
distance = int(lines[1].replace("Distance: ", "").replace(" ", ""))

write(f"For the single race, there are <{compute_combinations(time, distance)}> combinations.")
