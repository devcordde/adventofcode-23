import itertools

import tqdm

from shared.paul2708.input_reader import *
from shared.paul2708.output import *




def generate_all_possible_records(template):
    result = []

    for combination in list(itertools.product([".", "#"], repeat=template.count("?"))):
        record = template
        for c in combination:
            record = record.replace("?", c, 1)

        result.append(record)

    return result


def matches(record, group):
    curr_counter = 0
    gr = []

    for c in record:
        if c == "#":
            curr_counter += 1
        else:
            gr.append(curr_counter)
            curr_counter = 0

    gr.append(curr_counter)

    gr = [i for i in gr if i != 0]

    return gr == group


records = [(row.split(" ")[0], [int(d) for d in row.split(" ")[1].split(",")]) for row in
           read_plain_input(day=12, example=None)]

arrangements = 0
for template, groups in tqdm.tqdm(records):
    arrangements += sum([1 for record in generate_all_possible_records(template) if matches(record, groups)])

print(arrangements)