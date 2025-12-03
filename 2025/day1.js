import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 1, Puzzle 1] Starting…");
  const input = fs.readFileSync("day1.txt", "utf8");
  const lines = input.trim().split("\n");
  const rotations = lines.map((line) => [line[0], parseInt(line.slice(1))]);

  let position = 50;
  let zeroCount = 0;

  for (const rotation of rotations) {
    const [direction, originalDistance] = rotation;
    const distance = originalDistance % 100;
    position = direction == "L" ? position - distance : position + distance;

    if (position < 0) {
      position = 100 + position;
    }

    if (position > 99) {
      position = position - 100;
    }

    assert(position >= 0 && position <= 99);

    if (position === 0) {
      zeroCount++;
    }
  }

  console.log("[Day 1, Puzzle 1] Answer:", zeroCount);
};

const puzzle2 = () => {
  console.log("[Day 1, Puzzle 2] Starting…");
  const input = fs.readFileSync("day1.txt", "utf8");
  const lines = input.trim().split("\n");
  const rotations = lines.map((line) => [line[0], parseInt(line.slice(1))]);

  let position = 50;
  let zeroCount = 0;

  for (const rotation of rotations) {
    let [direction, distance] = rotation;

    while (distance > 0) {
      position = direction == "L" ? position - 1 : position + 1;

      if (position < 0) {
        position = 99;
      } else if (position > 99) {
        position = 0;
      }

      if (position === 0) {
        zeroCount++;
      }

      distance -= 1;
    }
  }

  console.log("[Day 1, Puzzle 2] Answer:", zeroCount);
};

puzzle1();
puzzle2();
