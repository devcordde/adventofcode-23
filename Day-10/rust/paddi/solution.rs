fn main() {
    let input = include_str!("./data/inputs/day_10.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

use std::collections::HashSet;

fn get_adjacent_pipe_direction(
    y: usize,
    x: usize,
    starting_direction: usize,
    pipes: &[Vec<char>],
) -> (isize, isize) {
    let mut directions = [(-1, 0), (0, 1), (1, 0), (0, -1)];
    directions.rotate_left(starting_direction);

    for direction in directions {
        let adjacent_tile =
            pipes[(y as isize + direction.0) as usize][(x as isize + direction.1) as usize];
        let current_tile = pipes[y][x];

        match direction {
            (-1, 0) => {
                if ['|', '7', 'F', 'S'].contains(&adjacent_tile)
                    && ['|', 'L', 'J', 'S'].contains(&current_tile)
                {
                    return direction;
                }
            }
            (0, 1) => {
                if ['-', 'J', '7', 'S'].contains(&adjacent_tile)
                    && ['-', 'L', 'F', 'S'].contains(&current_tile)
                {
                    return direction;
                }
            }
            (1, 0) => {
                if ['|', 'L', 'J', 'S'].contains(&adjacent_tile)
                    && ['|', '7', 'F', 'S'].contains(&current_tile)
                {
                    return direction;
                }
            }
            (0, -1) => {
                if ['-', 'L', 'F', 'S'].contains(&adjacent_tile)
                    && ['-', 'J', '7', 'S'].contains(&current_tile)
                {
                    return direction;
                }
            }
            _ => unreachable!(),
        }
    }
    unreachable!()
}

pub fn part_a(input: &str) -> Option<u32> {
    let mut pipes: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();
    let old_row_length = pipes[0].len();
    let bounding_row = vec!['.'; old_row_length];
    pipes.insert(0, bounding_row.clone());
    pipes.push(bounding_row);
    pipes.iter_mut().for_each(|r| {
        r.insert(0, '.');
        r.push('.');
    });
    let mut main_loop = vec![];

    let y_start = pipes.iter().position(|v| v.contains(&'S')).unwrap();
    let x_start = pipes[y_start].iter().position(|c| c == &'S').unwrap();
    let mut current_pipe_location = (y_start, x_start);

    let mut direction = get_adjacent_pipe_direction(y_start, x_start, 0, &pipes);
    current_pipe_location = (
        (current_pipe_location.0 as isize + direction.0) as usize,
        (current_pipe_location.1 as isize + direction.1) as usize,
    );
    main_loop.push(pipes[current_pipe_location.0][current_pipe_location.1]);

    while current_pipe_location != (y_start, x_start) {
        let rotation = match direction {
            (-1, 0) => 3,
            (0, 1) => 0,
            (1, 0) => 1,
            (0, -1) => 2,
            _ => unreachable!(),
        };
        direction = get_adjacent_pipe_direction(
            current_pipe_location.0,
            current_pipe_location.1,
            rotation,
            &pipes,
        );
        current_pipe_location = (
            (current_pipe_location.0 as isize + direction.0) as usize,
            (current_pipe_location.1 as isize + direction.1) as usize,
        );
        main_loop.push(pipes[current_pipe_location.0][current_pipe_location.1]);
    }

    Some(main_loop.len() as u32 / 2)
}

fn floodfill(
    y: usize,
    x: usize,
    main_loop: &HashSet<(usize, usize)>,
    big_pipes: &mut Vec<Vec<char>>,
) {
    let mut stack = Vec::with_capacity(50_000);
    stack.push((y, x));

    while let Some((y, x)) = stack.pop() {
        if !main_loop.contains(&(y, x)) && big_pipes[y][x] != '!' && big_pipes[y][x] != 'y' {
            if big_pipes[y][x] == 'x' {
                big_pipes[y][x] = 'y';
            } else {
                big_pipes[y][x] = '!';
            }
            if x < big_pipes[0].len() - 1 {
                stack.push((y, x + 1));
            }
            if x > 0 {
                stack.push((y, x - 1));
            }
            if y < big_pipes.len() - 1 {
                stack.push((y + 1, x));
            }
            if y > 0 {
                stack.push((y - 1, x));
            }
        }
    }
}

pub fn part_b(input: &str) -> Option<u32> {
    let mut pipes: Vec<Vec<char>> = input.lines().map(|l| l.chars().collect()).collect();
    let old_row_length = pipes[0].len();
    let bounding_row = vec!['.'; old_row_length];
    pipes.insert(0, bounding_row.clone());
    pipes.push(bounding_row);
    pipes.iter_mut().for_each(|r| {
        r.insert(0, '.');
        r.push('.');
    });

    let mut big_pipes = vec![vec!['.'; pipes[0].len() * 3]; pipes.len() * 3];
    for y in 0..pipes.len() {
        for x in 0..pipes[0].len() {
            match pipes[y][x] {
                'S' => {
                    // FIXME: Autodetect actual S shape
                    big_pipes[y * 3 + 1][x * 3 + 1] = 'S';
                    big_pipes[y * 3 + 1][x * 3 + 2] = '-';
                    big_pipes[y * 3 + 1][x * 3] = '-';
                }
                '|' => {
                    big_pipes[y * 3 + 1][x * 3 + 1] = '|';
                    big_pipes[y * 3][x * 3 + 1] = '|';
                    big_pipes[y * 3 + 2][x * 3 + 1] = '|';
                }
                '-' => {
                    big_pipes[y * 3 + 1][x * 3 + 1] = '-';
                    big_pipes[y * 3 + 1][x * 3 + 2] = '-';
                    big_pipes[y * 3 + 1][x * 3] = '-';
                }
                '7' => {
                    big_pipes[y * 3 + 1][x * 3 + 1] = '7';
                    big_pipes[y * 3 + 2][x * 3 + 1] = '|';
                    big_pipes[y * 3 + 1][x * 3] = '-';
                }
                'J' => {
                    big_pipes[y * 3 + 1][x * 3 + 1] = 'J';
                    big_pipes[y * 3][x * 3 + 1] = '|';
                    big_pipes[y * 3 + 1][x * 3] = '-';
                }
                'L' => {
                    big_pipes[y * 3 + 1][x * 3 + 1] = 'L';
                    big_pipes[y * 3][x * 3 + 1] = '|';
                    big_pipes[y * 3 + 1][x * 3 + 2] = '-';
                }
                'F' => {
                    big_pipes[y * 3 + 1][x * 3 + 1] = 'F';
                    big_pipes[y * 3 + 1][x * 3 + 2] = '-';
                    big_pipes[y * 3 + 2][x * 3 + 1] = '|';
                }
                _ => continue,
            }
        }
    }

    let mut main_loop = vec![];

    let y_start = big_pipes.iter().position(|v| v.contains(&'S')).unwrap();
    let x_start = big_pipes[y_start].iter().position(|c| c == &'S').unwrap();
    let mut current_pipe_location = (y_start, x_start);

    let mut direction = get_adjacent_pipe_direction(y_start, x_start, 0, &big_pipes);
    current_pipe_location = (
        (current_pipe_location.0 as isize + direction.0) as usize,
        (current_pipe_location.1 as isize + direction.1) as usize,
    );
    main_loop.push((current_pipe_location.0, current_pipe_location.1));

    while current_pipe_location != (y_start, x_start) {
        let rotation = match direction {
            (-1, 0) => 3,
            (0, 1) => 0,
            (1, 0) => 1,
            (0, -1) => 2,
            _ => unreachable!(),
        };
        direction = get_adjacent_pipe_direction(
            current_pipe_location.0,
            current_pipe_location.1,
            rotation,
            &big_pipes,
        );
        current_pipe_location = (
            (current_pipe_location.0 as isize + direction.0) as usize,
            (current_pipe_location.1 as isize + direction.1) as usize,
        );
        main_loop.push((current_pipe_location.0, current_pipe_location.1));
    }

    for (y, x) in main_loop.iter().copied() {
        for dy in [-1, 0, 1] {
            for dx in [-1, 0, 1] {
                if big_pipes[(y as isize + dy) as usize][(x as isize + dx) as usize] == '.' {
                    big_pipes[(y as isize + dy) as usize][(x as isize + dx) as usize] = 'x';
                }
            }
        }
    }

    let main_loop_set = HashSet::from_iter(main_loop.iter().copied());
    floodfill(0, 0, &main_loop_set, &mut big_pipes);

    for (y, x) in main_loop.iter().copied() {
        big_pipes[y][x] = 'm';
    }

    let mut count = 0;
    for y in 0..big_pipes.len() {
        for x in 0..big_pipes[0].len() {
            if !['!', 'y', 'm', 'x'].contains(&big_pipes[y][x]) {
                count += 1;
            }
        }
    }

    Some(count / 9)
}
