def main():
    part1()
    part2()


def part1():
    stones = load_data().split(" ")
    blink_count = 25
    for i in range(blink_count):
        blink(stones)
    print("[Day 11, part 1] stones:", len(stones))


def part2():
    print("[Day 11, part 2]")


def blink(stones):
    index = 0
    while index < len(stones):
        stone = stones[index]
        if stone == "0":
            stones[index] = "1"
        elif len(stone) % 2 == 0:
            digits = list(stone)
            mid = int(len(stone) / 2)
            # Convert to int and back to string to drop leading 0s
            stones[index] = str(int("".join(digits[:mid])))
            stones.insert(index + 1, str(int("".join(digits[mid:]))))
            index += 1
        else:
            stones[index] = str(int(stone) * 2024)
        index += 1


def load_data():
    with open("day11.txt", "r") as file:
        content = file.read().strip()
    return content


if __name__ == "__main__":
    main()
