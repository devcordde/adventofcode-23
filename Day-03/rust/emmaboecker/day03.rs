use std::ops::RangeInclusive;

pub fn main() {
    let input: Vec<Vec<char>> = include_str!("input.txt")
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    let max_index = input.len() - 1;

    let mut numbers = Vec::new();

    for (row, chars) in input.iter().enumerate() {
        let mut peekable = chars.iter().enumerate().peekable();
        while let Some((column, char)) = peekable.next() {
            let mut number: u32 = 0;
            let mut range = column..=column;
            if char.is_ascii_digit() {
                number = (*char as u8 - b'0') as u32;
                while peekable.peek().is_some() && peekable.peek().unwrap().1.is_ascii_digit() {
                    let current = peekable.next().unwrap();
                    number = number * 10 + (*current.1 as u8 - b'0') as u32;
                    range = column..=current.0;
                }
            } else if number == 0 {
                continue;
            }

            let position = Position {
                row: row..=row,
                column: range,
            };
            let mut adjacent = false;

            let surrounding = get_surrounding_positions(&position, max_index);
            for row in surrounding.row {
                for column in surrounding.column.clone() {
                    let current = input[row][column];
                    if current.is_symbol() {
                        adjacent = true;
                    }
                }
            }
            numbers.push((number as usize, position, adjacent));
        }
    }

    let part1: usize = numbers
        .iter()
        .filter(|(_, _, adjacent)| *adjacent)
        .map(|(number, _, _)| number)
        .sum();

    println!("Part 1: {}", part1);

    let mut part2 = 0;

    for (row, chars) in input.iter().enumerate() {
        for (column, char) in chars.iter().enumerate() {
            if *char == '*' {
                let surrounding = get_surrounding_positions(
                    &Position {
                        row: row..=row,
                        column: column..=column,
                    },
                    max_index,
                );

                let mut amount = 0;
                let mut result = 1;

                for (number, position, _) in numbers.iter() {
                    if (surrounding.row.contains(position.row.start())
                        || surrounding.row.contains(position.row.end()))
                        && (surrounding.column.contains(position.column.start())
                            || surrounding.column.contains(position.column.end()))
                    {
                        amount += 1;
                        result *= number;
                    }
                }

                if amount == 2 {
                    part2 += result;
                }
            }
        }
    }

    println!("Part 2: {}", part2);
}

fn get_surrounding_positions(position: &Position, max_index: usize) -> Position {
    Position {
        row: ((*position.row.start() as isize) - 1).max(0) as usize
            ..=(position.row.end() + 1).min(max_index),
        column: ((*position.column.start() as isize) - 1).max(0) as usize
            ..=(position.column.end() + 1).min(max_index),
    }
}

trait IsSymbol {
    fn is_symbol(&self) -> bool;
}

impl IsSymbol for char {
    fn is_symbol(&self) -> bool {
        *self != '.' && self.is_ascii() && !self.is_ascii_digit()
    }
}

#[derive(Hash, Eq, PartialEq, Debug, Clone)]
struct Position {
    pub row: RangeInclusive<usize>,
    pub column: RangeInclusive<usize>,
}
