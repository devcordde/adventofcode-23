pub fn main() {
    let mut input = include_str!("../../input/day06.txt").lines();

    let times = input
        .next()
        .unwrap()
        .split_once(':')
        .unwrap()
        .1
        .split_whitespace()
        .map(|x| x.parse::<u64>().unwrap());

    let distances = input
        .next()
        .unwrap()
        .split_once(':')
        .unwrap()
        .1
        .split_whitespace()
        .map(|x| x.parse::<u64>().unwrap());

    let input = times.zip(distances).collect::<Vec<_>>();

    let part1 = input
        .iter()
        .map(|(time, distance)| find_beating_amount(*time as f64, *distance as f64))
        .product::<u64>();

    println!("Part 1: {}", part1);

    let input = input.iter().fold(
        (0_u64, 0_u64),
        |(new_time, new_distance), (time, distance)| {
            (
                new_time * (10_u64.pow(time.checked_ilog10().unwrap_or(1_u32) + 1)) + time,
                new_distance * (10_u64.pow(distance.checked_ilog10().unwrap_or(1_u32) + 1))
                    + distance,
            )
        },
    );

    println!(
        "Part 2: {}",
        find_beating_amount(input.0 as f64, input.1 as f64)
    );
}

fn find_beating_amount(time: f64, distance: f64) -> u64 {
    let x1 = (time + f64::sqrt(time.powf(2.0) - (4.0 * (distance + 1.0)))) / 2.0;
    let x2 = (time - f64::sqrt(time.powf(2.0) - (4.0 * (distance + 1.0)))) / 2.0;

    ((x1.floor().round() - x2.ceil().round()).abs() + 1.0) as u64
}
