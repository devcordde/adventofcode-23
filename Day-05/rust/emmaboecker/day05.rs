use std::ops::RangeInclusive;

pub fn main() {
    let input = include_str!("input.txt");

    let mut input = input.split("\r\n\r\n");

    let seeds = input
        .next()
        .map(|seeds| {
            let seeds = seeds.split_once(": ").unwrap().1;
            seeds
                .split(' ')
                .map(|seed| seed.parse::<u64>().unwrap())
                .collect::<Vec<u64>>()
        })
        .unwrap();

    let mut rules: [Rule; 7] = Default::default();

    for (index, rule) in input.enumerate() {
        let ranges = rule.lines().skip(1);

        let mut ranges = ranges
            .map(|values| {
                let mut values = values.split(' ');

                let destination_range_start = values.next().unwrap().parse::<u64>().unwrap();
                let source_range_start = values.next().unwrap().parse::<u64>().unwrap();
                let range_length = values.next().unwrap().parse::<u64>().unwrap();

                (
                    destination_range_start..=destination_range_start + (range_length - 1),
                    source_range_start..=source_range_start + (range_length - 1),
                )
            })
            .collect::<Vec<_>>();

        ranges.sort_by(|a, b| a.0.start().cmp(b.0.start()));

        for (destination_range, source_range) in ranges {
            rules[index].source_ranges.push(source_range);
            rules[index].destination_ranges.push(destination_range);
        }
    }

    let part1 = seeds
        .iter()
        .flat_map(|seed| find_location(&rules, seed))
        .min();

    println!("Part 1: {}", part1.unwrap());

    let ranges = seeds
        .chunks(2)
        .map(|chunk| {
            let start = chunk[0];
            let length = chunk[1];
            start..(start + length)
        })
        .collect::<Vec<_>>();

    // let source_ranges = rules
    //     .iter()
    //     .map(|rule| rule.source_ranges.clone())
    //     .collect::<Vec<_>>();
    //
    // let seeds = source_ranges
    //     .iter()
    //     .enumerate()
    //     .flat_map(|(index, ranges)| {
    //         let rules = rules.clone();
    //         ranges.iter().map(move |range| {
    //             [
    //                 reverse_rule(&rules, 7 - (index + 1), range.start()),
    //                 reverse_rule(&rules, 7 - (index + 1), &(range.start() + 1)),
    //                 reverse_rule(&rules, 7 - (index + 1), range.end()),
    //                 reverse_rule(&rules, 7 - (index + 1), &(range.end() - 1)),
    //             ]
    //         })
    //     });
    //
    // let seeds = seeds
    //     .flatten()
    //     .filter(|location| ranges.iter().any(|range| range.contains(location)))
    //     .flat_map(|seed| find_location(&rules, &seed))
    //     .collect::<Vec<_>>();
    //
    // let seeds = [
    //     seeds,
    //     ranges
    //         .iter()
    //         .flat_map(|range| {
    //             [
    //                 find_location(&rules, &range.start),
    //                 find_location(&rules, &range.end),
    //             ]
    //         })
    //         .flatten()
    //         .collect::<Vec<_>>(),
    // ];
    //
    // let part2 = seeds.iter().flatten().min();

    // THE SOLUTION ABOVE WORKS ON TEST INPUT, BUT NOT THE REAL ONE, ITS PISSING ME OFF!!
    // println!("Part 2: {}", part2.unwrap());

    for i in 0_u64.. {
        let result = reverse_rule(&rules, 0, &i);
        if ranges.iter().any(|range| range.contains(&result)) {
            println!("Part 2: {}", i);
            break;
        }
    }
}

#[derive(Debug, Clone, Default)]
struct Rule {
    source_ranges: Vec<RangeInclusive<u64>>,
    destination_ranges: Vec<RangeInclusive<u64>>,
}

fn find_location(rules: &[Rule], seed: &u64) -> Vec<u64> {
    let location = rules.iter().fold(vec![*seed], |current, rule| {
        current
            .iter()
            .flat_map(|current| {
                let ranges = rule.source_ranges.clone();
                let mut ranges = ranges.iter().enumerate().collect::<Vec<_>>();

                ranges.retain(|(_, range)| range.contains(current));

                if ranges.is_empty() {
                    return vec![*current];
                }

                ranges
                    .iter()
                    .map(|(range_index, range)| {
                        let index = current - range.start();
                        rule.destination_ranges[*range_index]
                            .clone()
                            .nth(index as usize)
                            .unwrap()
                    })
                    .collect::<Vec<_>>()
            })
            .collect::<Vec<_>>()
    });
    location
}

fn reverse_rule(rules: &[Rule], skip: usize, element: &u64) -> u64 {
    let seed = rules
        .iter()
        .rev()
        .skip(skip)
        .fold(*element, |current, rule| {
            rule.destination_ranges
                .iter()
                .position(|range| range.contains(&current))
                .map(|range_index| {
                    let destination_range = rule.destination_ranges[range_index].clone();
                    let index = current - destination_range.start();
                    rule.source_ranges[range_index]
                        .clone()
                        .nth(index as usize)
                        .unwrap()
                })
                .unwrap_or(current)
        });
    seed
}
