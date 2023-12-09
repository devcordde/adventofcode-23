def find_step_size(sequence: list[int], part2: bool) -> int:
    if sequence.count(0) == len(sequence):
        return 0

    new_sequence = []
    for i in range(1, len(sequence)):
        new_sequence.append(sequence[i] - sequence[i - 1])

    if part2:
        return sequence[0] - find_step_size(new_sequence, True)
    else:
        return sequence[-1] + find_step_size(new_sequence, False)


sequences = [list(map(lambda x: int(x), line.split())) for line in open("input9.txt").read().split("\n")]
print(f"Part 1: {sum(map(lambda sequence: find_step_size(sequence, False), sequences))}")
print(f"Part 2: {sum(map(lambda sequence: find_step_size(sequence, True), sequences))}")
