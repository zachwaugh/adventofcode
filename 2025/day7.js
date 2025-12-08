import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 7, Puzzle 1] Starting…");
  const input = fs.readFileSync("day7.txt", "utf8");
  const map = input
    .trim()
    .split("\n")
    .map((line) => line.split(""));

  const maxY = map.length - 1;
  let totalSplits = 0;

  map.forEach((line, y) => {
    line.forEach((char, x) => {
      const nextChar = y < maxY ? map[y + 1][x] : undefined;
      const isBeam = char === "S" || char === "|";
      if (isBeam && nextChar) {
        if (nextChar === "^") {
          totalSplits++;
          map[y + 1][x - 1] = "|";
          map[y + 1][x + 1] = "|";
        } else {
          map[y + 1][x] = "|";
        }
      }
    });
  });

  assert(totalSplits == 1562);
  console.log("[Day 7, Puzzle 1] Answer:", totalSplits);
};

const puzzle2 = () => {
  console.log("[Day 7, Puzzle 2] Starting…");
  const input = fs.readFileSync("day7-test.txt", "utf8");
  const map = input
    .trim()
    .split("\n")
    .map((line) => line.split(""));

  const startX = map[0].findIndex((c) => c === "S");
  const totalPaths = traverse(map, startX, 0);

  console.log("[Day 7, Puzzle 2] Answer:", totalPaths);
};

const traverse = (map, x, y) => {
  const maxY = map.length - 1;

  while (y < maxY) {
    const nextY = y + 1;

    const nextChar = y < maxY ? map[nextY][x] : undefined;

    if (nextChar === "^") {
      return traverse(map, x - 1, nextY) + traverse(map, x + 1, nextY);
    }

    y++;
  }

  return 1;
};

puzzle1();
puzzle2();
