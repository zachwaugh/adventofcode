def main():
    part1()
    part2()


def part1():
    grid = load_data()
    score = find_all_trailheads(grid)
    print("[Day 10, part 1] score:", score)


def part2():
    print("[Day 10, part 2]")


def search(grid, x, y):
    results = set()
    value = grid[y][x]
    next = int(value) + 1

    up = grid[y + 1][x] if y + 1 < len(grid) else None
    if up and up == "9" and next == 9:
        results.add((x, y + 1))
    elif up and up != "." and int(up) == next:
        results |= search(grid, x, y + 1)

    down = grid[y - 1][x] if y > 0 else None
    if down and down == "9" and next == 9:
        results.add((x, y - 1))
    elif down and down != "." and int(down) == next:
        results |= search(grid, x, y - 1)

    left = grid[y][x - 1] if x > 0 else None
    if left and left == "9" and next == 9:
        results.add((x - 1, y))
    elif left and left != "." and int(left) == next:
        results |= search(grid, x - 1, y)

    right = grid[y][x + 1] if x + 1 < len(grid[0]) else None
    if right and right == "9" and next == 9:
        results.add((x + 1, y))
    elif right and right != "." and int(right) == next:
        results |= search(grid, x + 1, y)

    return results


def find_all_trailheads(grid):
    score = 0
    for y, row in enumerate(grid):
        for x, col in enumerate(row):
            if grid[y][x] == "0":
                results = search(grid, x, y)
                trailhead_score = len(results)
                score += trailhead_score

    return score


def load_data():
    with open("day10.txt", "r") as file:
        input = file.read().strip()
    return list(map(list, input.splitlines()))


if __name__ == "__main__":
    main()
