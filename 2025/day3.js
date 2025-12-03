import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 3, Puzzle 1] Starting…");
  const input = fs.readFileSync("day3.txt", "utf8");
  const banks = input.trim().split("\n");
  let totalJoltage = 0;

  for (const bank of banks) {
    const batteries = bank.split("").map((b) => parseInt(b));
    const joltage = highestVoltage(batteries);
    totalJoltage += joltage;
  }

  console.log("[Day 3, Puzzle 1] Answer:", totalJoltage);
};

const puzzle2 = () => {
  console.log("[Day 3, Puzzle 2] Starting…");
  const input = fs.readFileSync("day3.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 3, Puzzle 2] Answer:", result);
};

const highestVoltage = (batteries) => {
  let first = 0;
  let firstIndex = 0;
  let second = 0;
  let endIndex = batteries.length - 1;

  // Find largest first battery that isn't at the end
  batteries.forEach((battery, index) => {
    if (battery > first && index !== endIndex) {
      first = battery;
      firstIndex = index;
    }
  });

  // Find largest second battery after the first
  batteries.forEach((battery, index) => {
    if (battery > second && index > firstIndex) {
      second = battery;
    }
  });

  return parseInt(`${first}${second}`);
};

puzzle1();
puzzle2();
