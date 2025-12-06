import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 6, Puzzle 1] Starting…");
  const input = fs.readFileSync("day6.txt", "utf8");
  const problems = parseInput(input);
  let total = 0;

  problems.forEach((problem) => {
    const result = problem.operands.reduce((accumulator, currentValue) => {
      switch (problem.operator) {
        case "+":
          return accumulator + currentValue;
        case "-":
          return accumulator - currentValue;
        case "*":
          return accumulator === 0 ? currentValue : accumulator * currentValue;
        case "/":
          return accumulator === 0 ? currentValue : accumulator / currentValue;
        default:
          console.log(`Unhandled operator! ${problem.operator}`);
          process.exit(1);
      }
    }, 0);

    total += result;
  });

  // Correct answer: 6295830249262
  console.log("[Day 6, Puzzle 1] Answer:", total);
};

const puzzle2 = () => {
  console.log("[Day 6, Puzzle 2] Starting…");
  const input = fs.readFileSync("day6-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 6, Puzzle 2] Answer:", result);
};

const parseInput = (input) => {
  const lines = input.trim().split("\n");
  const problems = [];

  lines.forEach((line, index) => {
    const values = line.split(" ").filter((string) => string.length > 0);

    values.forEach((value, problemIndex) => {
      if (index < lines.length - 1) {
        // Operands
        const num = parseInt(value);
        if (index === 0) {
          problems.push({ operands: [num] });
        } else {
          const problem = problems[problemIndex];
          problem.operands.push(num);
        }
      } else {
        // Operators
        problems[problemIndex].operator = value;
      }
    });
  });

  return problems;
};

puzzle1();
puzzle2();
