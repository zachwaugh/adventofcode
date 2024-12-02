def main():
    part1()

def part1():
    with open('day1.txt', 'r') as file:
        content = file.read()

    lines = content.split('\n')
    list1 = []
    list2 = []

    for line in lines:
        value1, value2 = line.split()
        list1.append(int(value1))
        list2.append(int(value2))

    list1.sort()
    list2.sort()
    distances = 0

    for index, value in enumerate(list1):
        value2 = list2[index]
        distances += abs(value - value2)

    print("[Day 1, part1] Distances:", distances)

if __name__ == "__main__":
    main()
