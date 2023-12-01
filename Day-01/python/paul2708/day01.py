from shared.paul2708.output import *
from shared.paul2708.input_reader import *

lines = read_plain_input(1)

numbers = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9
}

total_part1 = 0
total_part2 = 0


def find_last_written_digit(line):
    value = None
    i = None
    for number in numbers:
        index = line.rfind(number)
        if index == -1:
            continue

        if i is None or index > i:
            value = numbers[number]
            i = index

    return i, value


def find_first_written_digit(line):
    value = None
    i = None

    for number in numbers:
        index = line.find(number)
        if index == -1:
            continue

        if i is None or index < i:
            value = numbers[number]
            i = index

    return i, value


for line in lines:
    first = None
    last = None
    first_i = 100000
    last_i = -100000

    for i, c in enumerate(line):
        if c.isdigit():
            if first is None:
                first = int(c)
                first_i = i

    for i, c in enumerate(reversed(line)):
        if c.isdigit():
            if last is None and last_i < i:
                last_i = len(line) - i - 1
                last = int(c)

    total_part1 += first * 10 + last

    # Part 2
    index, value = find_first_written_digit(line)

    if not (index is None or index > first_i):
        first = value

    index, value = find_last_written_digit(line)

    if not (index is None or last_i > index):
        last = value

    total_part2 += 10 * first + last

write(f"The sum of all of the calibration values is <{total_part1} (part 1)> and <{total_part2} (part 2)>.")
