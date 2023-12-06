from functools import reduce
from operator import mul
from re import split
from time import time as now

start = now()
time, distance = [e.strip() for e in open("input.txt").readlines()]
races = list(zip(map(int, split("\\s+", time)[1:]), map(int, split("\\s+", distance)[1:])))

win_times = [len([charge for charge in range(time) if (time - charge) * charge > record]) for time, record in races]

print(f"Part 1: {reduce(mul, win_times)}")

time, distance = [int(e.strip().split(":")[1].replace(" ", "")) for e in open("input.txt").readlines()]

lower = 0

for charge in range(time):
    if (time - charge) * charge > distance:
        lower = charge
        break

upper = time
for charge in range(time, 0, -1):
    if (time - charge) * charge > distance:
        upper = charge
        break

print(f"Part 2 {upper - lower + 1}")
print(f"Took {round(now() - start, 4)*1000} ms")
