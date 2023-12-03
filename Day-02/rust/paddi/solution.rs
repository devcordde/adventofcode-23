use regex::Regex;

fn main() {
    let input = include_str!("input.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

pub fn part_a(input: &str) -> Option<u32> {
    let blue_regex = Regex::new(r"(\d+) blue").unwrap();
    let green_regex = Regex::new(r"(\d+) green").unwrap();
    let red_regex = Regex::new(r"(\d+) red").unwrap();

    let lines = input.lines();
    let mut id_sum = 0;

    for line in lines {
        let mut game_split = line.split(": ");
        let game_id_split = game_split.next().unwrap().split(' ');
        let reveal_split = game_split.next().unwrap().split("; ");
        let game_id: u32 = game_id_split.last().unwrap().parse().unwrap();

        let mut valid_game = true;
        for reveal in reveal_split {
            let blue = if let Some(result) = blue_regex.captures(reveal) {
                result.get(1).unwrap().as_str().parse().unwrap()
            } else {
                0
            };
            let green = if let Some(result) = green_regex.captures(reveal) {
                result.get(1).unwrap().as_str().parse().unwrap()
            } else {
                0
            };
            let red = if let Some(result) = red_regex.captures(reveal) {
                result.get(1).unwrap().as_str().parse().unwrap()
            } else {
                0
            };

            if red > 12 || green > 13 || blue > 14 {
                valid_game = false;
                break;
            }
        }
        if valid_game {
            id_sum += game_id;
        }
    }
    Some(id_sum)
}

pub fn part_b(input: &str) -> Option<u32> {
    let blue_regex = Regex::new(r"(\d+) blue").unwrap();
    let green_regex = Regex::new(r"(\d+) green").unwrap();
    let red_regex = Regex::new(r"(\d+) red").unwrap();

    let lines = input.lines();
    let mut cube_power = 0;

    for line in lines {
        let game_split = line.split(": ");
        let reveal_split = game_split.last().unwrap().split("; ");

        let mut line_cube_power = 1;
        let mut rgb_min_cubes = [0; 3];
        for reveal in reveal_split {
            let blue = if let Some(result) = blue_regex.captures(reveal) {
                result.get(1).unwrap().as_str().parse().unwrap()
            } else {
                0
            };
            let green = if let Some(result) = green_regex.captures(reveal) {
                result.get(1).unwrap().as_str().parse().unwrap()
            } else {
                0
            };
            let red = if let Some(result) = red_regex.captures(reveal) {
                result.get(1).unwrap().as_str().parse().unwrap()
            } else {
                0
            };

            rgb_min_cubes[0] = rgb_min_cubes[0].max(red);
            rgb_min_cubes[1] = rgb_min_cubes[1].max(green);
            rgb_min_cubes[2] = rgb_min_cubes[2].max(blue);
        }

        for min_cubes in rgb_min_cubes {
            line_cube_power *= min_cubes
        }
        cube_power += line_cube_power;
    }
    Some(cube_power)
}
