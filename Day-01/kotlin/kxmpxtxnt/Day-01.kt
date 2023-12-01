package fyi.pauli.aoc.v2023.days

import invoke

/**
 * @author Paul Kindler
 * @since 01/12/2023
 */
val firstOf2023 = 2023.1 {
	first {
		inputLines.sumOf { line ->
			line.filter {
				it.digitToIntOrNull() != null
			}.run { "${first()}${last()}".toInt() }
		}
	}

	second {
		val digitStrings = setOf("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")

		inputLines.sumOf { line ->

			val numbers = ArrayDeque<Int>()

			line.forEachIndexed { index, c ->
				if (c.digitToIntOrNull() != null) numbers += c.digitToInt()
				digitStrings.forEachIndexed { stringsIndex, number ->
					if (line.drop(index).startsWith(number)) numbers += stringsIndex + 1
				}
			}
			"${numbers.first()}${numbers.last()}".toInt()
		}
	}
}