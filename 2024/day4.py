def main():
    part1()
    part2()

def part1():
    input = load_data()
    rows = []
    for line in input.splitlines():
        rows.append(list(line))

    columns = []
    for i in range(len(rows[0])):
        column = []
        for j in range(len(rows)):
            column.append(rows[j][i])
        columns.append(column)

    diagonals = []
    for row_index in range(len(rows)):
        # Not enough rows left to form diagonals
        if row_index > len(rows) - 4:
            break

        row = rows[row_index]
        for i in range(len(row)):
            if i <= len(row) - 4:
                # Diagonal right
                diagonal = [
                    rows[row_index][i],
                    rows[row_index + 1][i + 1],
                    rows[row_index + 2][i + 2],
                    rows[row_index + 3][i + 3],
                ]
                diagonals.append(diagonal)

            if i >= 3:
                # Diagonal left
                diagonal = [
                    rows[row_index][i],
                    rows[row_index + 1][i - 1],
                    rows[row_index + 2][i - 2],
                    rows[row_index + 3][i - 3],
                ]
                diagonals.append(diagonal)

    xmas_count = 0

    for row in rows:
        xmas_count += count_array(row)

    for column in columns:
        xmas_count += count_array(column)

    for diagonal in diagonals:
        xmas_count += count_array(diagonal)

    print("[Day 4, part 1] XMAS count:", xmas_count)

def part2():
    print("[Day 4, part 2]")

# Check each grouping of 4 chars in array forward and reverse
def count_array(array):
    count = 0
    for i in range(len(array)):
        if i + 4 <= len(array):
            word = ''.join(array[i:i+4])
            if word == "XMAS" or word == "SAMX":
                count += 1
    return count

def load_data():
    with open('day4.txt', 'r') as file:
        content = file.read().strip()
    return content

if __name__ == "__main__":
    main()
