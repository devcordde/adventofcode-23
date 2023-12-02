import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Day02 {

    public static void main(final String[] args) throws IOException {
        final List<Game> games = Arrays.stream(input())
                .filter(s -> !s.isEmpty())
                .map(String::trim)
                .map(Day02::parse)
                .toList();

        int sum = games.stream()
                .filter(Game::isPossible)
                .mapToInt(Game::id)
                .sum();
        System.out.println(sum);
        sum = games.stream()
                .mapToInt(Game::calculatePower)
                .sum();
        System.out.println(sum);
    }

    private static Game parse(final String s) {
        String trimmed = s.substring(5);
        final int id = Integer.parseInt(trimmed.substring(0, trimmed.indexOf(':')));
        trimmed = trimmed.substring(trimmed.indexOf(':') + 2);

        final List<Map<Color, Integer>> pairs = new ArrayList<>();
        final String[] pairSplit = trimmed.split("; ");
        for (final String pair : pairSplit) {
            final Map<Color, Integer> pairMap = new HashMap<>();
            final String[] elementSplit = pair.split(", ");
            for (final String element : elementSplit) {
                final String[] split = element.split("\\s+");
                pairMap.put(Color.valueOf(split[1].toUpperCase()), Integer.parseInt(split[0]));
            }
            pairs.add(pairMap);
        }

        return new Game(id, pairs);
    }

    private static String[] input() throws IOException {
        return Files.readString(Path.of("input.txt")).split("\n");
    }

    private enum Color {
        RED(12),
        GREEN(13),
        BLUE(14);

        private final int limit;

        Color(final int limit) {
            this.limit = limit;
        }

        public int getLimit() {
            return this.limit;
        }

    }

    private record Game(int id, List<Map<Color, Integer>> pairs) {

        public int calculatePower() {
            final Map<Color, Integer> fewest = new HashMap<>();
            for (final Map<Color, Integer> pair : this.pairs) {
                for (final Map.Entry<Color, Integer> entry : pair.entrySet()) {
                    fewest.put(entry.getKey(), Math.max(
                            fewest.getOrDefault(entry.getKey(), Integer.MIN_VALUE),
                            entry.getValue()
                    ));
                }
            }
            return fewest.values().stream()
                    .reduce((l, r) -> l * r)
                    .orElse(0);
        }

        public boolean isPossible() {
            return this.pairs.stream()
                    .allMatch(m -> m.entrySet().stream()
                            .allMatch(e -> e.getValue() <= e.getKey().getLimit()));
        }

    }

}
