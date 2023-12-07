use std::cmp::Ordering;
use std::fmt::Display;
use std::ops::AddAssign;
use std::str::FromStr;

pub fn main() {
    let input = include_str!("input.txt").lines();

    let mut input = input
        .map(|line| {
            let (hand, winning) = line.split_once(' ').unwrap();
            let hand = hand.parse::<Hand>().unwrap();
            let bid = winning.parse::<u64>().unwrap();
            (hand, bid)
        })
        .collect::<Vec<_>>();

    input.sort_unstable_by(|a, b| a.0.cmp(&b.0));

    let part1 = input
        .iter()
        .enumerate()
        .map(|(index, (_, bid))| bid * (index as u64 + 1))
        .sum::<u64>();

    println!("Part 1: {}", part1);

    let mut input = input
        .into_iter()
        .map(|(hand, bid)| {
            (
                Hand {
                    jokers: true,
                    cards: hand.cards,
                },
                bid,
            )
        })
        .collect::<Vec<_>>();

    input.sort_unstable_by(|a, b| a.0.cmp(&b.0));

    let part2 = input
        .iter()
        .enumerate()
        .map(|(index, (_, bid))| bid * (index as u64 + 1))
        .sum::<u64>();

    println!("Part 2: {}", part2);
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct Hand {
    pub jokers: bool,
    pub cards: [u8; 5],
}

impl FromStr for Hand {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let chars = s.chars();

        let mut cards = [0; 5];

        for (index, char) in chars.enumerate() {
            cards[index] = match char {
                'A' => 14,
                'K' => 13,
                'Q' => 12,
                'J' => 11,
                'T' => 10,
                _ => char as u8 - b'0',
            };
        }

        Ok(Hand {
            jokers: false,
            cards,
        })
    }
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

impl PartialOrd<Self> for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        let self_type = find_hand_type(self, self.jokers);
        let other_type = find_hand_type(other, other.jokers);

        if self_type == other_type {
            for (index, card) in self.cards.iter().enumerate() {
                let card = if self.jokers && card == &11 { 1 } else { *card };
                let other_card = other.cards[index];
                let other_card = if other.jokers && other_card == 11 {
                    1
                } else {
                    other_card
                };
                if card != other_card {
                    return Some(card.cmp(&other_card));
                }
            }
            Some(Ordering::Equal)
        } else {
            Some(self_type.cmp(&other_type))
        }
    }
}

impl Display for Hand {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let str = self
            .cards
            .iter()
            .map(|card| match card {
                10 => 'T',
                1 => 'J',
                11 => 'J',
                12 => 'Q',
                13 => 'K',
                14 => 'A',
                _ => (card + b'0') as char,
            })
            .collect::<String>();
        write!(f, "{}", str)
    }
}

fn find_hand_type(hand: &Hand, jokers: bool) -> HandType {
    let card_occurrences = hand.cards.iter().fold([(0_u8, 0_u8); 5], |mut map, x| {
        let a = map.iter_mut().find(|(card, _)| card == x);
        if let Some((_, value)) = a {
            value.add_assign(1);
        } else {
            let a = map.iter_mut().find(|(_, value)| *value == 0);
            if let Some((card, value)) = a {
                *card = *x;
                *value = 1;
            }
        }

        map
    });
    let mut occurences = card_occurrences.map(|(_, v)| v);
    let last_index = occurences.iter_mut().position(|v| v == &0).unwrap_or(5);
    let slice = &mut occurences[..last_index];
    slice.sort();

    let joker_count = if jokers {
        card_occurrences
            .iter()
            .find(|(card, _)| *card == 11)
            .map(|(_, count)| *count)
            .unwrap_or(0)
    } else {
        0
    };

    match slice {
        [1, 1, 1, 1, 1] => {
            if joker_count > 0 {
                return HandType::OnePair;
            }
            HandType::HighCard
        }
        [1, 1, 1, 2] => {
            if joker_count == 1 || joker_count == 2 {
                return HandType::ThreeOfAKind;
            }
            HandType::OnePair
        }
        [1, 2, 2] => {
            if joker_count == 1 {
                return HandType::FullHouse;
            } else if joker_count == 2 {
                return HandType::FourOfAKind;
            }
            HandType::TwoPairs
        }
        [1, 1, 3] => {
            if joker_count == 1 || joker_count == 3 {
                return HandType::FourOfAKind;
            }
            HandType::ThreeOfAKind
        }
        [2, 3] => {
            if joker_count == 1 {
                return HandType::FourOfAKind;
            } else if joker_count == 2 || joker_count == 3 {
                return HandType::FiveOfAKind;
            }
            HandType::FullHouse
        }
        [1, 4] => {
            if joker_count > 0 {
                return HandType::FiveOfAKind;
            }
            HandType::FourOfAKind
        }
        [5] => HandType::FiveOfAKind,
        _ => unreachable!(),
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
enum HandType {
    HighCard = 0,
    OnePair = 1,
    TwoPairs = 2,
    ThreeOfAKind = 3,
    FullHouse = 4,
    FourOfAKind = 5,
    FiveOfAKind = 6,
}
