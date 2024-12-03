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
    input = load_data()
    pattern = r"(do\(\)|don\'t\(\)|mul\(([0-9]+),([0-9]+)\))"
    matches = re.findall(pattern, input)
    result = 0
    multiplication_enabled = True
    
    for match in matches:
        if match[0] == "don't()":
            multiplication_enabled = False
        elif match[0] == "do()":
            multiplication_enabled = True
        elif match[0].startswith("mul") and multiplication_enabled:
            factor1 = int(match[1])
            factor2 = int(match[2])
            result += factor1 * factor2

    print("[Day 3, part 2] result:", result)

def load_data():
    with open('day3.txt', 'r') as file:
        content = file.read().strip()
    return content

if __name__ == "__main__":
    main()
