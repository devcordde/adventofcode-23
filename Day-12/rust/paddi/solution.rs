fn main() {
    let input = include_str!("./data/inputs/day_12.txt");
    println!("Part A: \x1b[1m{}\x1b[0m", part_a(input).unwrap());
    println!("Part B: \x1b[1m{}\x1b[0m", part_b(input).unwrap());
}



fn get_valid_count(springs: &str, group_list: &Vec<usize>) -> u64 {
    let unknown_spring_count = springs.chars().filter(|c| c == &'?').count();
    let known_damaged_spring_count = springs.chars().filter(|c| c == &'#').count();

    let unknown_damaged_count = group_list.iter().sum::<usize>() - known_damaged_spring_count;
    let unknown_good_count = unknown_spring_count - unknown_damaged_count;

    let mut replacements = vec!["."; unknown_good_count];
    replacements.append(&mut vec!["#"; unknown_damaged_count]);

    let mut valid_combinations = 0;
    let permutations = permutations(&replacements, replacements.len());
    for permutation in permutations {
        let mut row_condition = springs.to_string();

        for replacement in permutation.iter() {
            row_condition = row_condition.replacen('?', replacement, 1);
        }
        let groups = row_condition
            .split('.')
            .filter(|s| !s.is_empty())
            .map(|s| s.len())
            .collect::<Vec<_>>();
        if &groups == group_list {
            valid_combinations += 1;
        }
    }
    valid_combinations
}

// https://github.com/janmarthedal/snippets/blob/master/rust/generate/permutations/src/lib.rs
// https://janmr.com/blog/2020/06/generating-all-permutations/
pub struct Permutations<T> {
    vec: Vec<T>,
    subsize: usize,
    first: bool,
}

impl<T: Clone + Ord> Iterator for Permutations<T> {
    type Item = Vec<T>;

    fn next(&mut self) -> Option<Vec<T>> {
        let n = self.vec.len();
        let r = self.subsize;
        if n == 0 || r == 0 || r > n {
            return None;
        }
        if self.first {
            self.vec.sort();
            self.first = false;
        } else if self.vec[r - 1] < self.vec[n - 1] {
            let mut j = r;
            while self.vec[j] <= self.vec[r - 1] {
                j += 1;
            }
            self.vec.swap(r - 1, j);
        } else {
            self.vec[r..n].reverse();
            let mut j = r - 1;
            while j > 0 && self.vec[j - 1] >= self.vec[j] {
                j -= 1;
            }
            if j == 0 {
                return None;
            }
            let mut l = n - 1;
            while self.vec[j - 1] >= self.vec[l] {
                l -= 1;
            }
            self.vec.swap(j - 1, l);
            self.vec[j..n].reverse();
        }
        Some(self.vec[0..r].to_vec())
    }

    fn size_hint(&self) -> (usize, Option<usize>) {
        let n = self.vec.len();
        let r = self.subsize;
        if n == 0 || r == 0 || r > n {
            (0, Some(0))
        } else {
            (1, Some(((n - r + 1)..=n).product()))
        }
    }
}

pub fn permutations<T: Clone + Ord>(s: &[T], subsize: usize) -> Permutations<T> {
    Permutations {
        vec: s.to_vec(),
        subsize,
        first: true,
    }
}

pub fn part_a(input: &str) -> Option<u64> {
    let rows = input
        .lines()
        .map(|l| l.split_once(' ').unwrap())
        .collect::<Vec<_>>();
    let mut sum = 0;
    for row in rows {
        let group_list = row
            .1
            .split(',')
            .map(|s| s.parse().unwrap())
            .collect::<Vec<usize>>();
        sum += get_valid_count(row.0, &group_list);
    }
    Some(sum)
}

pub fn part_b(_input: &str) -> Option<u64> {
    /*
     * Determine the count of valid substitutions for the original string,
     * and both for the original string with a "?" pre- and appended to it.
     * It seems like valid_subs_orig * max(valid_subs_pre, valid_subs_app)^4
     * lies pretty close to the solution. However, it fails to account for
     * some edge cases at the boundaries between repetitions and I don't think
     * this approach can account for those edge cases.
     */

    None
}
