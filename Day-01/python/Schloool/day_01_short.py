input = open('input.txt').readlines()
number_words = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']


def num_from(line: str, i: int, words: bool):
    num_from_word = next((str(number_words.index(w) + 1) for w in number_words if line[i:].startswith(w)), None)
    return line[i] if line[i].isnumeric() else None if not words else num_from_word


def get_num_pairs(words: bool) -> list[int]:
    return [int(n[0] + n[-1]) for n in [[n for n in [num_from(l, i, words) for i in range(len(l))] if n] for l in input]]


# Part 1
print(sum(get_num_pairs(False)))

# Part 2
print(sum(get_num_pairs(True)))
