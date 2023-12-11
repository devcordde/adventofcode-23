import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.function.BiPredicate;
import java.util.function.Consumer;

public class Day11 {

    public static void main(final String[] args) throws IOException {
        solve(1);
        solve(1_000_000 - 1); // Don't ask me how long it took to figure out I need to subtract one
    }

    private static void solve(final int expandFactor) throws IOException {
        final List<Galaxy> galaxies = new ArrayList<>();
        final List<Integer> emptyRows = new ArrayList<>();
        final List<Integer> emptyCols = new ArrayList<>();
        final List<String> input = input();

        for (int y = 0; y < input.size(); y++) {
            parseGalaxies(galaxies, y, input.get(y));
        }
        parseEmpties(emptyRows, emptyCols, input);
        expand(galaxies, emptyRows, emptyCols, expandFactor);

        long sum = 0;
        for (int i = 0; i < galaxies.size() - 1; i++) {
            for (int j = i + 1; j < galaxies.size(); j++) {
                sum += manhattanDistance(galaxies.get(i), galaxies.get(j));
            }
        }
        System.out.println(sum);
    }

    private static void expand(final List<Galaxy> galaxies, final List<Integer> emptyRows, final List<Integer> emptyCols, final int expandFactor) {
        expand(galaxies, emptyRows, expandFactor, (g, y) -> g.y() > y, g -> g.incrementY(expandFactor));
        expand(galaxies, emptyCols, expandFactor, (g, x) -> g.x() > x, g -> g.incrementX(expandFactor));
    }

    private static void expand(final List<Galaxy> galaxies,
                               final List<Integer> empty,
                               final int expandFactor,
                               final BiPredicate<Galaxy, Integer> test,
                               final Consumer<Galaxy> action) {
        for (int i = 0; i < empty.size(); i++) {
            final int n = empty.get(i);
            galaxies.stream()
                    .filter(g -> test.test(g, n))
                    .forEach(action);
            for (int j = i + 1; j < empty.size(); j++) {
                empty.set(j, empty.get(j) + expandFactor);
            }
        }
    }

    private static void parseEmpties(final List<Integer> rows, final List<Integer> cols, final List<String> input) {
        for (int y = 0; y < input.size(); y++) {
            if (input.get(y).matches("\\.+")) {
                rows.add(y);
            }
        }
        outer:
        for (int x = 0; x < input.get(0).length(); x++) {
            for (final String row : input) {
                if (row.charAt(x) != '.') {
                    continue outer;
                }
            }
            cols.add(x);
        }
    }

    private static void parseGalaxies(final List<Galaxy> output, final int y, final String line) {
        final char[] chars = line.toCharArray();
        for (int x = 0; x < chars.length; x++) {
            if (chars[x] == '#') {
                output.add(new Galaxy(x, y));
            }
        }
    }

    private static long manhattanDistance(final Galaxy a, final Galaxy b) {
        return Math.abs(a.x() - b.x()) + Math.abs(a.y() - b.y());
    }

    private static List<String> input() throws IOException {
        return Files.readAllLines(Path.of("input.txt"));
    }

    private static final class Galaxy {

        private long x;
        private long y;

        private Galaxy(final long x, final long y) {
            this.x = x;
            this.y = y;
        }

        public void incrementX(final long by) {
            this.x += by;
        }

        public void incrementY(final long by) {
            this.y += by;
        }

        public long x() {
            return this.x;
        }

        public long y() {
            return this.y;
        }

    }

}
