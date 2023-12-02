import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day2 {

    public static void main(String[] args) throws IOException {
        List<String> lines = Files.readAllLines(Path.of("input.txt"));

        int sum = lines.stream()
                .mapToInt(Day2::parseGameString)
                .sum();

        int power = lines.stream()
                .mapToInt(Day2::power)
                .sum();

        System.out.printf("Ergebnis aus Part (1): %d%n ", sum);
        System.out.printf("Ergebnis aus Part (2): %d%n ", power);
    }

    public static int power(String line) {
        int red = findMaxNumber("red", line);
        int green = findMaxNumber("green", line);
        int blue = findMaxNumber("blue", line);

        return red * green * blue;
    }

    public static int findMaxNumber(String color, String lineSegment) {
        String[] array = lineSegment.split(" " + color);
        int max = 0;
        for (String a : array) {
            if (readNumber(a) > max) {
                max = readNumber(a);
            }
        }

        return max;
    }

    public static int parseGameString(String line) {
        int id = Integer.parseInt(line.split(": ")[0].replace("Game ", ""));
        String[] set = line.split("; ");

        for (String s : set) {
            int red = count("red", s);
            int green = count("green", s);
            int blue = count("blue", s);

            if (red > colorValue(Color.RED) || green > colorValue(Color.GREEN) || blue > colorValue(Color.BLUE))
                return 0;
        }
        return id;
    }

    private static int readNumber(String segment) {
        String[] array = segment.split(" ");
        try {
            return Integer.parseInt(array[array.length - 1]);
        } catch (Exception e) {
            return 0;
        }
    }

    private static int count(String color, String line) {
        String[] array = line.split(" " + color);
        int sum = 0;
        for (String a : array) {
            sum += readNumber(a);
        }

        return sum;
    }

    private static int colorValue(Color color) {
        return switch (color) {
            case RED -> 12;
            case GREEN -> 13;
            case BLUE -> 14;
        };
    }

    private enum Color {
        RED, GREEN, BLUE;
    }

}