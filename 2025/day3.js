import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 3, Puzzle 1] Starting…");
  const input = fs.readFileSync("day3.txt", "utf8");
  const banks = input.trim().split("\n");
  let totalJoltage = 0;

  for (const bank of banks) {
    const batteries = bank.split("").map((b) => parseInt(b));
    const joltage = highestVoltage(batteries, 2);
    totalJoltage += joltage;
  }

  console.log("[Day 3, Puzzle 1] Answer:", totalJoltage);
};

const puzzle2 = () => {
  console.log("[Day 3, Puzzle 2] Starting…");
  const input = fs.readFileSync("day3.txt", "utf8");
  const banks = input.trim().split("\n");
  let totalJoltage = 0;

  for (const bank of banks) {
    const batteries = bank.split("").map((b) => parseInt(b));
    const joltage = highestVoltage(batteries, 12);
    totalJoltage += joltage;
  }

  console.log("[Day 3, Puzzle 2] Answer:", totalJoltage);
};

const highestVoltage = (batteries, maxLength) => {
  const highestBatteries = [];

  let startIndex = 0;
  let remainingLength = maxLength;

  while (remainingLength > 0) {
    const { number, index } = nextLargestBattery(
      batteries,
      startIndex,
      remainingLength,
    );
    highestBatteries.push(number);
    startIndex = index + 1;
    remainingLength--;
  }

  const result = highestBatteries.map((n) => n.toString()).join("");

  return parseInt(result);
};

const nextLargestBattery = (batteries, startIndex, maxLength) => {
  let highestNumber = 0;
  let highestIndex = 0;
  let maxIndex = batteries.length - maxLength;

  batteries.forEach((battery, index) => {
    if (index < startIndex || index > maxIndex) {
      return;
    }

    if (battery > highestNumber) {
      highestNumber = battery;
      highestIndex = index;
    }
  });

  return { number: highestNumber, index: highestIndex };
};

puzzle1();
puzzle2();
