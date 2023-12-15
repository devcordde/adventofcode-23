from functools import reduce


def hash(string):
    return reduce(lambda value, char: (value + ord(char)) * 17 % 256, string, 0)


sequences = [sequence for sequence in open("input15.txt").read().replace("\n", "").split(",")]
boxes = {}
for i in range(256): boxes.setdefault(i, [])

for sequence in sequences:
    if sequence.count("-") == 1:
        label = sequence[:-1]
        box = hash(label)

        for element in boxes[box]:
            if element[0] == label:
                boxes[box].remove(element)
    else:
        (label, focal_length) = sequence.split("=")
        box = hash(label)
        found = False
        for i, element in enumerate(boxes[box]):
            if element[0] == label:
                boxes[box][i] = (element[0], focal_length)
                found = True

        if not found:
            boxes[box].append((label, focal_length))

print(f"Part 1: {sum([hash(sequence) for sequence in sequences])}")
print(f"Part 2: {sum(map(sum, map(lambda box: map(lambda item: (box[0] + 1) * (item[0] + 1) * int(item[1][1]), enumerate(box[1])), boxes.items())))}")
