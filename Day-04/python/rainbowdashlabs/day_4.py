import re
from pprint import pprint

cards = [e.strip().split(":") for e in open("input.txt").readlines()]
cards = {int(x[0].split(" ")[-1]): x[1].split("|") for x in cards}
cards = {k: [set(map(int, re.split("\\s+", x.strip()))) for x in v] for k, v in cards.items()}

double = lambda times: 0 if times < 0 else 1 << times
points = {k: double(len(v[0].intersection(v[1])) - 1) for k, v in cards.items()}

print(f"Part 1: {sum(points.values())}")

card_mult = {k: 1 for k, v in cards.items()}
inter = {k: len(v[0].intersection(v[1])) for k, v in cards.items()}

pprint(card_mult)
pprint(inter)

for k, v in cards.items():
    print(f"Card {k}")
    print(f"{inter[k]} matching")
    print(f"{card_mult[k] - 1} copies")
    for i in range(k + 1, k + inter[k] + 1, 1):
        print(f"Got {card_mult[k]} copy of {i}")
        card_mult[i] = card_mult[i] + 1 * card_mult[k]

pprint(card_mult)
print(f"Part 2: {sum(card_mult.values())}")
