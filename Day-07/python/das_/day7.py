from enum import Enum


class Hand:
    def __init__(self, cards: str, bid: int, card_order: str, joker_rule: bool):
        self.cards = cards
        self.bid = bid
        self.card_order = card_order
        self.joker_rule = joker_rule
        self.hand_type = self.__find_hand_type()

    def __find_hand_type(self):
        occurrences = list(map(lambda card: self.cards.count(card),
                               filter(lambda card: not self.joker_rule or card != "J", self.card_order)))

        match max(occurrences) + self.cards.count("J") * int(self.joker_rule):
            case 5:
                return HandType.FIVE_OF_A_KIND
            case 4:
                return HandType.FOUR_OF_A_KIND
            case 3:
                if self.joker_rule and self.cards.count("J") == 1:
                    if occurrences.count(2) == 2:
                        return HandType.FULL_HOUSE
                    else:
                        return HandType.THREE_OF_A_KIND

                if 2 in occurrences:
                    return HandType.FULL_HOUSE
                else:
                    return HandType.THREE_OF_A_KIND
            case 2:
                if occurrences.count(2) == 2:
                    return HandType.TWO_PAIR
                else:
                    return HandType.ONE_PAIR
            case _:
                return HandType.HIGH_CARD

    def __lt__(self, other):
        if other.hand_type != self.hand_type:
            return self.hand_type.value < other.hand_type.value

        return (list(map(lambda x: self.card_order.index(x), self.cards)) >
                list(map(lambda x: self.card_order.index(x), other.cards)))


class HandType(Enum):
    FIVE_OF_A_KIND = 7
    FOUR_OF_A_KIND = 6
    FULL_HOUSE = 5
    THREE_OF_A_KIND = 4
    TWO_PAIR = 3
    ONE_PAIR = 2
    HIGH_CARD = 1


def solve(input_lines, card_order, joker_rule):
    cards = [Hand(y[0], int(y[1]), card_order, joker_rule) for y in input_lines]
    sorted_cards = sorted(cards)
    return sum(map(lambda x: x[1].bid * (x[0] + 1), enumerate(sorted_cards)))


i = open("input.txt").read().split("\n")
input_lines = [line.split() for line in i]
print(f"Part 1: {solve(input_lines, 'AKQJT98765432', False)}")
print(f"Part 2: {solve(input_lines, 'AKQT98765432J', True)}")
