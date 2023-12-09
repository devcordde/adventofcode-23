def find_step(sequence, part2):
    if sequence.count(0) == len(sequence):
        return 0

    merged_sequence = [sequence[i] - sequence[i - 1] for i in range(1, len(sequence))]

    return sequence[0 if part2 else -1] + (-1 if part2 else 1) * find_step(merged_sequence, part2)


sequences = [list(map(lambda x: int(x), line.split())) for line in open("input.txt").read().split("\n")]
print(f"Part 1: {sum(map(lambda sequence: find_step(sequence, False), sequences))}")
print(f"Part 2: {sum(map(lambda sequence: find_step(sequence, True), sequences))}")
