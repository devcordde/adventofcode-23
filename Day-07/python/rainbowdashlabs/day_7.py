from collections import OrderedDict, Counter, namedtuple
from dataclasses import dataclass
from pprint import pprint

CardCount = namedtuple("CardCount", ["type", "count"])
values = OrderedDict()
for i, v in enumerate(reversed(["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]), start=2):
    values[v] = i
pprint(values)

types = OrderedDict({
    7: lambda x: x[0].count == 5,  # Five of a kind
    6: lambda x: x[0].count == 4,  # Four of a kind
    5: lambda x: x[0].count == 3 and x[1].count == 2,  # Full house
    4: lambda x: x[0].count == 3,  # Three of a kind
    3: lambda x: x[0].count == 2 and x[1].count == 2,  # Two pairs
    2: lambda x: x[0].count == 2,  # Two of a kind
    1: lambda x: x[0].count == 1,  # High Card
})


def det_type(counts: list[int]):
    counts = sorted([CardCount(k, v) for k, v in Counter(counts).items()], key=lambda x: x[1], reverse=True)
    for type, cond in types.items():
        if cond(counts):
            return type


def det_j_type(s_counts: list[int]):
    counts = Counter(s_counts)
    jokers = 0
    if values["J"] in counts:
        jokers: int = counts[values["J"]]
        del counts[values["J"]]
    if jokers == 5:
        s_counts = [CardCount(values["J"], jokers)]
    else:
        s_counts = sorted([CardCount(k, v) for k, v in counts.items()], key=lambda x: x[1], reverse=True)
        s_counts[0] = CardCount(s_counts[0].type, s_counts[0].count + jokers)
    for type, cond in types.items():
        if cond(s_counts):
            return type


def parse_cards(cards: list[str]):
    return [values[e] for e in cards]


@dataclass
class Hand:
    cards: list[int]
    type: int
    score: int

    @staticmethod
    def parse(line: str):
        cards, score = line.split(" ")
        cards = parse_cards(cards)
        type = det_type(cards)
        return Hand(cards, type, int(score))

    @staticmethod
    def parse_joker(line: str):
        cards, score = line.split(" ")
        cards = parse_cards(cards)
        type = det_j_type(cards)
        return Hand(cards, type, int(score))

    def __lt__(self, other: "Hand"):
        print(self, other)
        if other.type != self.type:
            return self.type < other.type
        for i in range(5):
            if self.cards[i] != other.cards[i]:
                return self.cards[i] < other.cards[i]
        return False


hands = [Hand.parse(e.strip()) for e in open("input.txt").readlines()]
hands = sorted(hands)

print(f"Part 1: {sum([e.score * i for i, e in enumerate(hands, start=1)])}")

# New scoring sytem
values = OrderedDict()
for i, v in enumerate(reversed(["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]), start=2):
    values[v] = i

hands = [Hand.parse_joker(e.strip()) for e in open("input.txt").readlines()]
pprint(hands)
hands = sorted(hands)

print(f"Part 2: {sum([e.score * i for i, e in enumerate(hands, start=1)])}")
