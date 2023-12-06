import re

input = open('input.txt').readlines()
nums = [re.findall(r'\d+', line) for line in input]


def wins_race(speed, distance, record):
    return speed * (distance - speed) > record


record_combinations = 1
for n in range(len(nums[0])):
    time = int(nums[0][n])
    record = int(nums[1][n])
    record_presses = [press for press in range(time) if wins_race(press, time, record)]
    record_combinations *= len(record_presses)

# Part 1
print(record_combinations)

time_full, record_full = int(''.join(nums[0])), int(''.join(nums[1]))

# Part 2
print(len([press for press in range(time_full) if wins_race(press, time_full, record_full)]))
