pub fn main() {
    let input = include_str!("../../input/day02.txt").lines();

    let games = input.map(|game| {
        let (id, info) = game.split_once(": ").unwrap();

        let id = id.split_once(" ").unwrap().1.parse::<u32>().unwrap();

        let subsets = info.split("; ").map(|subset_info| {
            let mut subset = Subset::default();

            for cube in subset_info.split(", ") {
                let (value, color) = cube.split_once(" ").unwrap();

                match color {
                    "red" => subset.red += value.parse::<u32>().unwrap(),
                    "green" => subset.green += value.parse::<u32>().unwrap(),
                    "blue" => subset.blue += value.parse::<u32>().unwrap(),
                    _ => panic!("Invalid color: {}", color),
                }
            }

            subset
        });

        Game {
            id,
            subsets: subsets.collect(),
        }
    });

    let part1: u32 = games.clone().filter(|game| {
        !game
            .subsets
            .iter()
            .any(|subset| subset.red > 12 || subset.green > 13 || subset.blue > 14)
    }).map(|game| game.id).sum();

    println!("Part 1: {}", part1);

    let part2: u32 = games.map(|game| {
        let max_red = game.subsets.iter().map(|subset| subset.red).max().unwrap();
        let max_green = game.subsets.iter().map(|subset| subset.green).max().unwrap();
        let max_blue = game.subsets.iter().map(|subset| subset.blue).max().unwrap();

        max_red * max_green * max_blue
    }).sum();

    println!("Part 2: {}", part2);
}

#[derive(Debug)]
struct Game {
    id: u32,
    subsets: Vec<Subset>,
}

#[derive(Default, Debug)]
struct Subset {
    pub red: u32,
    pub green: u32,
    pub blue: u32,
}