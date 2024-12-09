def main():
    part1()
    part2()


def part1():
    disk = load_data()
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
    disk = load_data()
    defragment(disk)
    print("[Day 9, part 2] disk", checksum(disk))


def defragment(disk):
    blocks = 0
    current_file = None
    current_file_start = None

    for index in range(len(disk) - 1, -1, -1):
        element = disk[index]
        if element == ".":
            continue

        if element == current_file:
            # count blocks
            blocks += 1
        else:
            # changed files, move previous block
            if blocks > 0:
                free_index = index_of_space(disk, blocks)
                if free_index and free_index < index + blocks:
                    # Found space, move blocks
                    for i in range(free_index, free_index + blocks):
                        disk[i] = current_file

                    # Mark file as empty
                    for i in range(
                        current_file_start - blocks + 1, current_file_start + 1
                    ):
                        disk[i] = "."

            if not current_file or int(current_file) - 1 == int(element):
                current_file = element
                current_file_start = index
                blocks = 1
            else:
                blocks = 0


def index_of_space(disk, size):
    last_element = None
    free_size = 0

    for index, element in enumerate(disk):
        if element == ".":
            free_size += 1
        elif last_element == "." and free_size >= size:
            # found a block of free_size that is large enough
            # return start index
            return index - free_size
        else:
            free_size = 0

        last_element = element

    return None


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


def print_disk(disk):
    print("|".join(disk[:32]))


def load_data():
    with open("day9.txt", "r") as file:
        input = file.read().strip()

    # Test input
    # input = "2333133121414131402"
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
    return disk


if __name__ == "__main__":
    main()
