pub fn main() {
    let input = include_str!("../../input/day09.txt").lines();

    let numbers = input
        .map(|line| {
            let history = line
                .split_whitespace()
                .map(|word| word.parse::<i64>().unwrap())
                .collect::<Vec<_>>();

            let mut numbers = vec![history];

            while numbers.last().unwrap().iter().any(|number| *number != 0) {
                numbers.push(
                    numbers
                        .last()
                        .unwrap()
                        .windows(2)
                        .map(|window| {
                            let (a, b) = (window[0], window[1]);
                            b - a
                        })
                        .collect(),
                )
            }

            numbers.iter().rev().fold((0, 0), |acc, number| {
                (
                    number.first().unwrap() - acc.0,
                    acc.1 + number.last().unwrap(),
                )
            })
        })
        .collect::<Vec<_>>();

    println!(
        "Part 1: {}",
        numbers.iter().map(|(_, last)| last).sum::<i64>()
    );
    println!(
        "Part 2: {}",
        numbers.iter().map(|(first, _)| first).sum::<i64>()
    );
}
