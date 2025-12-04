import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 4, Puzzle 1] Starting…");
  const input = fs.readFileSync("day4.txt", "utf8");
  const lines = input.trim().split("\n");
  const map = lines.map((l) => l.split(""));
  let totalCount = 0;

  map.forEach((row, y) => {
    row.forEach((element, x) => {
      if (element !== "@") {
        return;
      }

      const rolls = adjacentRolls(map, x, y);

      if (rolls < 4) {
        totalCount++;
      }
    });
  });

  console.log("[Day 4, Puzzle 1] Answer:", totalCount);
};

const puzzle2 = () => {
  console.log("[Day 4, Puzzle 2] Starting…");
  const input = fs.readFileSync("day4-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 4, Puzzle 2] Answer:", result);
};

const adjacentRolls = (map, x, y) => {
  const maxY = map.length - 1;
  const maxX = map[0].length - 1;
  let rolls = 0;

  const positions = [
    // Top-left
    { x: x - 1, y: y - 1 },
    // Top-center
    { x: x, y: y - 1 },
    // Top-right
    { x: x + 1, y: y - 1 },
    // Left
    { x: x - 1, y: y },
    // Right
    { x: x + 1, y: y },
    // Bottom-left
    { x: x - 1, y: y + 1 },
    // Bottom
    { x: x, y: y + 1 },
    // Bottom-right
    { x: x + 1, y: y + 1 },
  ];

  positions.forEach(({ x, y }) => {
    if (x < 0 || x > maxX || y < 0 || y > maxY) {
      return;
    }

    const value = map[y][x];
    if (value === "@") {
      rolls++;
    }
  });

  return rolls;
};

puzzle1();
puzzle2();
