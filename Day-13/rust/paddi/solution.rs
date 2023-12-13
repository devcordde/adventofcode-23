fn main() {
    let input = include_str!("./data/inputs/day_13.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::collections::HashSet;

fn rotate(pattern: Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut rotated_pattern = vec![vec![' '; pattern.len()]; pattern[0].len()];
    for (y, row) in pattern.into_iter().enumerate() {
        for (x, char) in row.into_iter().enumerate() {
            rotated_pattern[x][y] = char;
        }
    }
    rotated_pattern
}

fn get_reflection_index(pattern: &[Vec<char>]) -> HashSet<usize> {
    let mut tmp = HashSet::new();
    for (window_idx, two_rows) in pattern.windows(2).enumerate() {
        if two_rows[0] == two_rows[1] {
            let top_half = &pattern[..=window_idx];
            let bottom_half = &pattern[(window_idx + 1)..];
            if top_half.iter().rev().zip(bottom_half).all(|(t, b)| t == b) {
                tmp.insert(window_idx + 1);
            }
        }
    }
    tmp
}

pub fn part_a(input: &str) -> Option<usize> {
    let patterns: Vec<Vec<Vec<char>>> = input
        .split("\n\n")
        .map(|s| s.lines())
        .map(|p| p.map(|p| p.chars().collect()).collect())
        .collect();

    let mut row_sum = 0;
    for pattern in patterns.iter() {
        row_sum += get_reflection_index(pattern)
            .into_iter()
            .next()
            .unwrap_or(0);
    }

    let rotated_patterns = patterns.into_iter().map(rotate).collect::<Vec<_>>();
    let mut col_sum = 0;
    for rotated_pattern in rotated_patterns.iter() {
        col_sum += get_reflection_index(rotated_pattern)
            .into_iter()
            .next()
            .unwrap_or(0);
    }

    Some(col_sum + 100 * row_sum)
}

pub fn part_b(input: &str) -> Option<usize> {
    let patterns: Vec<Vec<Vec<char>>> = input
        .split("\n\n")
        .map(|s| s.lines())
        .map(|p| p.map(|p| p.chars().collect()).collect())
        .collect();

    let mut row_sum = 0;
    let mut col_sum = 0;
    for pattern in patterns.iter() {
        let original_row_reflection = get_reflection_index(pattern);
        let original_col_reflection = get_reflection_index(&rotate(pattern.clone()));

        let mut smudge_index = 0;

        while smudge_index < pattern.len() * pattern[0].len() {
            let y = smudge_index / pattern[0].len();
            let x = smudge_index % pattern[0].len();

            let mut smudged_mirror = pattern.clone();
            if smudged_mirror[y][x] == '.' {
                smudged_mirror[y][x] = '#';
            } else {
                smudged_mirror[y][x] = '.';
            }

            let mut new_row_reflection = get_reflection_index(&smudged_mirror);
            if let Some(orig_r) = original_row_reflection.iter().next() {
                new_row_reflection.insert(*orig_r);
            }

            if let Some(new_r) = original_row_reflection
                .symmetric_difference(&new_row_reflection)
                .next()
            {
                row_sum += new_r;
                break;
            }

            let mut new_col_reflection = get_reflection_index(&rotate(smudged_mirror));
            if let Some(orig_c) = original_col_reflection.iter().next() {
                new_col_reflection.insert(*orig_c);
            }
            if let Some(new_c) = original_col_reflection
                .symmetric_difference(&new_col_reflection)
                .next()
            {
                col_sum += new_c;
                break;
            }

            smudge_index += 1;
        }
    }

    Some(col_sum + 100 * row_sum)
}
