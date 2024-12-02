import sys

args = sys.argv[1:]  # Excludes the script name
if len(args) == 0:
    print("Usage: python3 new_day.py <day>")
    exit(1)

day = args[0]

with open("template.py", "r") as file:
    content = file.read().strip()

content = content.replace("{{day}}", day)

with open(f"day{day}.py", "w") as file:
    file.write(content)

with open(f"day{day}.txt", 'w') as file:
    pass
