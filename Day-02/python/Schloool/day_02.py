from functools import reduce

input = open('input.txt').readlines()

bag = {
    'red': 12,
    'green': 13,
    'blue': 14
}


def get_color_choices_for_line(line: str):
    game_rounds = [choice.strip() for choice in line.split(':')[1].split(';')]
    color_choices = []
    for round in game_rounds:
        choices = [round_choice.strip().split(' ') for round_choice in round.split(',')]
        for choice in choices:
            color_choices.append((choice[1], int(choice[0])))
    return color_choices


def game_is_possible(line: str) -> bool:
    return all(bag.get(color, 0) >= n for color, n in get_color_choices_for_line(line))


possible_game_ids = [id for id, line in enumerate(input, start=1) if game_is_possible(line)]

# Part 1
print(sum(possible_game_ids))

powers = []
for line in input:
    bag = bag.fromkeys(bag, 0)
    for color, n in get_color_choices_for_line(line):
        bag[color] = max(bag[color], n)
    powers.append(reduce(lambda a, b: a * b, bag.values()))

# Part 2
print(sum(powers))
