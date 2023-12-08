import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicLong;
import java.util.stream.Collectors;

public class Day05 {

    private static final long OPS_PER_TASK = 100_000;
    private static final int TASKS = Runtime.getRuntime().availableProcessors();

    // AoC Day 5: Space-heater edition
    public static void main(final String[] args) throws IOException {
        final long now = System.currentTimeMillis();

        final List<String> input = new ArrayList<>(input());
        final List<Long> seeds = parseSeeds(input.remove(0));
        final List<SeedRange> seedRanges = new ArrayList<>();
        for (int i = 0; i < seeds.size(); i++) {
            seedRanges.add(new SeedRange(
                    seeds.get(i++),
                    seeds.get(i)
            ));
        }

        final Map<Key, Set<Range>> allRangeMaps = parseAllRangeMaps(input);
        final Chain chain = findChain(allRangeMaps, "seed", "location");
        final ExecutorService threadPool = Executors.newCachedThreadPool();

        final long nearestLoc = seeds.stream()
                .mapToLong(chain::evaluate)
                .min().orElse(-1);

        // Split all the work into 100k chunks
        final List<SolveTask> tasks = new CopyOnWriteArrayList<>();
        for (final SeedRange range : seedRanges) {
            long taken = 0;
            while (taken < range.length) {
                tasks.add(new SolveTask(chain, range, taken, OPS_PER_TASK));
                taken += OPS_PER_TASK;
            }
        }

        // Use all available cores to bruteforce the solution
        CompletableFuture<?> rootFuture = CompletableFuture.completedFuture(null);
        final AtomicLong lowest = new AtomicLong(Long.MAX_VALUE);
        for (int i = 0; i < TASKS; i++) {
            final CompletableFuture<?> future = new CompletableFuture<>();
            threadPool.submit(() -> {
                while (!tasks.isEmpty()) {
                    final SolveTask task = tasks.remove(0);
                    final long low = task.solve();
                    lowest.set(Math.min(lowest.get(), low));
                }
                future.complete(null);
            });
            rootFuture = rootFuture.thenCompose(o -> future);
        }

        System.out.println(nearestLoc);
        rootFuture.thenAccept(o -> {
            System.out.println(lowest.get());
            threadPool.shutdown();

            final long time = System.currentTimeMillis() - now;
            System.out.printf("Finished after %,d ms (%,d s)%n", time, time / 1000);
        });
    }

    private static List<Long> parseSeeds(final String str) {
        return Arrays.stream(str.split("\\s+"))
                .filter(s -> s.matches("\\d+"))
                .map(Long::parseLong)
                .collect(Collectors.toList());
    }

    private static Map<Key, Set<Range>> parseAllRangeMaps(final List<String> input) {
        final Map<Key, Set<Range>> allRangeMaps = new HashMap<>();
        while (!input.isEmpty()) {
            parseRangeMap(allRangeMaps, input);
        }
        return allRangeMaps;
    }

    private static void parseRangeMap(final Map<Key, Set<Range>> rangeMap, final List<String> input) {
        while (!input.isEmpty() && input.get(0).isBlank()) {
            input.remove(0);
        }
        if (input.isEmpty()) {
            return;
        }

        final String keyStr = input.remove(0);
        final String[] keySplit = keyStr.split("\\s+")[0].split("-to-");
        final Key key = new Key(keySplit[0], keySplit[1]);

        final Set<Range> ranges = new HashSet<>();
        while (!input.isEmpty() && !input.get(0).isBlank()) {
            ranges.add(parseRange(ranges, input.remove(0)));
        }
        rangeMap.put(key, ranges);
    }

    private static Range parseRange(final Set<Range> ranges, final String s) {
        final String[] split = s.split("\\s+");
        return new Range(
                Long.parseLong(split[0]),
                Long.parseLong(split[1]),
                Long.parseLong(split[2])
        );
    }

    // This method is kinda useless because you could simply hard-code the chain. When I
    // wrote this I thought the input would contain misleading & useless mappings, but that's not the case.
    private static Chain findChain(final Map<Key, Set<Range>> map, final String from, final String to) {
        final List<RangeMap> chain = new ArrayList<>();
        RangeMap current = findByDest(map, to);
        chain.add(current);
        while (!current.key().from().equals(from)) {
            current = findByDest(map, current.key().from());
            chain.add(0, current);
        }
        return new Chain(chain);
    }

    private static RangeMap findByDest(final Map<Key, Set<Range>> map, final String dest) {
        return map.entrySet().stream()
                .filter(e -> e.getKey().to().equals(dest))
                .map(e -> new RangeMap(e.getKey(), e.getValue()))
                .findAny().orElseThrow();
    }

    private static List<String> input() throws IOException {
        return Files.readAllLines(Path.of("input.txt"));
    }

    private record Key(String from, String to) {}

    private record Range(long destRangeStart, long srcRangeStart, long length) {

        public long convert(final long i) {
            if (i < this.srcRangeStart || i >= this.srcRangeStart + this.length) {
                throw new IllegalArgumentException();
            }
            return this.destRangeStart + (i - this.srcRangeStart);
        }

        public boolean isApplicable(final long i) {
            return i >= this.srcRangeStart && i < this.srcRangeStart + this.length;
        }

    }

    private record RangeMap(Key key, Set<Range> ranges) {}

    private record Chain(List<RangeMap> chain) {

        public long evaluate(long i) {
            for (final RangeMap map : this.chain) {
                i = this.eval(i, map.ranges());
            }
            return i;
        }

        private long eval(final long i, final Set<Range> ranges) {
            for (final Range range : ranges) {
                if (range.isApplicable(i)) {
                    return range.convert(i);
                }
            }
            return i;
        }

    }

    private record SeedRange(long start, long length) {
    }

    private record SolveTask(Chain chain, SeedRange range, long start, long amount) {

        public long solve() {
            long low = Long.MAX_VALUE;
            for (long i = 0; i < this.amount; i++) {
                if (i + this.start + this.range.start >= this.range.start + this.range.length) {
                    break;
                }
                low = Math.min(low, this.chain.evaluate(i + this.start + this.range.start));
            }
            return low;
        }

    }

}
