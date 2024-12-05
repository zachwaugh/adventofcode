def main():
    part1()
    part2()

def part1():
    rules, updates = load_data()
    page_rules = {}

    for rule in rules.splitlines():
        parts = rule.split("|")
        x = parts[0]
        y = parts[1]
        if x in page_rules:
            page_rules[x].add(y)
        else:
            page_rules[x] = {y}

    valid_middle_page_total = 0

    for update in updates.splitlines():
        pages = update.split(",")
        previous_pages = set()
        is_valid = True
        for page in pages:
            if page in page_rules:
                invalid_previous_pages = page_rules[page]
                if invalid_previous_pages & previous_pages:
                    is_valid = False
                    break
            previous_pages.add(page)

        if is_valid:
            valid_middle_page_total += int(pages[len(pages) // 2])

    print("[Day 5, part 1] valid middle page update total:", valid_middle_page_total)

def part2():
    print("[Day 5, part 2]")

def load_data():
    with open('day5.txt', 'r') as file:
        content = file.read().strip()

    parts = content.split("\n\n");
    return parts[0], parts[1]

if __name__ == "__main__":
    main()
