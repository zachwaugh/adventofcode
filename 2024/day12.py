from collections import namedtuple

Point = namedtuple("Point", ["x", "y"])
Region = namedtuple("Region", ["plot", "points"])


def main():
    part1()
    part2()


def part1():
    garden = load_data()
    total = total_cost(garden)
    print("[Day 12, part 1] fence cost:", total)


def part2():
    garden = load_data()
    total = total_cost2(garden)
    print("[Day 12, part 2] fence cost:", total)


def parse_regions(garden):
    visited = set()
    regions = []
    for y, row in enumerate(garden):
        for x, col in enumerate(row):
            point = Point(x, y)
            plot = garden[y][x]

            if point not in visited:
                region = set()
                search(garden, point, region)
                regions.append(Region(plot, region))
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
    return len(region.points)


def perimeter(region):
    adjacent = adjacent_points(region)
    return (len(region.points) * 4) - (adjacent * 2)


def num_sides(region):
    left_edges = {}
    right_edges = {}
    top_edges = {}
    bottom_edges = {}
    for p in region.points:
        if p.y not in left_edges:
            left_edges[p.y] = set()

        if p.y not in right_edges:
            right_edges[p.y] = set()

        if p.x not in top_edges:
            top_edges[p.x] = set()

        if p.x not in bottom_edges:
            bottom_edges[p.x] = set()

        left_edges[p.y].add(p.x)
        right_edges[p.y].add(p.x + 1)
        top_edges[p.x].add(p.y)
        bottom_edges[p.x].add(p.y + 1)

    x_edges = {}
    for y in left_edges:
        x_edges[y] = left_edges[y] ^ right_edges[y]

    y_edges = {}
    for x in top_edges:
        y_edges[x] = top_edges[x] ^ bottom_edges[x]

    x_count = count_unique(x_edges)
    y_count = count_unique(y_edges)
    return x_count + y_count


def count_unique(edges):
    count = 0
    rows = sorted(edges.keys())
    previous = None
    for index, row in enumerate(rows):
        if previous is None or abs(row - previous) > 1:
            # add all for first or spaced out rows
            count += len(edges[row])
        else:
            for edge in edges[row]:
                # add +1 when not in previous row or if in previous
                # row is not the same alignment as other edge
                if edge not in edges[previous] or is_leading(
                    edge, edges[row]
                ) != is_leading(edge, edges[previous]):
                    count += 1
        previous = row
    return count


def is_leading(edge, edges):
    points = sorted(edges)
    return points.index(edge) % 2 == 0


def adjacent_points(region):
    count = 0
    for point in region.points:
        for other in region.points:
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


def cost2(region):
    return area(region) * num_sides(region)


def total_cost(garden):
    regions = parse_regions(garden)
    total = 0
    for region in regions:
        total += cost(region)
    return total


def total_cost2(garden):
    regions = parse_regions(garden)
    total = 0
    for region in regions:
        total += cost2(region)
    return total


def load_data():
    with open("day12.txt", "r") as file:
        input = file.read().strip()
    return list(map(lambda line: list(line.strip()), input.strip().splitlines()))


main()
