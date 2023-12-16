fn main() {
    let input = include_str!("./data/inputs/day_16.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use itertools::Itertools;
use std::collections::HashSet;

#[derive(Copy, Clone, Eq, PartialEq, Hash, Debug)]
enum BeamDirection {
    North,
    East,
    South,
    West,
}

#[allow(dead_code)]
fn debug_grid(tiles: &[Vec<(char, HashSet<BeamDirection>)>]) {
    println!(
        "{}",
        tiles
            .iter()
            .map(|r| r
                .iter()
                .map(|t| {
                    if t.0 == 'x' {
                        String::from("")
                    } else if t.1.len() > 1 && t.0 == '.' {
                        format!("\x1b[102m{}\x1b[0m", t.1.len())
                    } else if t.1.len() == 1 && t.0 == '.' {
                        format!(
                            "\x1b[102m{}\x1b[0m",
                            match t.1.iter().next().unwrap() {
                                BeamDirection::North => "^",
                                BeamDirection::East => ">",
                                BeamDirection::South => "v",
                                BeamDirection::West => "<",
                            }
                        )
                    } else if !t.1.is_empty() {
                        format!("\x1b[102m{}\x1b[0m", t.0)
                    } else {
                        String::from(t.0)
                    }
                })
                .collect::<String>())
            .join("\n")
    );
}

impl From<BeamDirection> for isize {
    fn from(value: BeamDirection) -> Self {
        match value {
            BeamDirection::North => -1,
            BeamDirection::East => 1,
            BeamDirection::South => 1,
            BeamDirection::West => -1,
        }
    }
}

fn calculate_energized_tiles(
    tiles: &[Vec<(char, HashSet<BeamDirection>)>],
    start_tile: (usize, usize),
    start_direction: BeamDirection,
) -> usize {
    let mut tiles = tiles.to_owned();
    let mut beam_list = vec![(start_tile, start_direction)];
    while let Some(mut beam) = beam_list.pop() {
        while tiles[beam.0 .0][beam.0 .1].0 == '.' {
            tiles[beam.0 .0][beam.0 .1].1.insert(beam.1);
            match beam.1 {
                BeamDirection::North => beam.0 .0 -= 1,
                BeamDirection::East => beam.0 .1 += 1,
                BeamDirection::South => beam.0 .0 += 1,
                BeamDirection::West => beam.0 .1 -= 1,
            }
        }

        let non_empty_tile = &mut tiles[beam.0 .0][beam.0 .1];
        if non_empty_tile.1.contains(&beam.1) {
            continue;
        }

        match (non_empty_tile.0, beam.1) {
            ('x', _) => continue,
            ('-', BeamDirection::North) | ('-', BeamDirection::South) => {
                beam_list.push((beam.0, BeamDirection::West));
                beam_list.push((beam.0, BeamDirection::East));
            }
            ('|', BeamDirection::East) | ('|', BeamDirection::West) => {
                beam_list.push((beam.0, BeamDirection::North));
                beam_list.push((beam.0, BeamDirection::South));
            }
            ('/', bd) => {
                non_empty_tile.1.insert(bd);
                let new_tile = match bd {
                    BeamDirection::North | BeamDirection::South => {
                        (beam.0 .0, (beam.0 .1 as isize - isize::from(bd)) as usize)
                    }
                    BeamDirection::East | BeamDirection::West => {
                        ((beam.0 .0 as isize - isize::from(bd)) as usize, beam.0 .1)
                    }
                };
                match bd {
                    BeamDirection::North => beam_list.push((new_tile, BeamDirection::East)),
                    BeamDirection::East => beam_list.push((new_tile, BeamDirection::North)),
                    BeamDirection::South => beam_list.push((new_tile, BeamDirection::West)),
                    BeamDirection::West => beam_list.push((new_tile, BeamDirection::South)),
                }
            }
            ('\\', bd) => {
                non_empty_tile.1.insert(bd);
                let new_tile = match bd {
                    BeamDirection::North | BeamDirection::South => {
                        (beam.0 .0, (beam.0 .1 as isize + isize::from(bd)) as usize)
                    }
                    BeamDirection::East | BeamDirection::West => {
                        ((beam.0 .0 as isize + isize::from(bd)) as usize, beam.0 .1)
                    }
                };
                match bd {
                    BeamDirection::North => beam_list.push((new_tile, BeamDirection::West)),
                    BeamDirection::East => beam_list.push((new_tile, BeamDirection::South)),
                    BeamDirection::South => beam_list.push((new_tile, BeamDirection::East)),
                    BeamDirection::West => beam_list.push((new_tile, BeamDirection::North)),
                }
            }
            ('-', bd) => {
                non_empty_tile.1.insert(bd);
                beam.0 .1 = (beam.0 .1 as isize + isize::from(bd)) as usize;
                beam_list.push(beam);
            }
            ('|', bd) => {
                non_empty_tile.1.insert(bd);
                beam.0 .0 = (beam.0 .0 as isize + isize::from(bd)) as usize;
                beam_list.push(beam);
            }
            _ => unreachable!(),
        }
    }
    tiles
        .into_iter()
        .flatten()
        .filter(|tile| tile.0 != 'x' && !tile.1.is_empty())
        .count()
}

pub fn part_a(input: &str) -> Option<usize> {
    let mut tiles: Vec<Vec<(char, HashSet<BeamDirection>)>> = input
        .lines()
        .map(|p| p.chars().map(|c| (c, HashSet::new())).collect())
        .collect();

    let old_row_length = tiles[0].len();
    let bounding_row = vec![('x', HashSet::new()); old_row_length];
    tiles.insert(0, bounding_row.clone());
    tiles.push(bounding_row);
    tiles.iter_mut().for_each(|r| {
        r.insert(0, ('x', HashSet::new()));
        r.push(('x', HashSet::new()));
    });

    Some(calculate_energized_tiles(
        &tiles,
        (1, 1),
        BeamDirection::East,
    ))
}

pub fn part_b(input: &str) -> Option<usize> {
    let mut tiles: Vec<Vec<(char, HashSet<BeamDirection>)>> = input
        .lines()
        .map(|p| p.chars().map(|c| (c, HashSet::new())).collect())
        .collect();

    let old_row_length = tiles[0].len();
    let bounding_row = vec![('x', HashSet::new()); old_row_length];
    tiles.insert(0, bounding_row.clone());
    tiles.push(bounding_row);
    tiles.iter_mut().for_each(|r| {
        r.insert(0, ('x', HashSet::new()));
        r.push(('x', HashSet::new()));
    });

    let mut initial_configs = vec![];
    (1..tiles.len() - 1).for_each(|i| {
        initial_configs.push(((i, 1), BeamDirection::East));
        initial_configs.push(((i, tiles[0].len() - 2), BeamDirection::West));
    });

    (1..tiles[0].len() - 1).for_each(|i| {
        initial_configs.push(((1, i), BeamDirection::South));
        initial_configs.push(((tiles.len() - 2, i), BeamDirection::North));
    });

    initial_configs
        .into_iter()
        .map(|cfg| calculate_energized_tiles(&tiles, cfg.0, cfg.1))
        .max()
}
