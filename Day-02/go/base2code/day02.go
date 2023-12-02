package main

import (
	"adventofcode-23/utils"
	"fmt"
	"math"
	"regexp"
	"strings"
)

func main() {
	filename := "input.txt"
	fmt.Println("Part 1:", day2part1(utils.ReadAllLines(filename)))
	fmt.Println("Part 2:", day2part2(utils.ReadAllLines(filename)))
}

func day2part1(lines []string) string {
	sum := 0

	for _, line := range lines {
		split1 := strings.Split(line, ":")
		gameId := strings.Split(split1[0], " ")[1]

		sets := strings.Split(split1[1], ";")

		valid := true

		for _, set := range sets {
			blue := find("blue", set)
			red := find("red", set)
			green := find("green", set)

			if blue > 14 || red > 12 || green > 13 {
				valid = false
				break
			}
		}

		if valid {
			sum += utils.StringToInt(gameId)
		}
	}

	return fmt.Sprint(sum)
}

func day2part2(lines []string) string {
	sum := 0

	for _, line := range lines {
		split1 := strings.Split(line, ":")

		sets := strings.Split(split1[1], ";")

		blue := 0
		red := 0
		green := 0

		for _, set := range sets {
			blue1 := find("blue", set)
			red1 := find("red", set)
			green1 := find("green", set)

			blue = int(math.Max(float64(blue), float64(blue1)))
			red = int(math.Max(float64(red), float64(red1)))
			green = int(math.Max(float64(green), float64(green1)))
		}

		power1 := blue * red * green
		sum += power1
	}

	return fmt.Sprint(sum)
}

func find(color string, set string) int {
	colorFind := regexp.MustCompile(" \\d* "+color).FindAllString(set, -1)
	if len(colorFind) > 0 {
		return utils.StringToInt(strings.Split(strings.Replace(colorFind[0], " ", "", 1), " ")[0])
	}
	return 0
}
