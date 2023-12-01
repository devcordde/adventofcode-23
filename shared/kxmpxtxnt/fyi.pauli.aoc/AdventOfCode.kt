import com.github.ajalt.mordant.rendering.TextColors.*
import com.github.ajalt.mordant.rendering.TextStyles.bold
import com.github.ajalt.mordant.terminal.Terminal
import kotlinx.datetime.LocalDate
import java.nio.file.Path
import java.nio.file.Paths
import java.time.Month
import kotlin.io.path.readLines
import kotlin.io.path.readText
import kotlin.time.measureTime

/**
 * @author Paul Kindler
 * @since 24/11/2023
 */

class Task(val run: () -> Any, val localDate: LocalDate)

val terminal = Terminal()

operator fun Double.invoke(run: AdventOfCode.() -> Unit): Task {
	val (year, day) = this.toString().split(".").map { it.toInt() }
	return Task(
		{ AdventOfCode(year, day, run).start() },
		LocalDate(
			year, Month.DECEMBER, day
		)
	)
}

open class AdventOfCode(
	year: Int,
	day: Int,
	val run: AdventOfCode.() -> Unit
) {

	private val path: Path =
		Paths.get(ClassLoader.getSystemResource("$year-${day.toString().padStart(2, '0')}.txt").toURI())

	val inputLines: List<String> = path.readLines()
	var input: String = path.readText()

	private var first: (() -> Any) = {}

	fun first(runFirst: () -> Any) {
		first = runFirst
	}

	private var second: (() -> Any) = {}

	fun second(runSecond: () -> Any) {
		second = runSecond
	}

	private fun startPart(partName: String, partBlock: (() -> Any)) {
		var outcome: Any?

		val time = measureTime {
			outcome = partBlock.invoke()
		}

		terminal.println(
			blue("Outcome of ") +
					(brightGreen + bold)("'$partName' ") +
					(blue)("is ") +
					(brightMagenta + bold)("'$outcome'") +
					(blue)(", it took ") +
					(magenta)("${time.inWholeNanoseconds}ns | ${time.inWholeMilliseconds}ms | ${time.inWholeSeconds}s ") +
					(blue)("to finish.")
		)
	}

	fun start() {
		run()
		startPart("Part 1", first)
		run()
		startPart("Part 2", second)
	}
}
