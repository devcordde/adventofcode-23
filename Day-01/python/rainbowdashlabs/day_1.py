p1 = sum([int(e[0] + e[-1]) for e in [[c for c in e if c.isnumeric()] for e in open('input.txt').readlines()]])
print(f"Part 1 {p1}")

num = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
mapping = {e: str(i) for i, e in enumerate(num, start=1)}


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


p2 = sum([int(e[0] + e[-1]) for e in [transform(e) for e in open("input.txt").readlines()]])
print(f"Part 2 {p2}")
