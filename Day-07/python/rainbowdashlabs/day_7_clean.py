from collections import OrderedDict, Counter, namedtuple
from dataclasses import dataclass

CardCount = namedtuple("CardCount", ["type", "count"])
values = {v: i for i, v in enumerate(reversed(["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]))}

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
    return det_type_by_counts(sorted([CardCount(k, v) for k, v in Counter(counts).items()], key=lambda x: x[1], reverse=True))


def det_type_by_counts(counts: list[CardCount]):
    for type, cond in types.items():
        if cond(counts):
            return type


def det_type_with_joker(s_counts: list[int]):
    counts = Counter(s_counts)
    jokers = counts.pop(values["J"], 0)
    if jokers == 5:
        s_counts = [CardCount(values["J"], jokers)]
    else:
        s_counts = sorted([CardCount(k, v) for k, v in counts.items()], key=lambda x: x[1], reverse=True)
        s_counts[0] = CardCount(s_counts[0].type, s_counts[0].count + jokers)  # Add joker
    return det_type_by_counts(s_counts)


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
        return Hand(cards, det_type(cards), int(score))

    @staticmethod
    def parse_joker(line: str):
        cards, score = line.split(" ")
        cards = parse_cards(cards)
        return Hand(cards, det_type_with_joker(cards), int(score))

    def __lt__(self, other: "Hand"):
        print(self, other)
        if other.type != self.type:
            return self.type < other.type
        for i in range(5):
            if self.cards[i] != other.cards[i]:
                return self.cards[i] < other.cards[i]
        return False


hands = sorted([Hand.parse(e.strip()) for e in open("input.txt").readlines()])

print(f"Part 1: {sum([e.score * i for i, e in enumerate(hands, start=1)])}")

# New scoring sytem
values = {v: i for i, v in enumerate(reversed(["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]))}

hands = sorted([Hand.parse_joker(e.strip()) for e in open("input.txt").readlines()])

print(f"Part 2: {sum([e.score * i for i, e in enumerate(hands, start=1)])}")
