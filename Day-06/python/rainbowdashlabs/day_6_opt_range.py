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

wins = lambda time, charge, distance: (time - charge) * charge > distance
center = lambda a, b: int((a + b) // 2)

t_lower, t_upper = 14, 71516

offset = time / 2
L, R = 0, time // 2
while L != R:
    c = center(L, R)
    # Lower side still wins we search there
    if wins(time, c - 1, distance):
        R = c
        if not wins(time, c, distance):
            R = c
    elif not wins(time, c, distance):
        # Lower side doesn't win anymore, but upper does
        L = c
    else:
        L, R = c, c

lower = L

L, R = time // 2, time
while L != R:
    c = center(L, R)
    # Lower side still wins we continue here
    if wins(time, c, distance):
        L = c
        if not wins(time, c + 1, distance):
            R = c
    elif not wins(time, c + 1, distance):
        # upper side doesn't win anymore, but lower does
        R = c
    else:
        L, R = c, c
upper = L

print(f"Part 2: {upper - lower + 1}")
print(f"Took {round(now() - start, 4) * 1000} ms")
