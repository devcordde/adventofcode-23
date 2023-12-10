from shared.paul2708.output import *
from shared.paul2708.input_reader import *

rows = [[int(d.strip()) for d in line.split(" ") if d] for line in read_plain_input(day=9)]


def calculate_diff(numbers):
    diff = []

    for i in range(len(numbers) - 1):
        diff.append(numbers[i + 1] - numbers[i])

    return diff


def calculate_next_number(numbers):
    diffs = [numbers]

    iter_numbers = numbers.copy()
    while not diffs[-1].count(0) == len(diffs[-1]):
        diffs.append(calculate_diff(iter_numbers))
        iter_numbers = diffs[-1]

    curr = 0
    for diff in reversed(diffs):
        curr += diff[-1]

    return curr


total = sum([calculate_next_number(row) for row in rows])
write(f"The sum of the following numbers is <{total}>.")


def calculate_previous_number(numbers):
    diffs = [numbers]

    iter_numbers = numbers.copy()
    while not diffs[-1].count(0) == len(diffs[-1]):
        diffs.append(calculate_diff(iter_numbers))
        iter_numbers = diffs[-1]

    curr = 0
    for diff in reversed(diffs):
        curr = diff[0] - curr

    return curr


total = sum([calculate_previous_number(row) for row in rows])
write(f"The sum of the previous numbers is <{total}>.")
