def main():
    part1()
    part2()


def part1():
    input = load_data()
    map = []
    for line in input.splitlines():
        map.append(list(line))

    point = find_guard(map)
    visited_points = {point}

    while point := move_guard(map, point):
        visited_points.add(point)

    print("[Day 6, part 1] visited points count", len(visited_points))


def part2():
    print("[Day 6, part 2]")


def print_map(map):
    str = ""
    for row in map:
        str += "".join(row)
        str += "\n"
    print(str)


def find_guard(map):
    guard_chars = ["^", ">", "<", "v"]
    for y, row in enumerate(map):
        for x, _ in enumerate(row):
            char = map[y][x]
            if char in guard_chars:
                return (y, x)
    return None


def move_guard(map, point):
    y, x = point
    guard = map[y][x]
    row_len = len(map)
    col_len = len(map[0])

    match guard:
        case "^":
            if y == 0:
                # off map top
                map[y][x] = "."
                return None

            if map[y - 1][x] == "#":
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y - 1][x] = guard
                return (y - 1, x)
            return
        case ">":
            if x + 1 >= col_len:
                # off map right
                map[y][x] = "."
                return None

            if map[y][x + 1] == "#":
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y][x + 1] = guard
                return (y, x + 1)
            return
        case "<":
            if x == 0:
                # off map left
                map[y][x] = "."
                return None

            if map[y][x - 1] == "#":
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y][x - 1] = guard
                return (y, x - 1)
            return
        case "v":
            if y + 1 >= row_len:
                # off map bottom
                map[y][x] = "."
                return None

            if map[y + 1][x] == "#":
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y + 1][x] = guard
                return (y + 1, x)
            return


def rotate_guard(char):
    match char:
        case "^":
            return ">"
        case ">":
            return "v"
        case "<":
            return "^"
        case "v":
            return "<"


def load_data():
    with open("day6.txt", "r") as file:
        content = file.read().strip()
    return content


if __name__ == "__main__":
    main()
