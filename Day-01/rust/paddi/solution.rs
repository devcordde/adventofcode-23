use std::collections::HashMap;
use std::str::FromStr;

fn main() {
    let input = include_str!("input.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

pub fn part_a(input: &str) -> Option<u32> {
    Some(
        input
            .lines()
            .map(|l| {
                u32::from_str(&format!(
                    "{}{}",
                    l.chars().nth(l.find(char::is_numeric).unwrap()).unwrap(),
                    l.chars().nth(l.rfind(char::is_numeric).unwrap()).unwrap()
                ))
                .unwrap()
            })
            .sum(),
    )
}

pub fn part_b(input: &str) -> Option<u32> {
    let digits = HashMap::from([
        ("one", "1"),
        ("two", "2"),
        ("three", "3"),
        ("four", "4"),
        ("five", "5"),
        ("six", "6"),
        ("seven", "7"),
        ("eight", "8"),
        ("nine", "9"),
    ]);

    let two_digit_combos = HashMap::from([
        ("oneight", "18"),
        ("twone", "21"),
        ("threight", "38"),
        ("fiveight", "58"),
        ("sevenine", "79"),
        ("eightwo", "82"),
        ("eighthree", "83"),
        ("nineight", "98"),
    ]);

    Some(
        input
            .lines()
            .map(|l| {
                let mut l = l.to_string();
                for d in &two_digit_combos {
                    l = l.replace(d.0, d.1);
                }
                l
            })
            .map(|l| {
                let mut l = l.to_string();
                for d in &digits {
                    l = l.replace(d.0, d.1);
                }
                l
            })
            .map(|l| {
                u32::from_str(&format!(
                    "{}{}",
                    l.chars().nth(l.find(char::is_numeric).unwrap()).unwrap(),
                    l.chars().nth(l.rfind(char::is_numeric).unwrap()).unwrap()
                ))
                .unwrap()
            })
            .sum(),
    )
}
