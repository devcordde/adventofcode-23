input = open('input.txt').readlines()

num_slice_coordinates, symbol_coordinates = [], []
for line_index in range(len(input)):
    line_length = len(input[line_index])
    for char_index in range(line_length):
        char = input[line_index][char_index]
        if char == '.' or char == '\n':
            continue
        elif not char.isnumeric():
            symbol_coordinates.append((line_index, char_index))
        else:
            start_index = char_index
            while char_index <= line_length - 1 and (input[line_index][char_index + 1]).isnumeric():
                char_index += 1
            if not any([i for i in num_slice_coordinates if i[0] == line_index and i[1][1] == char_index]):
                num_slice_coordinates.append((line_index, (start_index, char_index)))


def get_adjacent_coordinates_for(c):
    return [(x, y) for x in range(c[0] - 1, c[0] + 2) for y in range(c[1] - 1, c[1] + 2) if x >= 0 and y >= 0]


def has_adjacent_symbol(c):
    for x in range(c[1][0], c[1][1] + 1):
        adjacent = get_adjacent_coordinates_for((c[0], x))
        if any([c for c in adjacent if c in symbol_coordinates]):
            return True
    return False


def get_num_from_slice(slice):
    return int(input[slice[0]][slice[1][0]:slice[1][1] + 1])


nums_with_adjacent = []
for coordinate in num_slice_coordinates:
    if has_adjacent_symbol(coordinate):
        nums_with_adjacent.append(get_num_from_slice(coordinate))

# Part 1
print(sum(nums_with_adjacent))

gear_coordinates = [c for c in symbol_coordinates if input[c[0]][c[1]] == '*']
num_coordinate_map = {}
for coordinate in num_slice_coordinates:
    for y in range(coordinate[1][0], coordinate[1][1] + 1):
        num_coordinate_map[(coordinate[0], y)] = coordinate

gear_ratios = []
for coordinate in gear_coordinates:
    adjacent = get_adjacent_coordinates_for(coordinate)
    adjacent_nums = list(set([num_coordinate_map[c] for c in num_coordinate_map.keys() if c in adjacent]))
    if len(adjacent_nums) == 2:
        gear_ratios.append(get_num_from_slice(adjacent_nums[0]) * get_num_from_slice(adjacent_nums[1]))

# Part 2
print(sum(gear_ratios))
