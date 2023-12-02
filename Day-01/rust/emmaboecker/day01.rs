const WRITTEN_NUMBERS: [&str; 9] = [
    "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
];

pub fn main() {
    let input = include_str!("../../input/day01.txt");
    println!("Part 1: {}", find_numbers(input, false));
    println!("Part 2: {}", find_numbers(input, true));
}

fn find_numbers(input: &str, written: bool) -> u32 {
    input
        .lines()
        .map(|line| {
            let valid = find_valid(line, written);
            format!("{}{}", valid.first().unwrap(), valid.last().unwrap())
                .parse()
                .unwrap()
        })
        .collect::<Vec<u32>>()
        .iter()
        .sum()
}

fn find_valid(input: &str, written: bool) -> Vec<u32> {
    let mut valid = vec![];

    if written {
        for (index, written) in WRITTEN_NUMBERS.iter().enumerate() {
            let indices = input.match_indices(written);

            for (position, _) in indices {
                valid.push((position, index + 1));
            }
        }
    }

    for value in 1..10 {
        let indices = input.match_indices((value as u8 + b'0') as char);

        for (index, _) in indices {
            valid.push((index, value));
        }
    }

    valid.sort_by(|a, b| a.0.cmp(&b.0));
    valid
        .into_iter()
        .map(|(_, value)| value as u32)
        .collect::<Vec<u32>>()
}