fn main() {
    let input = include_str!("./data/inputs/day_22.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::{
    collections::{HashMap, HashSet},
    ops::RangeInclusive,
};

#[derive(Debug, Clone, Eq, PartialEq, Hash)]
struct Brick {
    x: RangeInclusive<u32>,
    y: RangeInclusive<u32>,
    z: RangeInclusive<u32>,
}

impl Brick {
    fn fall(&mut self, bricks: &[Brick]) -> bool {
        let fall_onto = bricks
            .iter()
            .filter(|brick| {
                ((self.x.start() <= brick.x.start() && self.x.end() >= brick.x.start()) || (brick.x.start() <= self.x.start() && brick.x.end() >= self.x.start())) // X intersection
            && ((self.y.start() <= brick.y.start() && self.y.end() >= brick.y.start()) || (brick.y.start() <= self.y.start() && brick.y.end() >= self.y.start())) // Y intersection
            && (self.z.start() > brick.z.end()) // Below + Gap
            })
            .map(|brick| brick.z.end())
            .max();

        if let Some(z_occupied) = fall_onto {
            // Fall to brick
            let fall_dist = self.z.start() - z_occupied - 1;
            if fall_dist != 0 {
                self.z = (self.z.start() - fall_dist)..=(self.z.end() - fall_dist);
                true
            } else {
                false
            }
        } else if self.z.start() > &1 {
            // Fall to ground
            let fall_dist = self.z.start() - 1;
            self.z = (self.z.start() - fall_dist)..=(self.z.end() - fall_dist);
            true
        } else {
            // Already on ground or brick
            false
        }
    }

    fn get_necessary_bricks(&self, bricks: &[Brick]) -> Vec<Brick> {
        let bricks_immediately_below: Vec<_> = bricks
            .iter()
            .filter(|brick| {
                ((self.x.start() <= brick.x.start() && self.x.end() >= brick.x.start()) || (brick.x.start() <= self.x.start() && brick.x.end() >= self.x.start())) // X intersection
            && ((self.y.start() <= brick.y.start() && self.y.end() >= brick.y.start()) || (brick.y.start() <= self.y.start() && brick.y.end() >= self.y.start())) // Y intersection
            && (self.z.start() == &(1 + *brick.z.end())) // Directly Below
            })
            .cloned()
            .collect();

        if bricks_immediately_below.len() > 1 {
            Vec::new()
        } else {
            bricks_immediately_below
        }
    }
}

pub fn part_a(input: &str) -> Option<usize> {
    let mut bricks: Vec<Brick> = input
        .lines()
        .map(|line| {
            line.split(|c: char| !c.is_ascii_digit())
                .map(|s| s.parse().unwrap())
                .collect::<Vec<_>>()
        })
        .map(|digits| Brick {
            x: digits[0]..=digits[3],
            y: digits[1]..=digits[4],
            z: digits[2]..=digits[5],
        })
        .collect();

    let mut any_brick_has_fallen = true;
    while any_brick_has_fallen {
        let current_state = bricks.clone();
        any_brick_has_fallen = false;
        for brick in bricks.iter_mut() {
            let has_fallen = brick.fall(&current_state);
            any_brick_has_fallen |= has_fallen;
        }
    }

    let mut disintegrateable_bricks = HashSet::new();
    disintegrateable_bricks.extend(bricks.clone());
    for brick in &bricks {
        let necessary_bricks = brick.get_necessary_bricks(&bricks);
        for necessary_brick in necessary_bricks {
            disintegrateable_bricks.remove(&necessary_brick);
        }
    }

    Some(disintegrateable_bricks.len())
}

pub fn part_b(input: &str) -> Option<usize> {
    let mut bricks: Vec<Brick> = input
        .lines()
        .map(|line| {
            line.split(|c: char| !c.is_ascii_digit())
                .map(|s| s.parse().unwrap())
                .collect::<Vec<_>>()
        })
        .map(|digits| Brick {
            x: digits[0]..=digits[3],
            y: digits[1]..=digits[4],
            z: digits[2]..=digits[5],
        })
        .collect();

    let mut any_brick_has_fallen = true;
    while any_brick_has_fallen {
        let current_state = bricks.clone();
        any_brick_has_fallen = false;
        for brick in bricks.iter_mut() {
            let has_fallen = brick.fall(&current_state);
            any_brick_has_fallen |= has_fallen;
        }
    }

    let mut sum = 0;
    for dis_brick in &bricks {
        let mut modified_bricks = bricks.clone();
        modified_bricks.remove(bricks.iter().position(|b| b == dis_brick).unwrap());

        let mut modified_bricks: HashMap<Brick, Brick> = HashMap::from_iter(
            modified_bricks
                .iter()
                .cloned()
                .zip(modified_bricks.iter().cloned()),
        );

        let mut any_brick_has_fallen = true;
        while any_brick_has_fallen {
            let current_state: Vec<_> = modified_bricks.clone().values().cloned().collect();
            any_brick_has_fallen = false;
            for mod_brick in modified_bricks.values_mut() {
                let has_fallen = mod_brick.fall(&current_state);
                any_brick_has_fallen |= has_fallen;
            }
        }

        sum += modified_bricks.iter().filter(|(k, v)| k != v).count();
    }
    Some(sum)
}
