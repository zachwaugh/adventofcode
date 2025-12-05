import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day {{day}}, Puzzle 1] Starting…");
  const input = fs.readFileSync("day{{day}}-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day {{day}}, Puzzle 1] Answer:", result);
};

const puzzle2 = () => {
  console.log("[Day {{day}}, Puzzle 2] Starting…");
  const input = fs.readFileSync("day{{day}}-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day {{day}}, Puzzle 2] Answer:", result);
};

puzzle1();
puzzle2();
