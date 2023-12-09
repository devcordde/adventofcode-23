fn main() {
    let input = include_str!("./data/inputs/day_09.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

pub fn part_a(input: &str) -> Option<i64> {
    let oasis_lines: Vec<Vec<i64>> = input
        .lines()
        .map(|l| l.split_whitespace().map(|n| n.parse().unwrap()).collect())
        .collect();

    let mut sum = 0;
    for report in oasis_lines {
        let mut histories = vec![report];
        while histories.last().unwrap().iter().sum::<i64>() != 0 {
            let mut last_history_diffs = vec![];
            for vals in histories.last().unwrap().as_slice().windows(2) {
                last_history_diffs.push(vals[1] - vals[0]);
            }
            histories.push(last_history_diffs);
        }

        histories.reverse();
        let mut extrapolate_vals = vec![0];
        for history in &histories[1..] {
            extrapolate_vals.push(history.last().unwrap() + extrapolate_vals.last().unwrap());
        }
        sum += extrapolate_vals.last().unwrap();
    }
    Some(sum)
}

pub fn part_b(input: &str) -> Option<i64> {
    let oasis_lines: Vec<Vec<i64>> = input
        .lines()
        .map(|l| l.split_whitespace().map(|n| n.parse().unwrap()).collect())
        .collect();

    let mut sum = 0;
    for report in oasis_lines {
        let mut histories = vec![report];
        while histories.last().unwrap().iter().sum::<i64>() != 0 {
            let mut last_history_diffs = vec![];
            for vals in histories.last().unwrap().as_slice().windows(2) {
                last_history_diffs.push(vals[1] - vals[0]);
            }
            histories.push(last_history_diffs);
        }

        histories.reverse();
        let mut extrapolate_vals = vec![0];
        for history in &histories[1..] {
            extrapolate_vals.push(history.first().unwrap() - extrapolate_vals.last().unwrap());
        }
        sum += extrapolate_vals.last().unwrap();
    }
    Some(sum)
}
