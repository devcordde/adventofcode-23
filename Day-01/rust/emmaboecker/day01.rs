use std::collections::HashMap;

fn main() {
    let input = include_str!("../../input/day01.txt");

    println!("Part 1: {}", find_numbers(input, false));

    println!("Part 2: {}", find_numbers(input, true));
}

fn find_numbers(input: &str, written: bool) -> u32 {
    let output = input
        .lines()
        .map(|line| {
            let valid = find_valid(line, written);
            format!("{}{}", valid.first().unwrap(), valid.last().unwrap())
        })
        .collect::<Vec<String>>();

    output
        .iter()
        .map(|string| string.parse::<u32>().unwrap())
        .sum::<u32>()
}

fn find_valid(input: &str, written: bool) -> Vec<u32> {
    let mut valid = vec![];

    if written {
        let written_numbers = HashMap::from([
            ("one", 1),
            ("two", 2),
            ("three", 3),
            ("four", 4),
            ("five", 5),
            ("six", 6),
            ("seven", 7),
            ("eight", 8),
            ("nine", 9),
        ]);

        for (written, value) in written_numbers {
            let indices = input.match_indices(written);

            for (index, _) in indices {
                valid.push((index, value));
            }
        }
    }

    for value in 1..10 {
        let string_value = value.to_string();
        let indices = input.match_indices(&string_value);

        for (index, _) in indices {
            valid.push((index, value));
        }
    }

    valid.sort_by(|a, b| a.0.cmp(&b.0));
    valid
        .into_iter()
        .map(|(_, value)| value)
        .collect::<Vec<u32>>()
}
