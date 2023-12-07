import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day07 {

    private static final List<Character> FIRST_CARD_ORDER = List.of('A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2');
    private static final List<Character> SECOND_CARD_ORDER = List.of('A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J');

    private static final Map<List<Integer>, HandType> COUNT_TO_HAND_TYPE = Map.of(
            List.of(5), HandType.FIVE_OF_A_KIND,
            List.of(1, 4), HandType.FOUR_OF_A_KIND,
            List.of(2, 3), HandType.FULL_HOUSE,
            List.of(1, 1, 3), HandType.THREE_OF_A_KIND,
            List.of(1, 2, 2), HandType.TWO_PAIR,
            List.of(1, 1, 1, 2), HandType.ONE_PAIR,
            List.of(1, 1, 1, 1, 1), HandType.HIGH_CARD
    );

    private static boolean JOKERS;

    public static void main(final String[] args) throws IOException {
        solve(false);
        solve(true);
    }

    private static void solve(final boolean jokers) throws IOException {
        JOKERS = jokers;
        final List<Hand> rankedHands = input()
                .map(Day07::parseHand)
                .sorted()
                .toList();

        int sum = 0;
        for (int i = 0; i < rankedHands.size(); i++) {
            final Hand hand = rankedHands.get(i);
            sum += (rankedHands.size() - i) * hand.bid();
        }
        System.out.println(sum);
    }

    private static Hand parseHand(final String line) {
        final String[] split = line.split("\\s+", 2);
        final char[] hand = split[0].toCharArray();
        final HandType handType = determineType(hand);
        final int bid = Integer.parseInt(split[1]);
        return new Hand(hand, handType, bid);
    }

    private static HandType determineType(final char[] hand) {
        final List<Integer> count = count(hand);
        if (JOKERS && count.size() > 1) {
            final int jokers = count.remove(0);
            count.set(count.size() - 1, count.get(count.size() - 1) + jokers);
        }
        return COUNT_TO_HAND_TYPE.get(count);
    }

    private static List<Integer> count(final char[] cards) {
        final Map<Character, Integer> occurrences = new HashMap<>();
        for (final char card : cards) {
            occurrences.compute(card, (c, count) -> count == null ? 1 : count + 1);
        }
        if (JOKERS && !occurrences.containsKey('J')) {
            // I forgot to add this little if statement at first. These three lines of code cost me way too much time...
            occurrences.put('J', 0);
        }
        return occurrences.entrySet().stream()
                .sorted(Comparator.comparingInt(value -> JOKERS && value.getKey() == 'J' ? Integer.MIN_VALUE : value.getValue())) // If JOKERS == true, put count of J at the bottom
                .map(Map.Entry::getValue)
                .collect(Collectors.toList());
    }

    private static Stream<String> input() throws IOException {
        return Files.lines(Path.of("input.txt"));
    }

    private enum HandType {
        FIVE_OF_A_KIND,
        FOUR_OF_A_KIND,
        FULL_HOUSE,
        THREE_OF_A_KIND,
        TWO_PAIR,
        ONE_PAIR,
        HIGH_CARD
    }

    private record Hand(char[] cards, HandType type, int bid) implements Comparable<Hand> {

        @Override
        public int compareTo(final Hand o) {
            if (this.type().ordinal() > o.type().ordinal()) {
                return 1;
            }
            if (this.type().ordinal() < o.type().ordinal()) {
                return -1;
            }
            for (int cidx = 0; cidx < 5; cidx++) {
                final char ours = this.cards[cidx];
                final char theirs = o.cards[cidx];
                if (ours == theirs) {
                    continue;
                }
                return JOKERS
                        ? Integer.compare(SECOND_CARD_ORDER.indexOf(ours), SECOND_CARD_ORDER.indexOf(theirs))
                        : Integer.compare(FIRST_CARD_ORDER.indexOf(ours), FIRST_CARD_ORDER.indexOf(theirs));
            }
            return 0;
        }

    }

}
