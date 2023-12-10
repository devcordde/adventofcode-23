from collections import namedtuple
from pprint import pprint

Coord = namedtuple("Coord", ["x", "y"])

mapping = {
    "|": lambda curr: [Coord(curr.x, curr.y - 1), Coord(curr.x, curr.y + 1)],
    "-": lambda curr: [Coord(curr.x - 1, curr.y), Coord(curr.x + 1, curr.y)],
    "L": lambda curr: [Coord(curr.x, curr.y - 1), Coord(curr.x + 1, curr.y)],
    "J": lambda curr: [Coord(curr.x, curr.y - 1), Coord(curr.x - 1, curr.y)],
    "7": lambda curr: [Coord(curr.x, curr.y + 1), Coord(curr.x - 1, curr.y)],
    "F": lambda curr: [Coord(curr.x, curr.y + 1), Coord(curr.x + 1, curr.y)],
    "S": lambda curr: [],
    ".": lambda curr: None,
}

pipes = [[e for e in line] for e in open("input.txt").readlines() if (line := e.strip())]
pipemap = [[mapping[e](Coord(x, y)) for x, e in enumerate(row)] for y, row in enumerate(pipes)]
start = [[Coord(x, y) for x, e in enumerate(row) if e == "S"] for y, row in enumerate(pipes) if "S" in row][0][0]
pprint(pipes)
pprint(pipemap)
pprint(start)


def det_start(start: Coord):
    pipe = []
    for x in range(-1, 2, 2):
        if pipemap[start.y][start.x + x] is not None and start in pipemap[start.y][start.x + x]:
            pipe.append(Coord(start.x + x, start.y))
    for y in range(-1, 2, 2):
        if pipemap[start.y + y][start.x] is not None and start in pipemap[start.y + y][start.x]:
            pipe.append(Coord(start.x, y + start.y))
    return pipe


def generate_weight(start: Coord, pipemap: list[list[Coord | None] | list]):
    distance = [[-1] * len(pipemap[0]) for _ in pipemap]
    distance[start.y][start.x] = 0
    queue = [start]
    while queue:
        curr = queue.pop(0)
        weight = distance[curr.y][curr.x]
        for next in pipemap[curr.y][curr.x]:
            if distance[next.y][next.x] != -1:
                continue
            distance[next.y][next.x] = weight + 1
            queue.append(next)
        # print("\n".join(["".join([str(num) if num != -1 else "." for num in e]) for e in distance]))
        # print("")
    return distance


pipemap[start.y][start.x] = det_start(start)

pprint(pipemap[2][1])

weights = generate_weight(start, pipemap)

print(f"Part 1: {max([max(e) for e in weights])}")


# Lazy create polygon
def create_poly(start: Coord, pipemap: list[list[Coord | None] | list]):
    # decide for a direction
    next = pipemap[start.y][start.x][0]
    poly = [start]
    while next:
        new = None
        for n in pipemap[next.y][next.x]:
            # Use first unknown point
            if n in poly:
                continue
            poly.append(next)
            new = n
            break
        next = new
    return poly


# thanks wikipedia
def is_point_in_path(x: int, y: int, poly: list[Coord]) -> bool:
    num = len(poly)
    j = num - 1
    c = False
    for i, e in enumerate(poly):
        if (x == e.x) and (y == e.y):
            # although corners are part of the poligon they are pipes here
            return False
        if (e.y > y) != (poly[j].y > y):
            slope = (x - e.x) * (poly[j].y - e.y) - (poly[j].x - e.x) * (y - e.y)
            if slope == 0:
                # point is on boundary
                return False
            if (slope < 0) != (poly[j].y < poly[i].y):
                c = not c
        j = i
    return c


poly = create_poly(start, pipemap)

pprint(poly)

counts = 0
for y, line in enumerate(pipemap):
    for x, e in enumerate(line):
        if is_point_in_path(x, y, poly):
            counts += 1
            pipes[y][x] = "O"

print("\n".join(["".join([str(num) if num != -1 else "." for num in e]) for e in pipes]))
print("")

print(f"Part 2: {counts} <- Thats wrong")
