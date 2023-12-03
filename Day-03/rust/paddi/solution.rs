fn main() {
    let input = include_str!("input.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

fn read_number(schematic: &[Vec<char>], col_index: usize, row_index: usize) -> (u32, usize) {
    let mut begin_row_index = row_index;
    let mut digit_vec = vec![];

    if !schematic
        .get(col_index)
        .unwrap()
        .get(row_index)
        .unwrap()
        .is_ascii_digit()
    {
        return (0, row_index);
    }

    while schematic
        .get(col_index)
        .unwrap()
        .get(begin_row_index)
        .unwrap()
        .is_ascii_digit()
    {
        begin_row_index -= 1;
    }
    begin_row_index += 1;

    let mut end_row_index = begin_row_index;
    while let Some(digit) = schematic
        .get(col_index)
        .unwrap()
        .get(end_row_index)
        .unwrap()
        .to_digit(10)
    {
        digit_vec.push(digit);
        end_row_index += 1;
    }
    end_row_index -= 1;

    (
        digit_vec.iter().fold(0, |acc, digit| acc * 10 + digit),
        end_row_index,
    )
}

pub fn part_a(input: &str) -> Option<u32> {
    let mut schematic: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();
    let old_row_length = schematic[0].len();
    let bounding_row = vec!['.'; old_row_length];
    schematic.insert(0, bounding_row.clone());
    schematic.push(bounding_row);
    schematic.iter_mut().for_each(|r| {
        r.insert(0, '.');
        r.push('.');
    });

    let mut engine_number_sum = 0;
    for (col_index, col) in schematic.iter().enumerate() {
        for (row_index, item) in col.iter().enumerate() {
            if item != &'.' && !item.is_ascii_digit() {
                for col_diff in [-1, 0, 1] {
                    let mut begin_row_index = row_index - 1;
                    while [-1, 0, 1].contains(&(begin_row_index as isize - row_index as isize)) {
                        let (number, last_index) = read_number(
                            &schematic,
                            (col_index as isize + col_diff) as usize,
                            begin_row_index,
                        );
                        if number == 0 {
                            begin_row_index = last_index + 1;
                        } else {
                            begin_row_index = last_index + 2;
                            engine_number_sum += number;
                        }
                    }
                }
            }
        }
    }
    Some(engine_number_sum)
}

pub fn part_b(input: &str) -> Option<u32> {
    let mut schematic: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();
    let old_row_length = schematic[0].len();
    let bounding_row = vec!['.'; old_row_length];
    schematic.insert(0, bounding_row.clone());
    schematic.push(bounding_row);
    schematic.iter_mut().for_each(|r| {
        r.insert(0, '.');
        r.push('.');
    });

    let mut gear_ratio_sum = 0;
    for (col_index, col) in schematic.iter().enumerate() {
        for (row_index, item) in col.iter().enumerate() {
            if item == &'*' {
                let mut numbers = vec![];
                for col_diff in [-1, 0, 1] {
                    let mut begin_row_index = row_index - 1;
                    while [-1, 0, 1].contains(&(begin_row_index as isize - row_index as isize)) {
                        let (number, last_index) = read_number(
                            &schematic,
                            (col_index as isize + col_diff) as usize,
                            begin_row_index,
                        );
                        if number == 0 {
                            begin_row_index = last_index + 1;
                        } else {
                            begin_row_index = last_index + 2;
                            numbers.push(number);
                        }
                    }
                }
                if numbers.len() == 2 {
                    gear_ratio_sum += numbers[0] * numbers[1];
                }
            }
        }
    }
    Some(gear_ratio_sum)
}
