import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.LongStream;

public class Day06 {

    private static final int MM_PER_MS = 1;

    public static void main(final String[] args) throws IOException {
        final String[] input = input().trim().split("\n");
        List<Race> races = parseRaces(input[0], input[1], true);
        solve(races);
        races = parseRaces(input[0], input[1], false);
        solve(races);
    }

    private static void solve(final List<Race> races) {
        final int product = races.stream()
                .mapToInt(race -> (int) LongStream.range(0, race.time + 1)
                        .filter(race::beatsTime)
                        .count())
                .reduce((l, r) -> l * r)
                .orElse(0);
        System.out.println(product);
    }

    private static String input() throws IOException {
        return Files.readString(Path.of("input.txt"));
    }

    private static List<Race> parseRaces(final String timeStr, final String distStr, final boolean noLimit) {
        final String[] timeSplit = timeStr.split("\\s+", noLimit ? 0 : 2);
        final String[] distSplit = distStr.split("\\s+", noLimit ? 0 : 2);
        final List<Race> races = new ArrayList<>();
        for (int i = 1; i < timeSplit.length; i++) {
            races.add(new Race(
                    Long.parseLong(timeSplit[i].replaceAll("\\s+", "")),
                    Long.parseLong(distSplit[i].replaceAll("\\s+", ""))
            ));
        }
        return races;
    }

    private record Race(long time, long distance) {

        public boolean beatsTime(final long pressedMillis) {
            final long remainingTime = this.time - pressedMillis;
            final long distTravelled = remainingTime * pressedMillis * MM_PER_MS;
            return distTravelled > this.distance;
        }

    }

}
