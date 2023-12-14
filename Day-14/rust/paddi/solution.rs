fn main() {
    let input = include_str!("./data/inputs/day_14.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::collections::HashMap;

fn rotate90(pattern: Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut rotated_pattern = vec![vec![' '; pattern.len()]; pattern[0].len()];
    for (y, row) in pattern.into_iter().enumerate() {
        for (x, char) in row.into_iter().enumerate() {
            rotated_pattern[x][y] = char;
        }
    }
    rotated_pattern
        .into_iter()
        .map(|r| r.into_iter().rev().collect())
        .collect()
}

fn shift_up(platform: &mut Vec<Vec<char>>) {
    for y in 0..platform.len() {
        for x in 0..platform[0].len() {
            let mut shift = 0;
            while platform[y - shift][x] == 'O' && platform[y - shift - 1][x] == '.' {
                platform[y - shift][x] = '.';
                platform[y - shift - 1][x] = 'O';
                shift += 1;
            }
        }
    }
}

fn shift_cycle(platform: Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut north = platform.clone();
    shift_up(&mut north);

    let mut west = rotate90(north);
    shift_up(&mut west);

    let mut south = rotate90(west);
    shift_up(&mut south);

    let mut east = rotate90(south);
    shift_up(&mut east);

    rotate90(east)
}

pub fn part_a(input: &str) -> Option<usize> {
    let mut platform: Vec<Vec<char>> = input.lines().map(|p| p.chars().collect()).collect();

    let mut load = 0;
    platform.insert(0, vec!['x'; platform[0].len()]);
    shift_up(&mut platform);
    for (y, line) in platform.iter().enumerate() {
        load += (platform.len() - y) * line.iter().filter(|&c| c == &'O').count();
    }

    Some(load)
}

fn shift_until_repeat(platform: &[Vec<char>]) -> (usize, usize) {
    let mut platform = platform.to_owned();
    let mut seen_platforms = HashMap::new();
    seen_platforms.insert(platform.clone(), 0);
    for i in 1..=1_000_000_000 {
        platform = shift_cycle(platform);
        if seen_platforms.contains_key(&platform) {
            return (i, *seen_platforms.get(&platform).unwrap());
        }
        seen_platforms.insert(platform.clone(), i);
    }
    unreachable!()
}

pub fn part_b(input: &str) -> Option<usize> {
    let mut platform: Vec<Vec<char>> = input.lines().map(|p| p.chars().collect()).collect();

    let old_row_length = platform[0].len();
    let bounding_row = vec!['x'; old_row_length];
    platform.insert(0, bounding_row.clone());
    platform.push(bounding_row);
    platform.iter_mut().for_each(|r| {
        r.insert(0, 'x');
        r.push('x');
    });

    let mut load = 0;
    let mut platform = platform.clone();
    let (n, k) = shift_until_repeat(&platform);
    let j = 1000000000;
    let x = (j - n) / (n - k);
    for _ in 0..j - (x * (n - k)) {
        platform = shift_cycle(platform);
    }

    platform.remove(platform.len() - 1);
    for (y, line) in platform.iter().enumerate() {
        load += (platform.len() - y) * line.iter().filter(|&c| c == &'O').count();
    }

    Some(load)
}
