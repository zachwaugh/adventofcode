import functools


def main():
    part1()
    part2()


def part1():
    stones = load_data()
    total = 0
    for stone in stones:
        total += count_stones(stone, 25)
    print("[Day 11, part 1] stones:", total)


def part2():
    stones = load_data()
    total = 0
    for stone in stones:
        total += count_stones(stone, 75)
    print("[Day 11, part 2] stones:", total)


def value_for_stone(stone):
    text = str(stone)
    if stone == 0:
        return (1, None)
    elif len(text) % 2 == 0:
        digits = list(text)
        mid = len(digits) // 2
        left = int("".join(digits[:mid]))
        right = int("".join((digits[mid:])))
        return (left, right)
    else:
        return (stone * 2024, None)


@functools.cache
def count_stones(stone, depth):
    left, right = value_for_stone(stone)

    if depth == 1:
        if right is None:
            return 1
        else:
            return 2
    else:
        output = count_stones(left, depth - 1)
        if right is not None:
            output += count_stones(right, depth - 1)

        return output


def load_data():
    with open("day11.txt", "r") as file:
        input = file.read().strip()
    return list(map(int, input.split(" ")))


if __name__ == "__main__":
    main()
