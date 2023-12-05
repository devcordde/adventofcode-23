from dataclasses import dataclass
from typing import Tuple

mappings = [e for e in open("input.txt").read().split("\n\n")]
seeds = list(map(int, mappings[0].split(":")[1].strip().split(" ")))
mappings = [e.splitlines() for e in mappings[1:]]


@dataclass
class MappingLine:
    dest: int
    source: int
    range: int

    @staticmethod
    def parse(line: str) -> "MappingLine":
        return MappingLine(*list(map(int, line.split(" "))))

    def contained(self, num: int) -> bool:
        return self.source <= num < self.source + self.range

    def overlaps(self, start, stop):
        return max(start, self.source) < min(stop, self.source_end())

    def to_dest(self, num) -> int:
        return num + self.delta()

    def source_end(self) -> int:
        return self.source + self.range - 1

    def dest_end(self) -> int:
        return self.source + self.range - 1

    def to_range(self, start, stop) -> Tuple[int, int]:
        return self.to_dest(start), self.to_dest(stop)

    def delta(self) -> int:
        return self.dest - self.source

    def __repr__(self):
        return f"{self.source} -> {self.source_end()} to {self.dest} -> {self.dest_end()} ({self.delta()})"


@dataclass
class Mapping:
    name: str
    lines: list[MappingLine]

    @staticmethod
    def parse(lines: list[str]) -> "Mapping":
        name = lines[0].replace(" map", "").replace("-to-", " -> ")
        lines = [MappingLine.parse(e) for e in lines[1:]]
        return Mapping(name, sorted(lines, key=lambda x: x.source))

    def to_dest(self, num) -> int:
        line = self.find_line(num)
        return line.to_dest(num) if line else num

    def find_line(self, num) -> MappingLine | None:
        for line in self.lines:
            if line.contained(num):
                return line
        return None

    def ranges(self, start, stop) -> list[Tuple[int, int]]:
        matching = [x for x in self.lines if x.overlaps(start, stop)]
        ranges: list[Tuple[int, int]] = []
        curr = start
        for line in matching:
            if not line.contained(curr):
                # Handle gap
                ranges.append((curr, line.source - 1))
            # Handle mapping element
            ranges.append(line.to_range(curr, min(stop, line.source_end())))
            curr = line.source_end() + 1
        if curr < stop:
            # If end is not reached but there is no more mapping left
            ranges.append((curr, stop))
        return ranges


@dataclass
class Pipeline:
    steps: list[Mapping]

    def to_dest(self, num):
        for step in self.steps:
            num = step.to_dest(num)
        return num

    def lowest(self, start, stop):
        ranges: list[Tuple[int, int]] = [(start, stop)]
        for step in self.steps:
            new_ranges: list[Tuple[int, int]] = []
            for r in ranges:
                new_ranges.extend(step.ranges(*r))
            ranges = new_ranges
        return min([e[0] for e in ranges])


mappings = [Mapping.parse(mapping) for mapping in mappings]

pipeline = Pipeline(mappings)
locations = [pipeline.to_dest(e) for e in seeds]
print(f"Part 1: {min(locations)}")

locations = []
for seed in [seeds[w:w + 2] for w in range(0, len(seeds), 2)]:
    low = pipeline.lowest(seed[0], seed[0] + seed[1] - 1)
    locations.append(low)
    print(f"Lowest for {seed} is {low}")

expected = [35081694, 9622622, 299048714, 218618953, 218618953, 218618953, 201450167, 297052731, 10114991, 218618953]

# for i, res in enumerate(expected):
#     if res != locations[i]:
#         print(f"Seed {i} is {locations[i]} instead of {res}")

print(f"Part 2: {min(locations)}")
