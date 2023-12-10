import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

public class Day09 {

    public static void main(final String[] args) throws IOException {
        final List<int[]> histories = input()
                .map(Day09::parseHistory)
                .toList();
        Stream.of(true, false)
                .map(b -> histories.stream()
                        .mapToInt(value -> extrapolate(value, b))
                        .sum())
                .forEach(System.out::println);
    }

    private static int extrapolate(final int[] history, final boolean dir) {
        if (Arrays.stream(history).allMatch(i -> i == 0)) {
            return 0;
        }
        final int[] diff = new int[history.length - 1];
        for (int i = 0; i < diff.length; i++) {
            diff[i] = history[i + 1] - history[i];
        }
        return dir
                ? (history[history.length - 1] + extrapolate(diff, true))
                : (history[0] - extrapolate(diff, false));
    }

    private static int[] parseHistory(final String line) {
        return Arrays.stream(line.split("\\s+"))
                .mapToInt(Integer::parseInt)
                .toArray();
    }

    private static Stream<String> input() throws IOException {
        return Files.lines(Path.of("input.txt"));
    }

}
