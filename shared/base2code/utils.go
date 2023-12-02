package utils

import (
	"bufio"
	"log"
	"os"
	"strconv"
)

func ReadAllLines(filename string) []string {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines
}

func StringToInt(s string) int {
	i, _ := strconv.Atoi(s)
	return i
}
