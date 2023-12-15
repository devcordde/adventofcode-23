from functools import reduce


def hash(string):
    return reduce(lambda value, char: (value + ord(char)) * 17 % 256, string, 0)


sequences = open("input15.txt").read().split(",")
boxes = {}
for i in range(256):
    boxes.setdefault(i, [])

for sequence in sequences:
    if "-" in sequence:
        label = sequence[:-1]
        box_index = hash(label)

        for element in boxes[box_index]:
            if element[0] == label:
                boxes[box_index].remove(element)
    else:
        (label, focal_length) = sequence.split("=")
        box_index = hash(label)
        found = False
        for i, element in enumerate(boxes[box_index]):
            if element[0] == label:
                boxes[box_index][i] = (element[0], focal_length)
                found = True

        if not found:
            boxes[box_index].append((label, focal_length))

print(f"Part 1: {sum(map(hash, sequences))}")
print(f"Part 2: {sum(map(sum, map(lambda box: map(lambda item: (box[0] + 1) * (item[0] + 1) * int(item[1][1]), enumerate(box[1])), boxes.items())))}")
