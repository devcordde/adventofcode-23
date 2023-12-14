def calculate_total(input, multiplier):
    total = 0

    for reflection in input:
        for i in range(0, len(reflection) - 1):
            valid = True

            for j in range(0, len(reflection) - i - 1):
                if i - j < 0:
                    break

                if reflection[i - j] != reflection[i + j + 1]:
                    valid = False
                    break

            if valid:
                total += multiplier * (i + 1)

    return total


input = list(map(lambda x: x.split("\n"), open("input.txt").read().split("\n\n")))
total = calculate_total(input, 100)

new_input = []
for reflection in input:
    transponated_reflection = []

    for i in range(0, len(reflection[0])):
        s = ""
        for x in reflection:
            s += x[i]
        transponated_reflection.append(s)

    new_input.append(transponated_reflection)

total += calculate_total(new_input, 1)

print(f"Part 1: {total}")
