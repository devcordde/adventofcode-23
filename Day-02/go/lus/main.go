package main

import (
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"
)

type Set struct {
	Red   int
	Green int
	Blue  int
}

func main() {
	raw, err := io.ReadAll(os.Stdin)
	must(err)
	lines := strings.Split(strings.TrimSpace(string(raw)), "\n")

	games := make([][]*Set, len(lines))
	for i, line := range lines {
		rawSets := strings.Split(strings.Split(line, ":")[1], ";")
		sets := make([]*Set, len(rawSets))
		for is, rawSet := range rawSets {
			set := new(Set)
			for _, part := range strings.Split(rawSet, ",") {
				split := strings.Split(strings.TrimSpace(part), " ")

				num, err := strconv.Atoi(split[0])
				must(err)

				switch split[1] {
				case "red":
					set.Red = num
					break
				case "green":
					set.Green = num
					break
				case "blue":
					set.Blue = num
					break
				default:
					break
				}
			}
			sets[is] = set
		}

		games[i] = sets
	}

	sum := 0
	for i, game := range games {
		possible := true
		for _, set := range game {
			if set.Red > 12 || set.Green > 13 || set.Blue > 14 {
				possible = false
				break
			}
		}
		if possible {
			sum += i + 1
		}
	}

	power := 0
	for _, game := range games {
		maxSet := new(Set)
		for _, set := range game {
			if set.Red > maxSet.Red {
				maxSet.Red = set.Red
			}
			if set.Green > maxSet.Green {
				maxSet.Green = set.Green
			}
			if set.Blue > maxSet.Blue {
				maxSet.Blue = set.Blue
			}
		}
		power += maxSet.Red * maxSet.Green * maxSet.Blue
	}

	fmt.Printf("The sum of the IDs of all possible games is %d.\n", sum)
	fmt.Printf("The sum of the powers of all games is %d.\n", power)
}

func must(err error) {
	if err != nil {
		panic(err)
	}
}
