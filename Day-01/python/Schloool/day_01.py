input = open('input.txt').readlines()

letters = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9
}


def get_max_number_string_from_index(line: str, index: int, account_number_words: bool):
    if line[index].isnumeric():
        return line[index]

    if not account_number_words:
        return None

    for key in reversed(letters.keys()):
        if len(key) > len(line) - index:
            continue
        if line[index:(index + len(key))] == key:
            return str(letters[key])
    return None


def get_num_pairs(account_number_words: bool) -> list[int]:
    nums = []
    for line in input:
        first = last = None
        i = 0

        while first is None:
            first = get_max_number_string_from_index(line, i, account_number_words)
            i += 1 if first is None else 0

        for j in range(i, len(line)):
            found_num_string = get_max_number_string_from_index(line, j, account_number_words)
            last = found_num_string if found_num_string is not None else last

        nums.append(int(first + last))
    return nums


# Part 1
print(sum(get_num_pairs(False)))

# Part 2
print(sum(get_num_pairs(True)))

