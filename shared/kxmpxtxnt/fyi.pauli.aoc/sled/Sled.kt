package fyi.pauli.aoc.sled

import Task
import com.github.ajalt.mordant.rendering.TextColors.red
import fyi.pauli.aoc.sled.prompt.askDay
import fyi.pauli.aoc.sled.prompt.askYear
import fyi.pauli.aoc.v2015.`2015`
import fyi.pauli.aoc.v2023.`2023`
import invoke
import terminal

/**
 * @author Paul Kindler
 * @since 25/11/2023
 */
fun main() = Sled().handOutGifts()

class Sled {

	private val collection: Map<Int, Set<Task>> = mapOf(
		2015 to `2015`,
		2023 to `2023`
	)

	fun handOutGifts() {
		val year = askYear(terminal)

		if (!collection.containsKey(year)) {
			terminal.println(red("Sadly this year is not implemented yet."))
			handOutGifts()
			return
		}

		val yearCollection = collection[year]!!

		val day = askDay(terminal)

		val task = yearCollection.find { it.localDate.dayOfMonth == day }

		if (task == null) {
			terminal.println(red("Sadly this day is not implemented yet."))
			handOutGifts()
			return
		}

		task.run()
	}
}

val task = 2023.1 {
	first {
		//do your code stuff
		"Paul"
	}

	second {
		//do the other code stuff
		17
	}
}