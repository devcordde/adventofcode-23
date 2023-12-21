fn main() {
    let input = include_str!("./data/inputs/day_21.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::collections::{HashSet, VecDeque};

pub fn part_a(input: &str) -> Option<usize> {
    let mut garden_map: Vec<Vec<(char, HashSet<u64>)>> = input
        .lines()
        .map(|l| l.chars().map(|c| (c, HashSet::new())).collect())
        .collect();
    let old_row_length = garden_map[0].len();
    let bounding_row = vec![('#', HashSet::new()); old_row_length];
    garden_map.insert(0, bounding_row.clone());
    garden_map.push(bounding_row);
    garden_map.iter_mut().for_each(|r| {
        r.insert(0, ('#', HashSet::new()));
        r.push(('#', HashSet::new()));
    });

    let y_start = garden_map
        .iter()
        .position(|r| r.iter().any(|c| c.0 == 'S'))
        .unwrap();
    let x_start = garden_map[y_start].iter().position(|c| c.0 == 'S').unwrap();

    garden_map[y_start][x_start].1.insert(0);

    let mut queue = VecDeque::from([(y_start, x_start)]);
    while let Some(current_position) = queue.pop_front() {
        let neighbor_positions = [
            (current_position.0 - 1, current_position.1),
            (current_position.0 + 1, current_position.1),
            (current_position.0, current_position.1 + 1),
            (current_position.0, current_position.1 - 1),
        ]
        .into_iter()
        .filter(|pos| garden_map[pos.0][pos.1].0 != '#')
        .collect::<Vec<_>>();

        for neigbor_position in neighbor_positions {
            let modified_own_step_list = garden_map[current_position.0][current_position.1]
                .1
                .clone()
                .into_iter()
                .filter_map(|dst| if dst < 64 { Some(dst + 1) } else { None })
                .collect::<HashSet<_>>();

            let current_neighbor_step_list = &garden_map[neigbor_position.0][neigbor_position.1].1;
            if !modified_own_step_list.is_subset(current_neighbor_step_list) {
                garden_map[neigbor_position.0][neigbor_position.1]
                    .1
                    .extend(modified_own_step_list.iter());
                queue.push_back(neigbor_position);
            }
        }
    }

    Some(
        garden_map
            .into_iter()
            .flatten()
            .filter(|pos| pos.1.contains(&64))
            .count(),
    )
}

pub fn part_b(_input: &str) -> Option<u64> {
    None
}
