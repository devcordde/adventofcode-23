fn main() {
    let input = include_str!("./data/inputs/day_15.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::hash::Hasher;

struct Hash {
    state: u64,
}

impl Hash {
    fn new() -> Self {
        Hash { state: 0 }
    }
}

impl Hasher for Hash {
    fn finish(&self) -> u64 {
        self.state
    }

    fn write(&mut self, bytes: &[u8]) {
        for b in bytes {
            self.write_u8(*b);
        }
    }

    fn write_u8(&mut self, i: u8) {
        self.state += i as u64;
        self.state *= 17;
        self.state %= 256;
    }
}

pub fn part_a(input: &str) -> Option<u64> {
    let mut hash_sum = 0;
    for substring in input.trim().split(',') {
        let mut hasher = Hash::new();
        hasher.write(substring.as_bytes());
        hash_sum += hasher.finish();
    }

    Some(hash_sum)
}

pub fn part_b(input: &str) -> Option<usize> {
    let mut boxes: Vec<Vec<(&str, usize)>> = vec![vec![]; 256];
    for step in input.trim().split(',') {
        let mut hasher = Hash::new();
        if step.ends_with('-') {
            let label = step.strip_suffix('-').unwrap();
            hasher.write(label.as_bytes());
            let target_box = hasher.finish() as usize;
            if let Some(target_pos) = boxes[target_box].iter().position(|i| i.0 == label) {
                boxes[target_box].remove(target_pos);
            }
        } else {
            let (label, focal_length) = step.split_once('=').unwrap();
            let focal_length = focal_length.parse().unwrap();

            hasher.write(label.as_bytes());
            let target_box = hasher.finish() as usize;
            if let Some(target_pos) = boxes[target_box].iter().position(|i| i.0 == label) {
                boxes[target_box][target_pos] = (label, focal_length);
            } else {
                boxes[target_box].push((label, focal_length));
            }
        }
    }

    let mut focusing_power = 0;
    for (box_index, b) in boxes.into_iter().enumerate() {
        focusing_power += b
            .into_iter()
            .enumerate()
            .map(|(slot, lens)| (box_index + 1) * (slot + 1) * lens.1)
            .sum::<usize>();
    }

    Some(focusing_power)
}
