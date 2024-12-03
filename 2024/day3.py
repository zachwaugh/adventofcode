import re

def main():
    part1()
    part2()

def part1():
    input = load_data()
    pattern = r"mul\(([0-9]+),([0-9]+)\)"
    matches = re.findall(pattern, input)
    result = 0
    
    for match in matches:
        factor1 = int(match[0])
        factor2 = int(match[1])
        result += factor1 * factor2

    print("[Day 3, part 1] result:", result)

def part2():
    print("[Day 3, part 2]")

def load_data():
    with open('day3.txt', 'r') as file:
        content = file.read().strip()
    return content

if __name__ == "__main__":
    main()
