import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayDeque;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Deque;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;

public class Day10 {

    private static final Map<Character, Pipe> PIPE_CHAR_MAP = Map.of(
            '|', Pipe.VERTICAL,
            '-', Pipe.HORIZONTAL,
            'L', Pipe.BEND_NORTH_EAST,
            'J', Pipe.BEND_NORTH_WEST,
            '7', Pipe.BEND_SOUTH_WEST,
            'F', Pipe.BEND_SOUTH_EAST,
            'S', Pipe.START
    );

    public static void main(final String[] args) throws IOException {
        final List<String> input = input();
        final Node[][] grid = new Node[input.size()][];
        for (int i = 0; i < input.size(); i++) {
            grid[i] = parseGridRow(i, input.get(i));
        }

        final Node start = Arrays.stream(grid)
                .flatMap(Arrays::stream)
                .filter(o -> o.pipe() == Pipe.START)
                .findAny().orElseThrow();
        setSteps(grid, start);

        final Node farthest = Arrays.stream(grid)
                .flatMap(Arrays::stream)
                .max(Comparator.comparingDouble(Node::steps))
                .orElseThrow();
        System.out.println(farthest.steps());

        int enclosed = 0;
        for (int y = 0; y < grid.length; y++) {
            for (int x = 0; x < grid[y].length; x++) {
                if (grid[y][x].parent() == null) {
                    // To avoid confusing the even-odd rule algorithm we replace each tile that's not part of our loop with a placeholder pipe
                    // Since we shoot rays upwards we won't run into any issues with tiles that haven't been replaced yet
                    grid[y][x] = new Node(Pipe.DISCONNECTED, x, y);
                }
                if (grid[y][x].pipe() == Pipe.DISCONNECTED && isInside(grid, x, y)) {
                    enclosed += 1;
                }
            }
        }
        System.out.println(enclosed);
    }

    private static void setSteps(final Node[][] grid, final Node start) {
        for (final Node[] nodes : grid) {
            for (final Node node : nodes) {
                node.setSteps(-1);
            }
        }
        start.setSteps(0);

        final Deque<Node> deque = new ArrayDeque<>();
        deque.push(start);

        while (!deque.isEmpty()) {
            final Node node = deque.pop();
            final Set<Node> neighbours = getNeighbours(grid, node);
            for (final Node neighbour : neighbours) {
                final int steps = node.steps() + 1;
                if (steps < neighbour.steps() || neighbour.steps() == -1) {
                    neighbour.setSteps(steps);
                    neighbour.setParent(node);
                    deque.push(neighbour);
                }
            }
        }
    }

    private static Set<Node> getNeighbours(final Node[][] grid, final Node node) {
        final Set<Node> neighbours = new HashSet<>();
        if (node.pipe().up()) {
            neighbour(neighbours, grid, node.x(), node.y() - 1, n -> n.pipe().down());
        }
        if (node.pipe().down()) {
            neighbour(neighbours, grid, node.x(), node.y() + 1, n -> n.pipe().up());
        }
        if (node.pipe().left()) {
            neighbour(neighbours, grid, node.x() - 1, node.y(), n -> n.pipe().right());
        }
        if (node.pipe().right()) {
            neighbour(neighbours, grid, node.x() + 1, node.y(), n -> n.pipe().left());
        }
        return neighbours;
    }

    // Boilerplate for checking if a neighbour is valid
    private static void neighbour(final Set<Node> neighbours,
                                  final Node[][] grid,
                                  final int x,
                                  final int y,
                                  final Predicate<Node> neighbourTest) {
        if (y >= 0 && y < grid.length && x >= 0 && x < grid[y].length
            && grid[y][x].pipe() != null && neighbourTest.test(grid[y][x])) {
            neighbours.add(grid[y][x]);
        }
    }

    private static Node[] parseGridRow(final int y, final String line) {
        final Node[] nodes = new Node[line.length()];
        final char[] chars = line.toCharArray();
        for (int i = 0; i < chars.length; i++) {
            nodes[i] = new Node(PIPE_CHAR_MAP.getOrDefault(chars[i], Pipe.DISCONNECTED), i, y);
        }
        return nodes;
    }

    private static boolean isInside(final Node[][] grid, final int x, int y) {
        boolean in = false;
        while (y >= 0) {
            final Pipe pipe = grid[y][x].pipe();
            // If the pipe is vertical or a left-facing bend we simply pretend that it's to the left of us
            // If the pipe is horizontal or a right-facing bend we consider it as blocking and count it as an intersection
            if (pipe == Pipe.HORIZONTAL || pipe == Pipe.BEND_NORTH_EAST || pipe == Pipe.BEND_SOUTH_EAST) {
                in = !in;
            }
            y -= 1;
        }
        return in;
    }

    private static List<String> input() throws IOException {
        return Files.readAllLines(Path.of("input.txt"));
    }

    private enum Pipe {
        VERTICAL(true, true, false, false),
        HORIZONTAL(false, false, true, true),
        BEND_NORTH_EAST(true, false, false, true),
        BEND_SOUTH_EAST(false, true, false, true),
        BEND_SOUTH_WEST(false, true, true, false),
        BEND_NORTH_WEST(true, false, true, false),
        START(true, true, true, true),
        DISCONNECTED(false, false, false, false);

        private final boolean up;
        private final boolean down;
        private final boolean left;
        private final boolean right;

        Pipe(final boolean up, final boolean down, final boolean left, final boolean right) {
            this.up = up;
            this.down = down;
            this.left = left;
            this.right = right;
        }

        public boolean up() {
            return this.up;
        }

        public boolean down() {
            return this.down;
        }

        public boolean left() {
            return this.left;
        }

        public boolean right() {
            return this.right;
        }

    }

    private static final class Node {

        private final Pipe pipe;
        private final int x;
        private final int y;
        private Node parent;
        private int steps;

        private Node(final Pipe pipe, final int x, final int y) {
            this.pipe = pipe;
            this.x = x;
            this.y = y;
        }

        public Pipe pipe() {
            return this.pipe;
        }

        public int x() {
            return this.x;
        }

        public int y() {
            return this.y;
        }

        public Node parent() {
            return this.parent;
        }

        public void setParent(final Node parent) {
            this.parent = parent;
        }

        public int steps() {
            return this.steps;
        }

        public void setSteps(final int steps) {
            this.steps = steps;
        }

    }

}
