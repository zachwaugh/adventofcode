import copy


class Point:
    def __init__(self, y, x):
        self.y = y
        self.x = x

    def __str__(self):
        return f"({self.y}, {self.x})"

    def __repr__(self):
        return f"({self.y}, {self.x})"

    def __eq__(self, other):
        if isinstance(other, Point):
            return self.x == other.x and self.y == other.y
        return False

    def __hash__(self):
        return hash((self.x, self.y))


def main():
    part1()
    part2()


def part1():
    map = load_data()
    point = find_guard(map)
    visited_points = {point}

    while point := move_guard(map, point):
        visited_points.add(point)

    print("[Day 6, part 1] visited points count", len(visited_points))


def part2():
    original_map = load_data()

    p = Point(0, 0)
    max_y = len(original_map) - 1
    max_x = len(original_map[0]) - 1
    loop_count = 0

    while True:
        map = copy.deepcopy(original_map)
        if map[p.y][p.x] == ".":
            map[p.y][p.x] = "0"
            if has_loop(map):
                loop_count += 1

        if p.x < max_x:
            p.x += 1
        elif p.y < max_y:
            p.y += 1
            p.x = 0
        else:
            break

    print("[Day 6, part 2] loop count:", loop_count)


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
                return Point(y, x)
    return None


def move_guard(map, point):
    y = point.y
    x = point.x
    guard = map[y][x]
    row_len = len(map)
    col_len = len(map[0])

    match guard:
        case "^":
            if y == 0:
                # off map top
                map[y][x] = "."
                return None

            if is_obstacle(map[y - 1][x]):
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y - 1][x] = guard
                return Point(y - 1, x)
            return
        case ">":
            if x + 1 >= col_len:
                # off map right
                map[y][x] = "."
                return None

            if is_obstacle(map[y][x + 1]):
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y][x + 1] = guard
                return Point(y, x + 1)
            return
        case "<":
            if x == 0:
                # off map left
                map[y][x] = "."
                return None

            if is_obstacle(map[y][x - 1]):
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y][x - 1] = guard
                return Point(y, x - 1)
            return
        case "v":
            if y + 1 >= row_len:
                # off map bottom
                map[y][x] = "."
                return None

            if is_obstacle(map[y + 1][x]):
                map[y][x] = rotate_guard(guard)
                return point
            else:
                map[y][x] = "."
                map[y + 1][x] = guard
                return Point(y + 1, x)
            return


def is_obstacle(char):
    return char == "#" or char == "0"


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


def has_loop(map):
    turn_points = set()
    point = find_guard(map)
    prev_dir = map[point.y][point.x]

    while point := move_guard(map, point):
        dir = map[point.y][point.x]
        if dir != prev_dir:
            # Guard turned
            if (point, dir) in turn_points:
                # Guard stuck in loop!
                return True
            else:
                turn_points.add((point, dir))
        prev_dir = dir

    return False


def load_data():
    with open("day6.txt", "r") as file:
        input = file.read().strip()

    map = []
    for line in input.splitlines():
        map.append(list(line))
    return map


if __name__ == "__main__":
    main()
