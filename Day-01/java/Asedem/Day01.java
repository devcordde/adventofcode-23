package de.asedem;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Main {

    public static void main(String[] args) throws FileNotFoundException {
        int finalNumber = 0;
        try (final Scanner scanner = new Scanner(new File("./inputs.txt"))) {
            while (scanner.hasNextLine()) {
                final String text = scanner.nextLine().replaceAll("\\D+", "");
                int finalTempNumber = (text.charAt(0) - '0') * 10 + text.charAt(text.length() - 1) - '0';
                finalNumber += finalTempNumber;
            }
        }
        System.out.println(finalNumber);
    }
}
