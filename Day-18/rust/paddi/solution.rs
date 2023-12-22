fn main() {
    let input = include_str!("./data/inputs/day_18.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::collections::HashSet;

fn floodfill(pos: (isize, isize), boundary: &HashSet<(isize, isize)>) -> HashSet<(isize, isize)> {
    let mut filled = boundary.clone();
    let mut stack = Vec::new();
    stack.push(pos);

    while let Some((y, x)) = stack.pop() {
        if !filled.contains(&(y, x)) {
            filled.insert((y, x));
            stack.push((y, x + 1));
            stack.push((y, x - 1));
            stack.push((y + 1, x));
            stack.push((y - 1, x));
        }
    }

    filled
}

pub fn part_a(input: &str) -> Option<usize> {
    let instructions: Vec<(char, isize)> = input
        .lines()
        .map(|line| {
            let mut i = line.split_whitespace().take(2);
            (
                i.next().unwrap().chars().next().unwrap(),
                i.next().unwrap().parse().unwrap(),
            )
        })
        .collect();

    let mut current_coord = (0, 0);
    let mut coords = HashSet::from([current_coord]);

    for instruction in instructions {
        for _ in 0..instruction.1 {
            match instruction.0 {
                'U' => {
                    current_coord.0 -= 1;
                }
                'D' => {
                    current_coord.0 += 1;
                }
                'L' => {
                    current_coord.1 -= 1;
                }
                'R' => {
                    current_coord.1 += 1;
                }
                _ => unreachable!(),
            }
            coords.insert(current_coord);
        }
    }

    let mut interior = *coords
        .iter()
        .find(|c1| {
            coords
                .iter()
                .filter(|c2| c1.0 == c2.0)
                .all(|c2| c2.1 <= c1.1 && c2.1 != c1.1 - 1)
        })
        .unwrap();
    interior.1 -= 1;

    Some(floodfill(interior, &coords).len())
}

pub fn part_b(input: &str) -> Option<isize> {
    let instructions: Vec<(char, isize)> = input
        .lines()
        .map(|line| {
            let i = line.split('#').last().unwrap().strip_suffix(')').unwrap();
            let l = isize::from_str_radix(&i[..5], 16).unwrap();
            let c = &i[5..];

            match c {
                "0" => ('R', l),
                "1" => ('D', l),
                "2" => ('L', l),
                "3" => ('U', l),
                _ => unreachable!("{}", c),
            }
        })
        .collect();

    let mut current_coord = (0, 0);
    let mut coords = vec![current_coord];

    let mut perimeter_sum = 0;
    for instruction in instructions {
        perimeter_sum += instruction.1;
        match instruction.0 {
            'U' => {
                current_coord.0 -= instruction.1;
            }
            'D' => {
                current_coord.0 += instruction.1;
            }
            'L' => {
                current_coord.1 -= instruction.1;
            }
            'R' => {
                current_coord.1 += instruction.1;
            }
            _ => unreachable!(),
        }
        coords.push(current_coord);
    }

    let shoelace = coords
        .windows(2)
        .map(|w| (w[0].1 * w[1].0 - w[1].1 * w[0].0))
        .sum::<isize>();
    Some(shoelace / 2 + perimeter_sum / 2 + 1)
}
