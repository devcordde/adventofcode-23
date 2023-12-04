use std::collections::{HashMap, HashSet};
fn main() {
    let input = include_str!("input.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

pub fn part_a(input: &str) -> Option<u32> {
    let lines = input.lines();
    let mut points = 0;
    for line in lines {
        let mut card_split = line.split(": ");
        card_split.next().unwrap();
        let (winning_numbers, card_numbers) = card_split.next().unwrap().split_once(" | ").unwrap();
        let winning_numbers: HashSet<&str> = winning_numbers.split(' ').collect();
        let card_numbers: HashSet<&str> = card_numbers.split_ascii_whitespace().collect();
        let win_count = winning_numbers.intersection(&card_numbers).count();
        if win_count > 0 {
            points += 2_u32.pow(win_count as u32 - 1);
        }
    }
    Some(points)
}

pub fn part_b(input: &str) -> Option<u32> {
    let lines = input.lines();
    let mut cards = HashMap::new();
    for (card_id, line) in lines.enumerate() {
        let card_id = card_id + 1;
        cards.entry(card_id).and_modify(|v| *v += 1).or_insert(1);
        let mut card_split = line.split(": ");
        card_split.next().unwrap();
        let (winning_numbers, card_numbers) = card_split.next().unwrap().split_once(" | ").unwrap();
        let winning_numbers: HashSet<&str> = winning_numbers.split(' ').collect();
        let card_numbers: HashSet<&str> = card_numbers.split_ascii_whitespace().collect();
        let win_count = winning_numbers.intersection(&card_numbers).count();
        for i in (card_id + 1)..(card_id + win_count + 1) {
            let current_card_count = *cards.get(&card_id).unwrap();
            cards
                .entry(i)
                .and_modify(|v| *v += current_card_count)
                .or_insert(current_card_count);
        }
    }
    Some(cards.values().sum())
}
