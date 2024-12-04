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
    input = load_data()
    rows = []
    for line in input.splitlines():
        rows.append(list(line))

    boxes = []
    box_size = 3
    # Form all possible 3x3 boxes in puzzle
    for row_index in range(len(rows)):
        # Not enough rows left to form box
        if row_index > len(rows) - box_size:
            break

        row = rows[row_index]
        for i in range(len(row)):
            # Not enough columns left to form box
            if i > len(row) - box_size:
                break

            box = [
                rows[row_index][i:i+3],
                rows[row_index+1][i:i+3],
                rows[row_index+2][i:i+3]
            ]
            boxes.append(box)

    xmas_count = 0

    for box in boxes:
        if check_box(box):
            xmas_count += 1

    print("[Day 4, part 2] X-MAS count:", xmas_count)

# Check each grouping of 4 chars in array forward and reverse
def count_array(array):
    count = 0
    for i in range(len(array)):
        if i + 4 <= len(array):
            word = ''.join(array[i:i+4])
            if word == "XMAS" or word == "SAMX":
                count += 1
    return count

def check_box(box):
    diagonal_right = [
        box[0][0],
        box[1][1],
        box[2][2]
    ]
    diagonal_left = [
        box[0][2],
        box[1][1],
        box[2][0]
    ]
    word_left = ''.join(diagonal_left)
    word_right = ''.join(diagonal_right)
    return (word_left == "MAS" or word_left == "SAM") and (word_right == "MAS" or word_right == "SAM")

def load_data():
    with open('day4.txt', 'r') as file:
        content = file.read().strip()
    return content

if __name__ == "__main__":
    main()
