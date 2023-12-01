import re

INPUT_DIRECTORY = "../../../shared/paul2708/inputs"


def read_plain_input(day, example=None):
    with open(f"{INPUT_DIRECTORY}/day{day:02d}{f'-example-{example}' if example is not None else ''}.txt") as file:
        return file.read().splitlines()


def read_ints(day, example=None):
    return [int(line) for line in read_plain_input(day, example)]


def read_regex(pattern: str, transformation=None, day=1, example=None):
    result = []
    for line in read_plain_input(day, example):
        groups = re.search(pattern, line).groups()
        if transformation is not None:
            result.append(transformation(*groups))
        else:
            if len(groups) == 1:
                result.append(groups[0])
            else:
                result.append(groups)

    return result


def flatten(list_of_lists):
    return [item for single_list in list_of_lists for item in single_list]
