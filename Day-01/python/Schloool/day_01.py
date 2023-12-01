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


def get_max_number_from_index(line, index, account_number_words):
    if line[index].isnumeric():
        return line[index]

    if not account_number_words:
        return None

    for key in reversed(letters.keys()):
        if len(key) > len(line) - index:
            continue
        if line[index:(index + len(key))] == key:
            return letters[key]
    return None


def get_num_pair(account_number_words):
    nums = []
    for line in input:
        first, last = None, None
        i = 0

        while first is None:
            first = get_max_number_from_index(line, i, account_number_words)
            i += 1 if first is None else 0

        for j in range(i, len(line)):
            found_num = get_max_number_from_index(line, j, account_number_words)
            last = str(found_num) if found_num is not None else last

        nums.append(int(str(first) + last))
    return nums


# Task 1
print(sum(get_num_pair(False)))

# Task 2
print(sum(get_num_pair(True)))

