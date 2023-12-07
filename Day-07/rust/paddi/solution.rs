use std::cmp::Ordering;
use std::error::Error;
use std::fmt::{Debug, Display, Formatter};

fn main() {
    let input = include_str!("input.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}

#[derive(Ord, PartialOrd, Eq, PartialEq, Copy, Clone, Debug)]
enum Card {
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Jack,
    Queen,
    King,
    Ace,
}

#[derive(Ord, PartialOrd, Eq, PartialEq, Copy, Clone, Debug)]
enum Card2 {
    Joker,
    Two,
    Three,
    Four,
    Five,
    Six,
    Seven,
    Eight,
    Nine,
    Ten,
    Queen,
    King,
    Ace,
}

#[derive(Debug, Clone)]
struct ParseCardError {
    failed_string: String,
}

impl ParseCardError {
    fn new(failed_string: String) -> Self {
        ParseCardError { failed_string }
    }
}

impl Display for ParseCardError {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "Failed to parse Card: {}", self.failed_string)
    }
}

impl Error for ParseCardError {}

impl TryFrom<char> for Card {
    type Error = ParseCardError;

    fn try_from(c: char) -> Result<Self, Self::Error> {
        Ok(match c {
            'A' => Card::Ace,
            'K' => Card::King,
            'Q' => Card::Queen,
            'J' => Card::Jack,
            'T' => Card::Ten,
            c => match c.to_digit(10) {
                None => return Err(ParseCardError::new(c.to_string())),
                Some(number_card) => {
                    assert!(number_card < 10);
                    let number_cards = vec![
                        Card::Two,
                        Card::Three,
                        Card::Four,
                        Card::Five,
                        Card::Six,
                        Card::Seven,
                        Card::Eight,
                        Card::Nine,
                    ];
                    number_cards[number_card as usize - 2]
                }
            },
        })
    }
}

impl TryFrom<char> for Card2 {
    type Error = ParseCardError;

    fn try_from(c: char) -> Result<Self, Self::Error> {
        Ok(match c {
            'A' => Card2::Ace,
            'K' => Card2::King,
            'Q' => Card2::Queen,
            'J' => Card2::Joker,
            'T' => Card2::Ten,
            c => match c.to_digit(10) {
                None => return Err(ParseCardError::new(c.to_string())),
                Some(number_card) => {
                    assert!(number_card < 10);
                    let number_cards = vec![
                        Card2::Two,
                        Card2::Three,
                        Card2::Four,
                        Card2::Five,
                        Card2::Six,
                        Card2::Seven,
                        Card2::Eight,
                        Card2::Nine,
                    ];
                    number_cards[number_card as usize - 2]
                }
            },
        })
    }
}

#[derive(Eq, PartialEq, Clone, Debug)]
struct Hand {
    cards: Vec<Card>,
}

#[derive(Eq, PartialEq, Clone, Debug)]
struct Hand2 {
    cards: Vec<Card2>,
}

#[derive(Ord, PartialOrd, Eq, PartialEq, Copy, Clone, Debug)]
enum Strength {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind,
}

impl Hand {
    fn get_strength(&self) -> Strength {
        assert_eq!(self.cards.len(), 5);
        if self.cards.iter().all(|c| c == &self.cards[0]) {
            return Strength::FiveOfAKind;
        }
        let mut sorted = self.cards.clone();
        sorted.sort();
        if sorted[0..4].iter().all(|c| c == &sorted[0])
            || sorted[1..5].iter().all(|c| c == &sorted[4])
        {
            return Strength::FourOfAKind;
        }

        if sorted.windows(3).any(|c| c[0] == c[1] && c[1] == c[2]) {
            if sorted[3..5].iter().all(|c| c == &sorted[4])
                && sorted[0..2].iter().all(|c| c == &sorted[0])
            {
                return Strength::FullHouse;
            }
            return Strength::ThreeOfAKind;
        }

        let pair_count = sorted.windows(2).filter(|w| w[0] == w[1]).count();
        if pair_count == 2 {
            return Strength::TwoPair;
        } else if pair_count == 1 {
            return Strength::OnePair;
        }

        return Strength::HighCard;
    }
}

impl PartialOrd for Hand {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        return Some(match self.get_strength().cmp(&other.get_strength()) {
            Ordering::Less => Ordering::Less,
            Ordering::Greater => Ordering::Greater,
            Ordering::Equal => {
                for (self_card, other_card) in self.cards.iter().zip(other.cards.iter()) {
                    match self_card.cmp(other_card) {
                        Ordering::Less => return Some(Ordering::Less),
                        Ordering::Equal => continue,
                        Ordering::Greater => return Some(Ordering::Greater),
                    }
                }
                unreachable!()
            }
        });
    }
}

