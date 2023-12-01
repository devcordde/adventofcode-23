numbers = [int(e[0] + e[-1]) for e in [[c for c in e if c.isnumeric()] for e in open("input.txt").readlines()]]
print(f"Part 1 {sum(numbers)}")

mapping = {"one": "1",
           "two": "2",
           "three": "3",
           "four": "4",
           "five": "5",
           "six": "6",
           "seven": "7",
           "eight": "8",
           "nine": "9"}


def transform(line: str) -> list[str]:
    res = []
    for i in range(1, len(line)):
        cur = line[0:i]
        if cur[-1].isnumeric():
            res.append(cur[-1])
            continue
        for word, value in mapping.items():
            if cur.endswith(word):
                res.append(value)
                break
    return res


numbers = [transform(e) for e in open("input.txt").readlines()]
numbers = [int(e[0] + e[-1]) for e in numbers]

print(f"Part 2 {sum(numbers)}")
