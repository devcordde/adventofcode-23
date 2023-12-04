import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day04 {

    public static void main(final String[] args) throws IOException {
        final List<Card> cards = input()
                .filter(s -> !s.isBlank())
                .map(Day04::parse)
                .toList();
        final Map<Integer, Integer> occurenceMap = new HashMap<>();

        final int sum = cards.stream()
                .mapToInt(Card::calculatePoints)
                .sum();
        System.out.println(sum);

        int checkedCards = 0;
        for (final Card card : cards) {
            final int occurrences = occurenceMap.getOrDefault(card.id, 0) + 1;
            for (int i = 0; i < card.countWinningNumbers(); i++) {
                occurenceMap.compute(card.id + i + 1,
                        (k, v) -> v == null ? occurrences : v + occurrences);
            }
            checkedCards += occurrences;
        }
        System.out.println(checkedCards);
    }

    private static Card parse(final String s) {
        final int id = Integer.parseInt(s.substring(5).split(":")[0].trim());
        final String[] numSplit = s.substring(s.indexOf(':') + 1).split("\\|");
        return new Card(id, toSet(numSplit[0]), toSet(numSplit[1]));
    }

    private static Set<Integer> toSet(final String s) {
        return Arrays.stream(s.trim().split("\\s+"))
                .map(Integer::parseInt)
                .collect(Collectors.toSet());
    }

    private static Stream<String> input() throws IOException {
        return Files.lines(Path.of("input.txt"));
    }

    private record Card(int id, Set<Integer> winningNumbers, Set<Integer> numbers) {

        public int countWinningNumbers() {
            return (int) this.numbers.stream().filter(this.winningNumbers::contains).count();
        }

        public int calculatePoints() {
            return (int) Math.pow(2, this.countWinningNumbers() - 1);
        }

    }

}
