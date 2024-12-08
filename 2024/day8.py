import math

from utils import Point


def main():
    part1()
    part2()


def part1():
    map = load_data()
    # unique antinodes
    antinodes = set()

    # Loop over each position on map
    # If antenna, search in all directions for antennas in line
    # Determine antinode positions on map
    for y, row in enumerate(map):
        for x, col in enumerate(row):
            p = Point(y, x)
            char = map[p.y][p.x]
            if char != "." and char != "#":
                antennas = find_antennas(map, char)
                for antenna in antennas:
                    if antenna == p:
                        continue

                    distance = p.distance(antenna)
                    slope = (antenna.y - p.y) / (antenna.x - p.x)
                    # this is lazy, but didn't feel like figuring out the right
                    # points for each pair of points/slope, so calc all and ignore
                    # the wrong ones
                    possible_antinodes = [
                        find_point(p, -distance, slope),
                        find_point(p, distance, slope),
                        find_point(antenna, distance, slope),
                        find_point(antenna, -distance, slope),
                    ]
                    for a in possible_antinodes:
                        if a != p and a != antenna and in_bounds(map, a):
                            antinodes.add(a)

    print("[Day 8, part 1] antinodes:", len(antinodes))


def part2():
    map = load_data()
    antinodes = set()

    for y, row in enumerate(map):
        for x, col in enumerate(row):
            p = Point(y, x)
            char = map[y][x]
            if char != "." and char != "#":
                antennas = find_antennas(map, char)
                for antenna in antennas:
                    if antenna == p:
                        continue

                    slope = (antenna.y - p.y) / (antenna.x - p.x)
                    b = p.y - (slope * p.x)
                    points = find_all_points_on_line(map, slope, b)
                    for point in points:
                        if in_bounds(map, point):
                            antinodes.add(point)

    print("[Day 8, part 2] antinodes:", len(antinodes))


def find_antennas(map, antenna):
    antennas = []
    for y, row in enumerate(map):
        for x, col in enumerate(row):
            node = map[y][x]
            if node == antenna:
                antennas.append(Point(y, x))
    return antennas


def find_point(p1, distance, slope):
    if slope == float("inf"):
        return Point(p1.y + distance, p1.x)

    x2 = p1.x + distance / math.sqrt(1 + slope**2)
    y2 = p1.y + slope * (x2 - p1.x)
    return Point(round(y2), round(x2))


def find_all_points_on_line(map, m, b):
    points = []
    for y, row in enumerate(map):
        for x, col in enumerate(row):
            if math.isclose(y, m * x + b):
                points.append(Point(y, x))

    return points


def print_map(map):
    str = ""
    for row in map:
        str += "".join(row)
        str += "\n"
    print(str)


def in_bounds(map, p):
    max_y = len(map) - 1
    max_x = len(map[0]) - 1
    return p.x >= 0 and p.x <= max_x and p.y >= 0 and p.y <= max_y


def load_data():
    with open("day8.txt", "r") as file:
        input = file.read().strip()

    map = []
    for line in input.splitlines():
        map.append(list(line))
    return map


if __name__ == "__main__":
    main()
