pub fn main() {
    let input = include_str!("input.txt").lines();

    let card_count = input.clone().count();
    
    let cards = input.map(|card| {
        let (_, numbers) = card.split_once(": ").unwrap();

        let (winning_numbers, numbers) = numbers.split_once(" | ").unwrap();

        let winning_numbers = winning_numbers
            .split_whitespace()
            .map(|number| number.parse::<u32>().unwrap())
            .collect::<Vec<u32>>();

        let numbers = numbers.split_whitespace().map(|number| {
            number.parse::<u32>().unwrap()
        }).collect::<Vec<u32>>();

        (winning_numbers, numbers)
    });

    let mut copies = vec![1; card_count];

    let result = cards.enumerate().map(|(index, (winning_numbers, numbers))| {
        let matches = numbers.find_matches(&winning_numbers);

        for i in (index + 1)..=(index + matches) {
            copies[i] += copies[index];
        }

        if matches == 0 {
            return 0;
        }

        2_usize.pow(matches as u32 - 1)
    }).sum::<usize>();

    println!("Part 1: {}", result);

    println!("Part 2: {}", copies.iter().sum::<usize>())
}

trait FindMatches {
    fn find_matches(&self, winning_numbers: &[u32]) -> usize;
}
impl FindMatches for Vec<u32> {
    fn find_matches(&self, winning_numbers: &[u32]) -> usize {
        let matches = self.iter().filter(|number| {
            winning_numbers.contains(number)
        }).count();

        matches
    }
}
