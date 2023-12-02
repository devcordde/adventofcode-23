package main

import (
	"adventofcode-23/utils"
	"fmt"
	"regexp"
	"strconv"
)

var translate = map[string]string{
	"one":   "1",
	"two":   "2",
	"three": "3",
	"four":  "4",
	"five":  "5",
	"six":   "6",
	"seven": "7",
	"eight": "8",
	"nine":  "9",
}

func main() {
	filename := "input/input-1.txt"
	fmt.Println("Part 1:", day1part1(readAllLines(filename)))
}

func day1part1(lines []string) int {
	sum := 0
	for _, line := range lines {
		re := regexp.MustCompile("[0-9]")
		numbers := re.FindAllString(line, -1)
		i1 := utils.StringToInt(numbers[0])
		i2 := utils.StringToInt(numbers[len(numbers)-1])
		str := "" + strconv.Itoa(i1) + strconv.Itoa(i2)
		sum += utils.StringToInt(str)
	}

	return sum
}

func translateIfNecessary(s string) string {
	num, err := strconv.Atoi(s)
	if err != nil {
		return translate[s]
	}
	return strconv.Itoa(num)
}
