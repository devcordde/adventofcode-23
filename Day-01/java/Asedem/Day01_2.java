package de.asedem;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {

    private static final String[] numbers = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};

    public static void main(String[] args) throws FileNotFoundException {
        int finalNumber = 0;
        try (Scanner scanner = new Scanner(new File("./inputs.txt"))) {
            while (scanner.hasNextLine()) {
                String text = scanner.nextLine();
                for (int i = 0; i < numbers.length; i++)
                    text = text.replaceAll(numbers[i], numbers[i] + (i + 1) + numbers[i]);
                text = text.replaceAll("\\D+","");
                finalNumber += (text.charAt(0) - '0') * 10 + text.charAt(text.length() - 1) - '0';
            }
        }
        System.out.println(finalNumber);
    }
}
