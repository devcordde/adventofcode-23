package fyi.pauli.aoc.v2023.days

import invoke
import kotlin.properties.Delegates
import kotlin.time.times

/**
 * @author Paul Kindler
 * @since 02/12/2023
 * Maybe needs a second look, but i have a basketball game today so its fine.
 */
val secondOf2023 = 2023.2 {
	first {
		val possible = mapOf("red" to 12, "green" to 13, "blue" to 14)

		inputLines.sumOf { line ->
			val (game, setLine) = line.split(":")

			if (setLine.split(";").all { set ->
					!set.split(",").any {
						val (amount, color) = it.trim().split(" ")
						amount.toInt() > possible[color]!!
					}
				}) game.filter { it.isDigit() }.toInt() else 0
		}
	}

	second {
		inputLines.sumOf { line ->
			val leastPossible = mutableMapOf<String, Int>()

			line.split(":")[1].split(";").forEach { set ->
				set.split(",").forEach {
					val (amount, color) = it.trim().split(" ")
					if ((leastPossible[color] ?: amount.toInt()) <= amount.toInt()){
						leastPossible[color] = amount.toInt()
					}
				}
			}
			leastPossible.values.reduce { acc, i -> acc * i }
		}
	}
}