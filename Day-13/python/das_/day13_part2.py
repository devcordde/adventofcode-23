import copy


def find_differences(string1, string2):
    differences = []

    for k in range(0, len(string1)):
        if string1[k] != string2[k]:
            differences.append(k)

    return differences


def find_corrections(input, multiplier):
    total = 0

    for reflection in input:
        for i in range(0, len(reflection) - 1):
            valid = True
            found_difference = False
            position = ()

            for j in range(0, len(reflection) - i - 1):
                if i - j < 0:
                    break

                difference = find_differences(reflection[i - j], reflection[i + j + 1])
                if len(difference) == 1:
                    if found_difference:
                        valid = False
                        break
                    else:
                        found_difference = True
                        position = (i - j, difference[0])
                elif len(difference) > 1:
                    valid = False
                    break

            if valid and found_difference:
                total += multiplier * (i + 1)
                new_element = "#" if reflection[position[0]][position[1]] == "." else "."
                reflection[position[0]] = reflection[position[0]][:position[1]] + new_element + reflection[position[0]][position[1] + 1:]
                break

    return input, total


input = open("input13.txt").read().split("\n\n")
input = list(map(lambda x: x.split("\n"), input))
corrected_input, total = find_corrections(copy.deepcopy(input), 100)
needs_correction = [x for i, x in enumerate(corrected_input) if input[i] == x]
transposed_input_needs_correction = []
for reflection in needs_correction:
    transposed_lines = []

    for i in range(0, len(reflection[0])):
        s = ""
        for x in reflection:
            s += x[i]
        transposed_lines.append(s)

    transposed_input_needs_correction.append(transposed_lines)

corrected_input, amount = find_corrections(copy.deepcopy(transposed_input_needs_correction), 1)
total += amount

print(f"Part 2: {total}")
