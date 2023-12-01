package rechergg;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

public class Day1 {

    private static final String[] NUMBERS = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};

    public static void main(String[] args) throws IOException {
        String content = Files.readString(Path.of("./Day-01/java/rechergg/input.txt"));

        System.out.printf("Ergebnis aus Part (1): %d%n", content.lines().mapToInt(line -> findFirstNumber(line) + findLastNumber(line)).sum());

        for (int i = 0; i < NUMBERS.length; i++) {
            content = content.replaceAll(NUMBERS[i], NUMBERS[i] + (i + 1) + NUMBERS[i]);
        }

        System.out.printf("Ergebnis aus Part (2): %d%n", content.lines().mapToInt(line -> findFirstNumber(line) + findLastNumber(line)).sum());
    }

    public static int findFirstNumber(String line) {
        for (int i = 0; i < line.length(); i++) {
            int charAsNumber = Character.getNumericValue(line.charAt(i));
            if (charAsNumber >= 1 && charAsNumber <= 9) {
                return charAsNumber * 10;
            }
        }
        return 0;
    }

    public static int findLastNumber(String content) {
        for (int i = content.length() - 1; i >= 0; i--) {
            int charAsNumber = Character.getNumericValue(content.charAt(i));
            if (charAsNumber >= 1 && charAsNumber <= 9) {
                return charAsNumber;
            }
        }
        return 0;
    }
}