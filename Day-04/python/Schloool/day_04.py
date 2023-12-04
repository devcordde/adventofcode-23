input = open('input.txt').readlines()

points = 0
matches_per_card = []
for card in range(len(input)):
    num_split = input[card].split(':')[1].split('|')
    winning = [int(n) for n in num_split[0].split()]
    draw = [int(n) for n in num_split[1].split()]
    matches = sum([winning.count(d) for d in draw])
    matches_per_card.append(matches)
    points += matches if matches <= 1 else 2 ** (matches - 1)

# Part 1
print(points)

won_cards = [1] * len(matches_per_card)
for card in range(len(matches_per_card)):
    for i in range(card + 1, min(card + matches_per_card[card] + 1, len(matches_per_card))):
        won_cards[i] += won_cards[card]

# Part 2
print(sum(won_cards))
