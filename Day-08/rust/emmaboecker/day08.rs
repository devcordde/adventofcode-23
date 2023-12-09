use std::collections::HashMap;
use std::hash::Hash;

pub fn main() {
    let mut input = include_str!("input.txt").lines();

    let instructions = input.next().unwrap().chars();

    let nodes = input
        .skip(1)
        .map(|line| {
            let (name, links) = line.split_once(" = ").unwrap();
            let (left, right) = links.split_once(", ").unwrap();
            let left = left.strip_prefix("(").unwrap();
            let right = right.strip_suffix(")").unwrap();

            (name, left, right)
        })
        .fold(HashMap::new(), |mut nodes, (name, left, right)| {
            nodes.insert(name, (left, right));
            nodes
        });

    let mut current_node = nodes["AAA"];
    let mut steps: u32 = 0;

    for instruction in instructions.clone().cycle() {
        let next = match instruction {
            'R' => {
                let right = current_node.1;
                current_node = nodes[right];
                right
            }
            'L' => {
                let left = current_node.0;
                current_node = nodes[left];
                left
            }
            _ => unreachable!("Invalid instruction"),
        };

        steps += 1;

        if next == "ZZZ" {
            println!("Part 1: {}", steps);
            break;
        }
    }

    let mut current_nodes = nodes
        .iter()
        .filter(|(name, _)| name.ends_with('A'))
        .map(|(name, _)| *name)
        .collect::<Vec<_>>();

    let mut first_cycles = Vec::new();
    for (steps, instruction) in instructions.clone().cycle().enumerate() {
        for node in current_nodes.iter_mut() {
            let (left, right) = nodes[*node];
            *node = match instruction {
                'R' => right,
                'L' => left,
                _ => unreachable!("Invalid instruction"),
            };

            if node.ends_with('Z') {
                first_cycles.push(steps);
            }
        }
    }

    println!("Part 2: {}", lcm(first_cycles));
}

fn lcm(numbers: Vec<usize>) -> usize {
    let mut temp = numbers.clone();
    loop {
        let mut same = true;

        for idx in 1..temp.len() {
            if temp[0] != temp[idx] {
                same = false;
                break;
            }
        }

        if same {
            return temp[0];
        }

        match temp
            .iter()
            .enumerate()
            .min_by(|(_, a), (_, b)| a.cmp(b))
            .map(|(index, _)| index)
        {
            Some(idx) => {
                temp[idx] += numbers[idx];
            }
            None => panic!("Not possible"),
        }
    }
}
