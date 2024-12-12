from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])


def main():
    part1()
    part2()


def part1():
    garden = load_data()
    total = total_cost(garden)
    print("[Day 12, part 1] fence cost:", total)


def part2():
    print("[Day 12, part 2]")


def parse_regions(garden):
    visited = set()
    regions = []
    for y, row in enumerate(garden):
        for x, col in enumerate(row):
            point = Point(x, y)

            if point not in visited:
                region = set()
                search(garden, point, region)
                regions.append(region)
                visited |= region
    return regions


def search(grid, point, visited):
    visited.add(point)
    (x, y) = point
    plot = grid[y][x]

    adjacent = [Point(x, y + 1), Point(x, y - 1), Point(x - 1, y), Point(x + 1, y)]

    for p in adjacent:
        value = get(grid, p)
        if p not in visited and value == plot:
            search(grid, p, visited)


def get(grid, point):
    if point.x >= 0 and point.x < len(grid[0]) and point.y >= 0 and point.y < len(grid):
        return grid[point.y][point.x]
    else:
        return None


def area(region):
    return len(region)


def perimeter(region):
    adjacent = adjacent_points(region)
    return (len(region) * 4) - (adjacent * 2)


def adjacent_points(region):
    count = 0
    for point in region:
        for other in region:
            if other == point:
                continue

            if is_adjacent(point, other):
                count += 1
    # Each will be counted twice
    return count // 2


def is_adjacent(p1, p2):
    return (abs(p1.x - p2.x) == 1 and p1.y == p2.y) or (
        abs(p1.y - p2.y) == 1 and p1.x == p2.x
    )


def cost(region):
    return area(region) * perimeter(region)


def total_cost(garden):
    regions = parse_regions(garden)
    total = 0
    for region in regions:
        total += cost(region)
    return total


def load_data():
    with open("day12.txt", "r") as file:
        input = file.read().strip()
    return list(map(lambda line: list(line.strip()), input.strip().splitlines()))


main()
