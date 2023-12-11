pub fn main() {
    let input = include_str!("input.txt").lines();

    let tiles = input
        .enumerate()
        .map(|(y, line)| {
            line.chars()
                .enumerate()
                .map(move |(x, tile)| {
                    parse_tile(
                        tile,
                        Position {
                            x: x as isize,
                            y: y as isize,
                        },
                    )
                })
                .collect::<Vec<Tile>>()
        })
        .collect::<Vec<_>>();

    let starting = tiles
        .iter()
        .flatten()
        .find(|tile| tile.tile_type == TileType::Starting)
        .unwrap();

    for connection in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
        if starting.position.y + connection.1 < 0 || starting.position.x + connection.0 < 0 {
            continue;
        }
        let connection = tiles[(starting.position.y + connection.1) as usize]
            [(starting.position.x + connection.0) as usize];

        if connection.tile_type == TileType::Normal
            && connection.connections.unwrap().contains(&starting.position)
        {
            let mut result = Some(vec![starting.position]);
            let mut current = connection;

            for _ in 0.. {
                let position =
                    current.connections.unwrap().iter().position(|connection| {
                        result.as_ref().unwrap().last().unwrap() == connection
                    });

                result.as_mut().unwrap().push(current.position);

                if let Some(position) = position {
                    let position = (position + 1) % 2;
                    let connection = current.connections.unwrap()[position];

                    let next = tiles[connection.y as usize][connection.x as usize];

                    if next.tile_type == TileType::Starting {
                        break;
                    } else if next.tile_type == TileType::Normal {
                        current = next;
                    } else {
                        result = None;
                        break;
                    }
                } else {
                    result = None;
                    break;
                }
            }

            if let Some(result) = result {
                println!("Part 1: {}", result.len() / 2);
                break;
            }
        }
    }
}

fn parse_tile(tile: char, position: Position) -> Tile {
    let connecting = match tile {
        '|' => Some(((0, 1), (0, -1))),
        '-' => Some(((-1, 0), (1, 0))),
        'L' => Some(((0, -1), (1, 0))),
        'J' => Some(((0, -1), (-1, 0))),
        '7' => Some(((-1, 0), (0, 1))),
        'F' => Some(((1, 0), (0, 1))),
        _ => None,
    };

    let connections = connecting.map(|(first, second)| {
        let first = Position {
            x: position.x + first.0,
            y: position.y + first.1,
        };
        let second = Position {
            x: position.x + second.0,
            y: position.y + second.1,
        };

        [first, second]
    });

    let tile_type = if connecting.is_some() {
        TileType::Normal
    } else {
        match tile {
            'S' => TileType::Starting,
            '.' => TileType::Ground,
            _ => panic!("Invalid tile"),
        }
    };

    Tile {
        tile_type,
        position,
        connections,
    }
}

#[derive(PartialEq, Eq, Hash, Clone, Copy, Debug)]
struct Tile {
    pub tile_type: TileType,
    pub position: Position,
    pub connections: Option<[Position; 2]>,
}

#[derive(PartialEq, Eq, Hash, Clone, Copy, Debug)]
enum TileType {
    Normal,
    Starting,
    Ground,
}

#[derive(PartialEq, Eq, Hash, Clone, Copy, Debug)]
struct Position {
    pub x: isize,
    pub y: isize,
}
