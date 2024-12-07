from itertools import product


def main():
    part1()
    part2()


def part1():
    input = load_data()

    total = 0
    for line in input.splitlines():
        answer, rest = line.split(":")
        operands = rest.strip().split()
        if can_solve_equation(operands, int(answer)):
            total += int(answer)

    print("[Day 7, part 1] total:", total)


def part2():
    print("[Day 7, part 2]")


def can_solve_equation(operands, answer):
    allowed_operators = ["+", "*"]
    all_operators = list(product(allowed_operators, repeat=len(operands) - 1))
    for operators in all_operators:
        result = solve_equation(operands, operators)
        if result == answer:
            return True
    return False


def solve_equation(operands, operators):
    result = None
    for index, value in enumerate(operands):
        if result is None:
            result = int(value)
        else:
            match operators[index - 1]:
                case "+":
                    result += int(value)
                case "*":
                    result *= int(value)
    return result


def load_data():
    with open("day7.txt", "r") as file:
        content = file.read().strip()
    return content


if __name__ == "__main__":
    main()
