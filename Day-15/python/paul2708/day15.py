from shared.paul2708.input_reader import *
from shared.paul2708.output import *


def HASH(message):
    current_value = 0

    for c in message:
        current_value += ord(c)
        current_value *= 17
        current_value %= 256

    return current_value


results = 0
boxes = {}
for i in range(256):
    boxes[i] = []

for sequence in read_plain_input(day=15)[0].split(","):
    results += HASH(sequence)

    label = sequence.replace("-", "").split("=")[0]
    box_index = HASH(label)

    if "-" in sequence:
        for lab, length in boxes[box_index]:
            if lab == label:
                boxes[box_index].remove((label, length))
    else:
        focal_length = int(sequence.split("=")[1])

        done = False
        for lab, length in boxes[box_index]:
            if lab == label:
                boxes[box_index][boxes[box_index].index((label, length))] = (label, focal_length)
                done = True
                break

        if done:
            continue

        boxes[box_index].append((label, focal_length))

focusing_power = 0
for i, box in enumerate(boxes):
    for j, (label, length) in enumerate(boxes[box]):
        focusing_power += (i + 1) * (j + 1) * length

write(f"The sum of the HASH results is <{results}>.")
write(f"The focusing power of the resulting lens configuration is <{focusing_power}>.")
