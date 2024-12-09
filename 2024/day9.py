def main():
    part1()
    part2()


def part1():
    input = load_data()
    is_file = True
    disk = []
    id = 0
    for char in list(input):
        size = int(char)
        if is_file:
            for _ in range(size):
                disk.append(str(id))
            id += 1
        else:
            for _ in range(size):
                disk.append(".")
        is_file = not is_file

    for index, char in enumerate(disk):
        if char != ".":
            continue

        last = last_file_index(disk)
        if last:
            disk[index] = disk[last]
            disk[last] = "."

        if is_compacted(disk):
            break

    print("[Day 9, part 1] disk", checksum(disk))


def part2():
    print("[Day 9, part 2]")


def last_file_index(array):
    for index in range(len(array) - 1, -1, -1):
        if array[index] != ".":
            return index
    return None


def is_compacted(array):
    has_seen_empty_space = False
    for element in array:
        if element == ".":
            has_seen_empty_space = True
        elif has_seen_empty_space:
            # if we see any non-empty space
            # once we've seen an empty space
            # we're not compacted
            return False
    return True


def checksum(disk):
    total = 0
    id = 0
    for index, value in enumerate(disk):
        if value != ".":
            total += id * int(value)
            id += 1
    return total


def load_data():
    with open("day9.txt", "r") as file:
        content = file.read().strip()
    return content


if __name__ == "__main__":
    main()
