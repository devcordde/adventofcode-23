from functools import reduce
from operator import mul
from pprint import pprint
from re import split

time, distance = [e.strip() for e in open("input.txt").readlines()]
races = list(zip(map(int, split("\\s+", time)[1:]), map(int, split("\\s+", distance)[1:])))
pprint(races)

win_times = [len([charge for charge in range(time) if (time - charge) * charge > record]) for time, record in races]

print(f"Part 1: {reduce(mul, win_times)}")

time, distance = [int(e.strip().split(":")[1].replace(" ", "")) for e in open("input.txt").readlines()]

print(time, distance)
# Could do range search here but... eeeh... CPU goes brrt
print(f"Part 2 {len([charge for charge in range(time) if (time - charge) * charge > distance])}")
