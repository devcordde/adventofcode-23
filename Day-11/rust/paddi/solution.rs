fn main() {
    let input = include_str!("./data/inputs/day_11.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use itertools::Itertools;

fn expand(sky: &mut Vec<Vec<char>>) {
    let mut empty_rows = Vec::new();
    for (y, row) in sky.iter().enumerate() {
        if row.iter().all(|o| o == &'.') {
            empty_rows.push(y);
        }
    }
    for (i, y) in empty_rows.iter().enumerate() {
        sky.insert(i + y, sky[i + y].clone());
    }
}

fn get_empty_rows(sky: &[Vec<char>]) -> Vec<usize> {
    let mut empty_rows = Vec::new();
    for (y, row) in sky.iter().enumerate() {
        if row.iter().all(|o| o == &'.') {
            empty_rows.push(y);
        }
    }
    empty_rows
}

fn rotate(sky: Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut rotated_sky = vec![vec![' '; sky.len()]; sky[0].len()];
    for (y, row) in sky.into_iter().enumerate() {
        for (x, char) in row.into_iter().enumerate() {
            rotated_sky[x][y] = char;
        }
    }
    rotated_sky
}

pub fn part_a(input: &str) -> Option<u32> {
    let mut sky: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();
    expand(&mut sky);

    let mut rotated_sky = rotate(sky);
    expand(&mut rotated_sky);

    sky = rotate(rotated_sky);

    let mut stars = vec![];
    for (y, row) in sky.iter().enumerate() {
        for (x, char) in row.iter().enumerate() {
            if char == &'#' {
                stars.push((x as isize, y as isize));
            }
        }
    }

    Some(
        stars
            .iter()
            .combinations(2)
            .map(|c| ((c[0].0 - c[1].0).abs() + (c[0].1 - c[1].1).abs()) as u32)
            .sum(),
    )
}

pub fn part_b(input: &str) -> Option<usize> {
    let mut sky: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();
    let empty_rows = get_empty_rows(&sky);

    let rotated_sky = rotate(sky);
    let empty_cols = get_empty_rows(&rotated_sky);

    sky = rotate(rotated_sky);

    let mut stars = vec![];
    for (y, row) in sky.iter().enumerate() {
        for (x, char) in row.iter().enumerate() {
            if char == &'#' {
                stars.push((x as isize, y as isize));
            }
        }
    }

    let mut distance = 0;
    let n = 1_000_000;
    for pair in stars.iter().combinations(2) {
        let empty_rows_between = empty_cols
            .iter()
            .filter(|&&r| {
                (r < pair[0].0 as usize && r > pair[1].0 as usize)
                    || (r < pair[1].0 as usize && r > pair[0].0 as usize)
            })
            .count();

        let empty_cols_between = empty_rows
            .iter()
            .filter(|&&r| {
                (r < pair[0].1 as usize && r > pair[1].1 as usize)
                    || (r < pair[1].1 as usize && r > pair[0].1 as usize)
            })
            .count();

        distance += (pair[0].0 - pair[1].0).unsigned_abs() + (n - 1) * empty_rows_between;
        distance += (pair[0].1 - pair[1].1).unsigned_abs() + (n - 1) * empty_cols_between;
    }

    Some(distance)
}
