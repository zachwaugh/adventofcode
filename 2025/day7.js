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
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 7, Puzzle 2] Answer:", result);
};

const print = (map) => {
  map.forEach((row) => {
    console.log(row.join(""));
  });
};

puzzle1();
puzzle2();
