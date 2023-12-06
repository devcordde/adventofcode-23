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
        final List<Race> races = parseRaces(input[0], input[1]);

        solve(races);
        combine(races);
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

    private static void combine(final List<Race> races) {
        final StringBuilder time = new StringBuilder();
        final StringBuilder dist = new StringBuilder();
        for (final Race race : races) {
            time.append(race.time);
            dist.append(race.distance);
        }
        races.clear();
        races.add(new Race(
                Long.parseLong(time.toString()),
                Long.parseLong(dist.toString())
        ));
    }

    private static List<Race> parseRaces(final String timeStr, final String distStr) {
        final String[] timeSplit = timeStr.split("\\s+");
        final String[] distSplit = distStr.split("\\s+");
        final List<Race> races = new ArrayList<>();
        for (int i = 1; i < timeSplit.length; i++) {
            races.add(new Race(
                    Long.parseLong(timeSplit[i]),
                    Long.parseLong(distSplit[i])
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
