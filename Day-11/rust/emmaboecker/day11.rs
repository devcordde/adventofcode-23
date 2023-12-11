pub fn main() {
    let input = include_str!("input.txt").lines().collect::<Vec<_>>();

    let empty_rows = input
        .iter()
        .enumerate()
        .filter(|(_, line)| line.chars().all(|char| char == '.'))
        .map(|(index, _)| index)
        .collect::<Vec<_>>();
    let empty_columns = (0..input.first().unwrap().len())
        .filter(|column| {
            input
                .iter()
                .all(|line| line.chars().nth(*column).unwrap() == '.')
        })
        .collect::<Vec<_>>();

    let positions = input
        .iter()
        .enumerate()
        .flat_map(|(y, line)| {
            line.chars().enumerate().map(move |(x, char)| match char {
                '.' => None,
                '#' => Some(Position { x, y }),
                _ => panic!("Invalid character"),
            })
        })
        .flatten()
        .collect::<Vec<_>>();

    let distances = positions
        .iter()
        .enumerate()
        .flat_map(|(index, position)| {
            positions.iter().skip(index).map(|other_position| {
                find_distance(position, other_position, &empty_rows, &empty_columns, 2)
            })
        })
        .sum::<usize>();

    println!("Part 1: {}", distances);

    let distances = positions
        .iter()
        .enumerate()
        .flat_map(|(index, position)| {
            positions.iter().skip(index).map(|other_position| {
                find_distance(
                    position,
                    other_position,
                    &empty_rows,
                    &empty_columns,
                    1000000,
                )
            })
        })
        .sum::<usize>();

    println!("Part 2: {}", distances);
}

fn find_distance(
    position: &Position,
    other: &Position,
    empty_rows: &[usize],
    empty_columns: &[usize],
    multiplier: usize,
) -> usize {
    let multiplier = multiplier - 1;

    let extra_y = empty_rows
        .iter()
        .filter(|row| (position.y.min(other.y)..other.y.max(position.y)).contains(row))
        .count()
        * multiplier;
    let extra_x = empty_columns
        .iter()
        .filter(|column| (position.x.min(other.x)..other.x.max(position.x)).contains(column))
        .count()
        * multiplier;

    let x = (other.x as isize - position.x as isize).unsigned_abs() + extra_x;
    let y = (other.y as isize - position.y as isize).unsigned_abs() + extra_y;
    x + y
}

#[derive(Debug, Clone)]
struct Position {
    x: usize,
    y: usize,
}
