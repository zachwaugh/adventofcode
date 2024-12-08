import math

from utils import Point


def main():
    part1()
    part2()


def part1():
    map = load_data()
    p = Point(0, 0)
    max_y = len(map) - 1
    max_x = len(map[0]) - 1

    # unique antinodes
    antinodes = set()

    # Loop over each position on map
    # If antenna, search in all directions for antennas in line
    # Determine antinode positions on map
    while True:
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

        if p.x < max_x:
            p.x += 1
        elif p.y < max_y:
            p.y += 1
            p.x = 0
        else:
            break

    print("[Day 8, part 1] antinodes:", len(antinodes))


def part2():
    print("[Day 8, part 2]")


def find_antennas(map, antenna):
    antennas = []
    p = Point(0, 0)
    max_y = len(map) - 1
    max_x = len(map[0]) - 1

    while True:
        node = map[p.y][p.x]
        if node == antenna:
            antennas.append(p.copy())

        if p.x < max_x:
            p.x += 1
        elif p.y < max_y:
            p.y += 1
            p.x = 0
        else:
            break

    return antennas


def find_point(p1, distance, slope):
    if slope == float("inf"):
        return Point(p1.y + distance, p1.x)

    x2 = p1.x + distance / math.sqrt(1 + slope**2)
    y2 = p1.y + slope * (x2 - p1.x)
    return Point(round(y2), round(x2))


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
