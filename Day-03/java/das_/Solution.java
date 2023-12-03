import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;

public class Solution {
    public static void main(String[] args) throws IOException {
        var lines = new ArrayList<>(Files.lines(Path.of("input.txt")).toList());
        lines.add(0, ".".repeat(lines.get(0).length()));
        lines.add(".".repeat(lines.get(0).length()));

        var orderedTriples = new ArrayList<OrderedTriple>();
        for (int i = 1; i < lines.size() - 1; i++) {
            orderedTriples.add(new OrderedTriple(lines.get(i - 1), lines.get(i), lines.get(i + 1)));
        }

        System.out.println("Part 1: " + orderedTriples.stream().mapToInt(Main::part1).sum());
        System.out.println("Part 2: " + orderedTriples.stream().mapToInt(Main::part2).sum());
    }

    private static int part1(OrderedTriple orderedTriple) {
        var numbers = getNumbers(orderedTriple.current);
        var total = 0;

        for (var number : numbers) {
            var substring = sub(orderedTriple.last, number) + sub(orderedTriple.current, number) + sub(orderedTriple.next, number);
            if (substring.matches(".*[^0-9.].*")) {
                total += number.value;
            }
        }

        return total;
    }

    private static int part2(OrderedTriple orderedTriple) {
        var stars = new ArrayList<Integer>();
        for (int i = 0; i < orderedTriple.current.toCharArray().length; i++) {
            var character = orderedTriple.current.charAt(i);
            if (character == '*') stars.add(i);
        }

        var numbers = getNumbers(orderedTriple.current);
        numbers.addAll(getNumbers(orderedTriple.last));
        numbers.addAll(getNumbers(orderedTriple.next));

        var total = 0;
        for (var star : stars) {
            var adjacentNumbers = new ArrayList<Integer>();

            for (var number : numbers) {
                if (star >= number.startIndex - 1 && star <= number.endIndex + 1) {
                    adjacentNumbers.add(number.value);
                }
            }

            if (adjacentNumbers.size() == 2) {
                total += adjacentNumbers.stream().mapToInt(e -> e).reduce((id, e) -> id * e).getAsInt();
            }
        }

        return total;
    }

    private static ArrayList<Number> getNumbers(String currentLine) {
        var numbers = new ArrayList<Number>();

        var currentNumber = "";
        int start = -1;
        for (int i = 0; i < currentLine.toCharArray().length; i++) {
            var currentChar = String.valueOf(currentLine.charAt(i));
            if (currentChar.matches("\\d+")) {
                if (currentNumber.isEmpty()) start = i;

                currentNumber += currentChar;
            } else if (!currentNumber.isEmpty()) {
                numbers.add(new Number(Integer.parseInt(currentNumber), start, i - 1));
                currentNumber = "";
            }
        }

        if (!currentNumber.isEmpty()) {
            numbers.add(new Number(Integer.parseInt(currentNumber), start, currentLine.length()));
        }

        return numbers;
    }

    private static String sub(String line, Number number) {
        return line.substring(Math.max(0, number.startIndex - 1), Math.min(line.length(), number.endIndex + 2));
    }

    record OrderedTriple(String last, String current, String next) {}
    record Number(int value, int startIndex, int endIndex) {}
}
