def main():
    part1()
    part2()

def part1():
    rules, updates = load_data()
    page_rules = parse_page_rules(rules)
    valid_middle_page_total = 0

    for update in updates.splitlines():
        pages = update.split(",")
        is_valid = is_valid_update(pages, page_rules)

        if is_valid:
            valid_middle_page_total += int(pages[len(pages) // 2])

    print("[Day 5, part 1] valid middle page update total:", valid_middle_page_total)

def part2():
    rules, updates = load_data()
    page_rules = parse_page_rules(rules)
    fixed_middle_page_total = 0

    for update in updates.splitlines():
        pages = update.split(",")
        if is_valid_update(pages, page_rules):
            continue

        fix_update(pages, page_rules)
        fixed_middle_page_total += int(pages[len(pages) // 2])

    print("[Day 5, part 2] fixed middle page update total:", fixed_middle_page_total)

def fix_update(pages, page_rules):
    while not is_valid_update(pages, page_rules):
        for index, page in enumerate(pages):
            if page not in page_rules:
                continue

            invalid_pages = page_rules[page] & set(pages[:index])
            if invalid_pages:
                current_index = index
                for invalid_page in invalid_pages:
                    pages.pop(current_index)
                    new_index = pages.index(invalid_page)
                    pages.insert(new_index, page)
                    current_index = new_index

def is_valid_update(pages, rules):
    for index, page in enumerate(pages):
        if page in rules:
            # if intersection between previous pages
            # and this pages rules, the order is invalid
            if rules[page] & set(pages[:index]):
                return False
    return True

def parse_page_rules(rules):
    page_rules = {}

    for rule in rules.splitlines():
        parts = rule.split("|")
        x = parts[0]
        y = parts[1]
        if x in page_rules:
            page_rules[x].add(y)
        else:
            page_rules[x] = {y}

    return page_rules

def load_data():
    with open('day5.txt', 'r') as file:
        content = file.read().strip()

    parts = content.split("\n\n")
    return parts[0], parts[1]

if __name__ == "__main__":
    main()
