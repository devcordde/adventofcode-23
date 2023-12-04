from shared.paul2708.output import *
from shared.paul2708.input_reader import *


def parse_card(line):
    card_id = int(line.split(":")[0].replace("Card", "").strip())
    winning_numbers = [int(d) for d in line.replace(f'{line.split(":")[0]}: ', "").split(" |")[0].split(" ") if d]
    numbers = [int(d) for d in line.replace(f"Card {card_id}: ", "").split("| ")[1].split(" ") if d]

    return card_id, set(winning_numbers), set(numbers)


cards = [parse_card(line) for line in read_plain_input(day=4)]
points = [2 ** (len(numbers.intersection(winning_numbers)) - 1) for card_id, winning_numbers, numbers in cards if
          not winning_numbers.isdisjoint(numbers)]

write(f"You have a total of <{sum(points)}> points.")

# Store the resulting copies of the first iteration
copies = {}

for c_id, winning_numbers, numbers in cards:
    copies[c_id] = []
    amount_winning_numbers = len(numbers.intersection(winning_numbers))

    for i in range(c_id + 1, c_id + 1 + amount_winning_numbers, 1):
        copies[c_id].append(i)

# Compute the total amount of resulting cards
result_mapping = {}

for i in range(len(cards), 0, -1):
    result_mapping[i] = 1

    for c_id in copies[i]:
        result_mapping[i] += result_mapping[c_id]

write(f"You have a total of <{sum(result_mapping.values())}> cards.")
