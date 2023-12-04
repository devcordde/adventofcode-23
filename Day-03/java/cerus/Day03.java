import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Day03 {

    private static final Pattern NUMBER_PATTERN = Pattern.compile("\\d+");

    public static void main(final String[] args) throws IOException {
        final List<String> lines = Arrays.stream(input())
                .filter(s -> !s.isBlank())
                .toList();
        final List<Num> nums = parseNumbers(lines);
        final List<Sym> syms = parseSymbols(lines);

        int sum = nums.stream()
                .filter(num -> syms.stream().anyMatch(num::isAdjacentTo))
                .mapToInt(Num::number)
                .sum();
        System.out.println(sum);
        sum = syms.stream()
                .filter(sym -> nums.stream()
                                       .filter(n -> n.isAdjacentTo(sym))
                                       .count() == 2)
                .mapToInt(sym -> nums.stream()
                        .filter(n -> n.isAdjacentTo(sym))
                        .mapToInt(Num::number)
                        .reduce((l, r) -> l * r)
                        .orElse(0))
                .sum();
        System.out.println(sum);
    }

    private static List<Sym> parseSymbols(final List<String> lines) {
        final List<Sym> syms = new ArrayList<>();
        for (int y = 0; y < lines.size(); y++) {
            final char[] line = lines.get(y).toCharArray();
            for (int x = 0; x < line.length; x++) {
                final char c = line[x];
                if (c != '.' && !Character.isDigit(c)) {
                    syms.add(new Sym(c, y, x));
                }
            }
        }
        return syms;
    }

    private static List<Num> parseNumbers(final List<String> lines) {
        final List<Num> nums = new ArrayList<>();
        for (int y = 0; y < lines.size(); y++) {
            final String line = lines.get(y);
            final Matcher matcher = NUMBER_PATTERN.matcher(line);
            while (matcher.find()) {
                final int i = Integer.parseInt(line.substring(matcher.start(), matcher.end()));
                nums.add(new Num(i, y, matcher.start(), matcher.end() - 1));
            }
        }
        return nums;
    }

    private static String[] input() throws IOException {
        return Files.readString(Path.of("input.txt")).split("\n");
    }

    private record Num(int number, int y, int xStart, int xEnd) {

        public boolean isAdjacentTo(final Sym sym) {
            return Math.abs(this.y() - sym.y()) <= 1 && sym.x() <= this.xEnd + 1 && sym.x() >= this.xStart - 1;
        }

    }

    private record Sym(char character, int y, int x) {}

}
