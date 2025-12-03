import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 2, Puzzle 1] Starting…");
  const input = fs.readFileSync("day2.txt", "utf8");
  const ranges = input.trim().split(",");
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
  const ranges = input.trim().split(",");
  let invalidTotal = 0;

  for (const range of ranges) {
    const [start, end] = range.split("-").map((n) => parseInt(n));

    let current = start;
    while (current <= end) {
      if (isInvalid2(current)) {
        invalidTotal += current;
      }

      current++;
    }
  }

  console.log("[Day 2, Puzzle 2] Answer:", invalidTotal);
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

const isInvalid2 = (number) => {
  const string = number.toString();

  let length = 1;
  let start = 0;
  let maxLength = Math.floor(string.length / 2);
  let isRepeating = false;

  while (length <= maxLength) {
    const needle = string.substr(start, length);
    const next = string.substr(start + length, length);

    if (next === "") {
      break;
    }

    if (needle === next) {
      // Matched next part
      isRepeating = true;
      start += length;
    } else {
      // no match, extend length and restart
      isRepeating = false;
      length += 1;
      start = 0;
    }
  }

  return isRepeating;
};

puzzle1();
puzzle2();
