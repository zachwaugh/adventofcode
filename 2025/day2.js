import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 2, Puzzle 1] Starting…");
  const input = fs.readFileSync("day2.txt", "utf8");
  const ranges = input.trim().split(",");
  console.log("Processing ranges:", ranges);

  let invalidTotal = 0;

  for (const range of ranges) {
    const [start, end] = range.split("-").map((n) => parseInt(n));

    let current = start;
    while (current <= end) {
      if (isInvalid(current)) {
        invalidTotal += current;
      }

      current++;
    }
  }

  console.log("[Day 2, Puzzle 1] Answer:", invalidTotal);
};

const puzzle2 = () => {
  console.log("[Day 2, Puzzle 2] Starting…");
  const input = fs.readFileSync("day2.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 2, Puzzle 2] Answer:", result);
};

const isInvalid = (number) => {
  const string = number.toString();
  if (string.length % 2 != 0) {
    return false;
  }

  const part1 = string.substr(0, string.length / 2);
  const part2 = string.substr(string.length / 2);
  return part1 === part2;
};

puzzle1();
puzzle2();
