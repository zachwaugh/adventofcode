import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 9, Puzzle 1] Starting…");
  const input = fs.readFileSync("day9.txt", "utf8");
  const squares = input
    .trim()
    .split("\n")
    .map((line) => line.split(",").map((value) => parseInt(value)));

  const areas = [];

  squares.forEach((point1) => {
    const [x1, y1] = point1;

    squares.forEach((point2) => {
      const [x2, y2] = point2;

      if (x1 === x2 && y1 === y2) {
        return;
      }

      const area = computeArea(point1, point2);
      areas.push(area);
    });
  });

  areas.sort((a, b) => a < b);
  const result = areas[0];

  console.log("[Day 9, Puzzle 1] Answer:", result);

  // Test input
  //assert(result == 50);
  assert(result == 4781546175);
};

const puzzle2 = () => {
  console.log("[Day 9, Puzzle 2] Starting…");
  const input = fs.readFileSync("day9-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 9, Puzzle 2] Answer:", result);
};

const computeArea = (p1, p2) => {
  const [x1, y1] = p1;
  const [x2, y2] = p2;

  const width = Math.abs(x1 - x2) + 1;
  const length = Math.abs(y1 - y2) + 1;
  return width * length;
};

puzzle1();
puzzle2();
