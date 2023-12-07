from shared.paul2708.output import *
from shared.paul2708.input_reader import *
from functools import cmp_to_key

outcomes = [[], [], [], [], [], [], []]

FIVE_OF_A_KIND = 0
FOUR_OF_A_KIND = 1
FULL_HOUSE = 2
THREE_OF_A_KIND = 3
TWO_PAIR = 4
ONE_PAIR = 5
HIGHEST_CARD = 6

cards = ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]


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


def compare_two_hands(hand_a, hand_b):
    for i in range(len(hand_a)):
        if hand_a[i] == hand_b[i]:
            continue

        return 1 if cards.index(hand_a[i]) > cards.index(hand_b[i]) else -1


bids = [(line.split(" ")[0], int(line.split(" ")[1].strip())) for line in read_plain_input(day=7)]

for hand, bid in bids:
    elem = (hand, bid)
    best_outcome = determine_best_hand(hand)

    outcomes[best_outcome].append(elem)

winnings = 0
ranking = len(bids)
for outcome in outcomes:
    outcome.sort(key=lambda b: cmp_to_key(compare_two_hands)(b[0]))

    for _, bid in outcome:
        winnings += bid * ranking
        ranking -= 1

write(f"The total amount of winnings is <{winnings}>.")
