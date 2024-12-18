from enum import Enum

class Mode(Enum):
    INCREASING = 1
    DECREASING = 2

def main():
    part1()
    part2()

def part1():
    reports = load_data()
    safe_count = 0

    for report in reports:
        if is_safe(report):
            safe_count += 1

    print("[Day 2, part 1] Safe count:", safe_count)

def part2():
    reports = load_data()
    safe_count = 0

    for report in reports:
        if is_safe_dampener(report):
            safe_count += 1

    print("[Day 2, part 2] Safe with dampener count:", safe_count)

def is_safe(levels):
    previous_level = None
    mode = None

    for level in levels:
        if previous_level is None:
            previous_level = level
            continue

        current_mode = Mode.INCREASING if level > previous_level else Mode.DECREASING

        if mode is None:
            mode = current_mode

        if mode != current_mode:
            # Inconsistent mode
            return False

        difference = abs(level - previous_level)
        if difference < 1 or difference > 3:
            # Invalid differnce
            return False
            
        previous_level = level

    return True

def is_safe_dampener(levels):
    if is_safe(levels):
        return True
    else:
        # Brute force check every permutation of array for safety
        # Not efficient, but fine for this
        for index in range(len(levels)):
            new_levels = levels.copy()
            del new_levels[index]
            if is_safe(new_levels):
                return True
        
        return False

def load_data():
    with open('day2.txt', 'r') as file:
        content = file.read().strip()

    lines = content.splitlines()
    reports = []
    for line in lines:
        levels = list(map(lambda x: int(x), line.split()))
        reports.append(levels)
    return reports

if __name__ == "__main__":
    main()
