from collections import namedtuple


def ranges_overlap(r1, r2):
    return max(r1.start, r2.start) < min(r1.stop, r2.stop)

Range= namedtuple("range", ["start", "stop"])

print(ranges_overlap(Range(10,20), Range(0,10)))
print(ranges_overlap(Range(10,20), Range(0,11)))
print(ranges_overlap(Range(0,11), Range(10,20)))
