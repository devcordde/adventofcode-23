import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;

public class Day01 {

    private static final String[] NUMBERS = new String[] {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};
    private static final int[] NO_INDEX = new int[] {0, -1};

    public static void main(final String[] args) throws IOException {
        // I deliberately decided against using Regex.

        final String[] input = input();
        int sum = Arrays.stream(input)
                .filter(s -> !s.isEmpty())
                .mapToInt(s -> digit(s.trim()))
                .sum();
        System.out.println(sum);
        sum = Arrays.stream(input)
                .filter(s -> !s.isEmpty())
                .map(Day01::transform)
                .mapToInt(s -> digit(s.trim()))
                .sum();
        System.out.println(sum);
    }

    private static int digit(final String s) {
        final char[] chars = s.toCharArray();
        int a = -1;
        int b = 0;
        for (final char c : chars) {
            if (Character.isDigit(c)) {
                b = c - '0';
                if (a == -1) {
                    a = b;
                }
            }
        }
        return a * 10 + b;
    }

    private static String transform(String s) {
        s = transformSingle(s, index(s, true));
        s = transformSingle(s, index(s, false));
        return s;
    }

    private static String transformSingle(final String s, final int[] arr) {
        return arr[1] == -1 ? s : s.substring(0, arr[1]) + (arr[0] + 1) + s.substring(arr[1]);
    }

    private static int[] index(final String s, final boolean dir) {
        boolean found = false;
        int strIndex = dir ? Integer.MAX_VALUE : Integer.MIN_VALUE;
        int numIndex = 0;
        for (int i = 0; i < NUMBERS.length; i++) {
            final int idx = dir ? s.indexOf(NUMBERS[i]) : s.lastIndexOf(NUMBERS[i]);
            if (idx != -1 && ((dir && idx < strIndex) || (!dir && idx > strIndex))) {
                strIndex = idx;
                numIndex = i;
                found = true;
            }
        }
        return found ? new int[] {numIndex, strIndex} : NO_INDEX;
    }

    private static String[] input() throws IOException {
        return Files.readString(Path.of("input.txt")).split("\n");
    }

}
