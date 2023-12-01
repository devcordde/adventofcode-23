import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

public class Main {
    private static final List<String> numbers = List.of("one", "two", "three", "four", "five", "six", "seven", "eight", "nine");

    public static void main(String[] args) throws IOException {
        var path = Path.of("input.txt");
        System.out.println("Part 1: " + Files.lines(path).mapToInt(line -> Main.getNumber(line, 0, line.length() - 1)).sum());
        System.out.println("Part 2: " + Files.lines(path).map(Main::sanitizeInput).mapToInt(line -> Main.getNumber(line, 0, line.length() - 1)).sum());
    }

    private static int getNumber(String line, int firstIndex, int lastIndex) {
        var firstFound = String.valueOf(line.charAt(firstIndex)).matches("\\d");
        var lastFound = String.valueOf(line.charAt(lastIndex)).matches("\\d");

        if (firstFound && lastFound) return Integer.parseInt(line.charAt(firstIndex) + "" + line.charAt(lastIndex));

        return getNumber(line, firstFound ? firstIndex : firstIndex + 1, lastFound ? lastIndex : lastIndex - 1);
    }

    private static String sanitizeInput(String l) {
        String line = l;
        for (int i = 0; i < numbers.size(); i++) {
            var number = numbers.get(i);
            while (line.contains(number)) {
                line = line.replaceFirst(number, "" + number.charAt(0) + (i + 1) + number.charAt(number.length() - 1));
            }
        }
        return line;
    }
}
