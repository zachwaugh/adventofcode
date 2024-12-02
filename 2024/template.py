def main():
    part1()
    part2()

def part1():
    print("[Day {{day}}, part 1]")

def part2():
    print("[Day {{day}}, part 2]")

def load_data():
    with open('day{{day}}.txt', 'r') as file:
        content = file.read().strip()
    return content

if __name__ == "__main__":
    main()
