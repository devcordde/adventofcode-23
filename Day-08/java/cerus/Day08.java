import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Predicate;

public class Day08 {

    public static void main(final String[] args) throws IOException {
        // Part 2 was mostly solved with the help of Wikipedia
        //
        // https://en.wikipedia.org/wiki/Least_common_multiple:
        // "A far more efficient numerical algorithm can be obtained by using Euclid's algorithm to
        // compute the gcd first, and then obtaining the lcm by division."

        final List<String> input = new ArrayList<>(input());
        final RepeatingIterator<Direction> movementIter = parseMovement(input);
        final Map<String, Node> network = parseNetwork(input);

        final int steps = walkNetwork(List.of(
                new MovementTask(network, network.get("AAA"), node -> node.name().equals("ZZZ"))
        ), movementIter);
        System.out.println(steps);

        movementIter.reset();
        final Predicate<Node> cond = node -> node.name().endsWith("Z");
        final List<MovementTask> tasks = network.values().stream()
                .filter(node -> node.name().endsWith("A"))
                .map(node -> new MovementTask(network, node, cond))
                .toList();
        walkNetwork(tasks, movementIter);

        final long[] stepsArr = tasks.stream()
                .mapToLong(MovementTask::getSteps)
                .toArray();
        System.out.println(lcm(stepsArr));
    }

    private static int walkNetwork(final List<MovementTask> tasks, final Iterator<Direction> movementIter) {
        int steps = 0;
        while (!tasks.stream().allMatch(MovementTask::isFinished)) {
            final Direction dir = movementIter.next();
            for (final MovementTask task : tasks) {
                task.tick(dir);
            }
            steps += 1;
        }
        return steps;
    }

    private static Map<String, Node> parseNetwork(final List<String> input) {
        final Map<String, Node> network = new LinkedHashMap<>();
        while (!input.isEmpty()) {
            final String line = input.remove(0);
            final Node node = parseNode(line);
            network.put(node.name(), node);
        }
        return network;
    }

    private static Node parseNode(final String line) {
        String[] split = line.split(" = \\(");
        final String name = split[0];
        split = split[1].split(", ");
        final String left = split[0];
        final String right = split[1].substring(0, split[1].length() - 1);
        return new Node(name, left, right);
    }

    private static RepeatingIterator<Direction> parseMovement(final List<String> input) {
        final String movementStr = input.remove(0);
        input.remove(0); // Empty line

        final Direction[] directions = Arrays.stream(movementStr.split(""))
                .map(s -> s.charAt(0))
                .map(Direction::getByChar)
                .toArray(Direction[]::new);
        return new RepeatingIterator<>(directions);
    }

    private static List<String> input() throws IOException {
        return Files.readAllLines(Path.of("input.txt"));
    }

    private static long gcd(long a, long b) {
        // Thanks Wikipedia (https://en.wikipedia.org/wiki/Euclidean_algorithm#Implementations)
        long t;
        while (b != 0) {
            t = b;
            b = a % b;
            a = t;
        }
        return a;
    }

    private static long lcm(final long... nums) {
        long lcm = nums[0];
        for (int i = 1; i < nums.length; i++) {
            lcm = lcm(lcm, nums[i]);
        }
        return lcm;
    }

    private static long lcm(final long a, final long b) {
        final long gcd = gcd(a, b);
        return (a * b) / gcd;
    }

    private enum Direction {
        LEFT('L'),
        RIGHT('R');

        private final char c;

        Direction(final char c) {
            this.c = c;
        }

        public static Direction getByChar(final char c) {
            for (final Direction value : values()) {
                if (value.c == c) {
                    return value;
                }
            }
            throw new IllegalArgumentException();
        }

    }

    private static class MovementTask {

        private final Map<String, Node> network;
        private final Predicate<Node> finishCondition;
        private Node current;
        private boolean finished;
        private int steps;

        private MovementTask(final Map<String, Node> network, final Node start, final Predicate<Node> finishCondition) {
            this.network = network;
            this.current = start;
            this.finishCondition = finishCondition;
        }

        public void tick(final Direction dir) {
            if (this.finished) {
                return;
            }

            this.current = this.network.get(switch (dir) {
                case LEFT -> this.current.left();
                case RIGHT -> this.current.right();
            });
            this.finished = this.finishCondition.test(this.current);
            this.steps += 1;
        }

        public boolean isFinished() {
            return this.finished;
        }

        public int getSteps() {
            return this.steps;
        }

    }

    private record Node(String name, String left, String right) {
    }

    private static class RepeatingIterator<T> implements Iterator<T> {

        private final T[] source;
        private int index;

        private RepeatingIterator(final T[] source) {
            this.source = source;
        }

        @Override
        public boolean hasNext() {
            return this.source.length > 0;
        }

        @Override
        public T next() {
            if (this.index >= this.source.length) {
                this.index = 0;
            }
            return this.source[this.index++];
        }

        public void reset() {
            this.index = 0;
        }

    }

}
