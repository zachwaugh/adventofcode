def main():
    part1()
    part2()

def part1():
    list1, list2 = load_data()
    distances = 0

    for index, value in enumerate(list1):
        value2 = list2[index]
        distances += abs(value - value2)

    print("[Day 1, part 1] Distances:", distances)

def part2():
    list1, list2 = load_data()
    similarity_score_total = 0

    for value in list1:
        count = count_occurrences(list2, value)
        score = value * count
        similarity_score_total += score

    print("[Day 1, part 2] Similarity score:", similarity_score_total)

def load_data():
    with open('day1.txt', 'r') as file:
        content = file.read().strip()

    lines = content.split('\n')
    list1 = []
    list2 = []

    for line in lines:
        value1, value2 = line.split()
        list1.append(int(value1))
        list2.append(int(value2))

    list1.sort()
    list2.sort()
    return list1, list2

def count_occurrences(array, target):
    count = 0
    for value in array:
        if value == target:
            count += 1

    return count

if __name__ == "__main__":
    main()
