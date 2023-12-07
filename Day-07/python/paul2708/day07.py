from shared.paul2708.output import *
from shared.paul2708.input_reader import *
from functools import cmp_to_key

outcomes = [[], [], [], [], [], [], []]
outcomes_with_jokers = [[], [], [], [], [], [], []]

FIVE_OF_A_KIND = 0
FOUR_OF_A_KIND = 1
FULL_HOUSE = 2
THREE_OF_A_KIND = 3
TWO_PAIR = 4
ONE_PAIR = 5
HIGHEST_CARD = 6

cards = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
cards_with_jokers = ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]


def contains_same_cards(hand, n):
    return any([hand.count(card) == n for card in cards])


def contains_pairs(hand, n):
    return [hand.count(card) == 2 for card in cards].count(True) == n


def determine_best_hand(hand):
    if contains_same_cards(hand, 5):
        return FIVE_OF_A_KIND
    if contains_same_cards(hand, 4):
        return FOUR_OF_A_KIND
    if contains_pairs(hand, 1) and contains_same_cards(hand, 3):
        return FULL_HOUSE
    if contains_same_cards(hand, 3):
        return THREE_OF_A_KIND
    if contains_pairs(hand, 2):
        return TWO_PAIR
    if contains_pairs(hand, 1):
        return ONE_PAIR

    return HIGHEST_CARD


def determine_best_hand_with_jokers(hand):
    without_jokers = determine_best_hand(hand)
    jokers = hand.count("J")

    if jokers == 0:
        return without_jokers

    if without_jokers == FIVE_OF_A_KIND or without_jokers == FOUR_OF_A_KIND:
        return FIVE_OF_A_KIND
    if without_jokers == FULL_HOUSE and (jokers == 2 or jokers == 3):
        return FIVE_OF_A_KIND
    if without_jokers == THREE_OF_A_KIND:
        if jokers == 1 or jokers == 3:
            return FOUR_OF_A_KIND
        if jokers == 2:
            return FIVE_OF_A_KIND
    if without_jokers == TWO_PAIR:
        if jokers == 1:
            return FULL_HOUSE
        if jokers == 2:
            return FOUR_OF_A_KIND
    if without_jokers == ONE_PAIR and (jokers == 1 or jokers == 2):
        return THREE_OF_A_KIND
    if without_jokers == HIGHEST_CARD and jokers == 1:
        return ONE_PAIR


def compare_two_hands(hand_a, hand_b, card_order):
    for i in range(len(hand_a)):
        if hand_a[i] == hand_b[i]:
            continue

        return 1 if card_order.index(hand_a[i]) > card_order.index(hand_b[i]) else -1


bids = [(line.split(" ")[0], int(line.split(" ")[1].strip())) for line in read_plain_input(day=7)]

for hand, bid in bids:
    best_outcome = determine_best_hand(hand)
    best_outcome_with_jokers = determine_best_hand_with_jokers(hand)

    outcomes[best_outcome].append((hand, bid))
    outcomes_with_jokers[best_outcome_with_jokers].append((hand, bid))


def compute_winnings(outcome_type, jokers=False):
    winnings = 0
    ranking = len(bids)
    for outcome in outcome_type:
        outcome.sort(
            key=lambda b: cmp_to_key(lambda x, y: compare_two_hands(x, y, cards_with_jokers if jokers else cards))(
                b[0]))

        for _, bid in outcome:
            winnings += bid * ranking
            ranking -= 1

    return winnings


write(f"The total amount of winnings is <{compute_winnings(outcomes)}>.")
write(
    f"After considering jokers, the total amount of winnings is <{compute_winnings(outcomes_with_jokers, jokers=True)}>.")
