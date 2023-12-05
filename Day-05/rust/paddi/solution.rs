use std::ops::Range;
fn main() {
    let input = include_str!("input.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

pub fn part_a(input: &str) -> Option<u64> {
    let mut split = input.split("\n\n");
    let mut seeds: Vec<u64> = split
        .next()
        .unwrap()
        .strip_prefix("seeds: ")
        .unwrap()
        .split_whitespace()
        .map(|seed| seed.parse().unwrap())
        .collect();
    let maps: Vec<Vec<(Range<u64>, Range<u64>)>> = split
        .map(|map| {
            map.lines()
                .skip(1)
                .map(|range| {
                    let nums = range
                        .split_whitespace()
                        .map(|num| num.parse().unwrap())
                        .collect::<Vec<u64>>();
                    (nums[1]..(nums[1] + nums[2]), nums[0]..(nums[0] + nums[2]))
                })
                .collect::<Vec<(Range<u64>, Range<u64>)>>()
        })
        .collect();

    for map in maps {
        for seed in seeds.iter_mut() {
            *seed = map
                .iter()
                .find_map(|m| {
                    if m.0.start <= *seed && m.0.end > *seed {
                        Some(m.1.start + *seed - m.0.start)
                    } else {
                        None
                    }
                })
                .unwrap_or(*seed);
        }
    }

    seeds.iter().min().copied()
}

// This part of today's puzzle is proudly presented to you by your CPU
pub fn part_b(input: &str) -> Option<u64> {
    let mut split = input.split("\n\n");
    let seed_ranges: Vec<u64> = split
        .next()
        .unwrap()
        .strip_prefix("seeds: ")
        .unwrap()
        .split_whitespace()
        .map(|seed| seed.parse().unwrap())
        .collect();
    let maps: Vec<Vec<(Range<u64>, Range<u64>)>> = split
        .map(|map| {
            map.lines()
                .skip(1)
                .map(|range| {
                    let nums = range
                        .split_whitespace()
                        .map(|num| num.parse().unwrap())
                        .collect::<Vec<u64>>();
                    (nums[1]..(nums[1] + nums[2]), nums[0]..(nums[0] + nums[2]))
                })
                .collect::<Vec<(Range<u64>, Range<u64>)>>()
        })
        .collect();

    let mut lowest_loc = u64::MAX;
    for pair in seed_ranges.chunks(2) {
        let mut seeds: Vec<u64> = (pair[0]..(pair[0] + pair[1])).collect();

        for map in maps.iter() {
            for seed in seeds.iter_mut() {
                *seed = map
                    .iter()
                    .find_map(|m| {
                        if m.0.start <= *seed && m.0.end > *seed {
                            Some(m.1.start + *seed - m.0.start)
                        } else {
                            None
                        }
                    })
                    .unwrap_or(*seed);
            }
        }
        lowest_loc = lowest_loc.min(*seeds.iter().min().unwrap())
    }

    Some(lowest_loc)
}