impl Ord for Hand {
    fn cmp(&self, other: &Self) -> Ordering {
        return match self.get_strength().cmp(&other.get_strength()) {
            Ordering::Less => Ordering::Less,
            Ordering::Greater => Ordering::Greater,
            Ordering::Equal => {
                for (self_card, other_card) in self.cards.iter().zip(other.cards.iter()) {
                    match self_card.cmp(other_card) {
                        Ordering::Less => return Ordering::Less,
                        Ordering::Equal => continue,
                        Ordering::Greater => return Ordering::Greater,
                    }
                }
                unreachable!()
            }
        };
    }
}

impl Hand2 {
    fn get_strength(&self) -> Strength {
        let mut strengths = vec![];
        for joker_replacement in [
            Card2::Two,
            Card2::Three,
            Card2::Four,
            Card2::Five,
            Card2::Six,
            Card2::Seven,
            Card2::Eight,
            Card2::Nine,
            Card2::Ten,
            Card2::Queen,
            Card2::King,
            Card2::Ace,
        ] {
            let replaced_cards: Vec<_> = self
                .cards
                .clone()
                .into_iter()
                .map(|c| {
                    if c == Card2::Joker {
                        joker_replacement
                    } else {
                        c
                    }
                })
                .collect();
            assert_eq!(replaced_cards.len(), 5);
            if replaced_cards.iter().all(|c| c == &replaced_cards[0]) {
                strengths.push(Strength::FiveOfAKind);
            }
            let mut sorted = replaced_cards.clone();
            sorted.sort();
            if sorted[0..4].iter().all(|c| c == &sorted[0])
                || sorted[1..5].iter().all(|c| c == &sorted[4])
            {
                strengths.push(Strength::FourOfAKind);
                continue;
            }

            if sorted.windows(3).any(|c| c[0] == c[1] && c[1] == c[2]) {
                if sorted[3..5].iter().all(|c| c == &sorted[4])
                    && sorted[0..2].iter().all(|c| c == &sorted[0])
                {
                    strengths.push(Strength::FullHouse);
                    continue;
                }
                strengths.push(Strength::ThreeOfAKind);
                continue;
            }

            let pair_count = sorted.windows(2).filter(|w| w[0] == w[1]).count();
            if pair_count == 2 {
                strengths.push(Strength::TwoPair);
                continue;
            } else if pair_count == 1 {
                strengths.push(Strength::OnePair);
                continue;
            }

            strengths.push(Strength::HighCard);
            continue;
        }
        strengths.into_iter().max().unwrap()
    }
}

impl PartialOrd for Hand2 {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        return Some(match self.get_strength().cmp(&other.get_strength()) {
            Ordering::Less => Ordering::Less,
            Ordering::Greater => Ordering::Greater,
            Ordering::Equal => {
                for (self_card, other_card) in self.cards.iter().zip(other.cards.iter()) {
                    match self_card.cmp(other_card) {
                        Ordering::Less => return Some(Ordering::Less),
                        Ordering::Equal => continue,
                        Ordering::Greater => return Some(Ordering::Greater),
                    }
                }
                unreachable!()
            }
        });
    }
}

impl Ord for Hand2 {
    fn cmp(&self, other: &Self) -> Ordering {
        return match self.get_strength().cmp(&other.get_strength()) {
            Ordering::Less => Ordering::Less,
            Ordering::Greater => Ordering::Greater,
            Ordering::Equal => {
                for (self_card, other_card) in self.cards.iter().zip(other.cards.iter()) {
                    match self_card.cmp(other_card) {
                        Ordering::Less => return Ordering::Less,
                        Ordering::Equal => continue,
                        Ordering::Greater => return Ordering::Greater,
                    }
                }
                unreachable!()
            }
        };
    }
}

pub fn part_a(input: &str) -> Option<usize> {
    let mut hand_list: Vec<(Hand, usize)> = input
        .lines()
        .map(|l| l.split_once(" ").unwrap())
        .map(|(hand, bid)| (hand, bid.parse().unwrap()))
        .map(|(hand, bid)| {
            (
                Hand {
                    cards: hand.chars().map(|c| c.try_into().unwrap()).collect(),
                },
                bid,
            )
        })
        .collect();

    hand_list.sort_by(|(h1, _), (h2, _)| h1.cmp(h2));

    Some(
        hand_list
            .iter()
            .enumerate()
            .fold(0, |acc, (i, (_, b))| acc + (i + 1) * b),
    )
}

pub fn part_b(input: &str) -> Option<usize> {
    let mut hand_list: Vec<(Hand2, usize)> = input
        .lines()
        .map(|l| l.split_once(" ").unwrap())
        .map(|(hand, bid)| (hand, bid.parse().unwrap()))
        .map(|(hand, bid)| {
            (
                Hand2 {
                    cards: hand.chars().map(|c| c.try_into().unwrap()).collect(),
                },
                bid,
            )
        })
        .collect();

    hand_list.sort_by(|(h1, _), (h2, _)| h1.cmp(h2));

    Some(
        hand_list
            .iter()
            .enumerate()
            .fold(0, |acc, (i, (_, b))| acc + (i + 1) * b),
    )
}
