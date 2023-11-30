import re

INPUT_DIRECTORY = "../../../shared/paul2708/inputs"


def read_plain_input(day, example=None):
    with open(f"{INPUT_DIRECTORY}/day{day:02d}{f'-example-{example}' if example is not None else ''}.txt") as file:
        return file.read().splitlines()


def read_ints(day, example=None):
    return [int(line) for line in read_plain_input(day, example)]


def read_regex(pattern: str, transformation=lambda x: x, day=1, example=None):
    result = []
    for line in read_plain_input(day, example):
        result.append(transformation(*re.search(pattern, line).groups()))

    return result
