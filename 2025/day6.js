import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 6, Puzzle 1] Starting…");
  const input = fs.readFileSync("day6.txt", "utf8");
  const problems = parseInput(input);
  let total = 0;

  problems.forEach((problem) => {
    total += solve(problem);
  });

  assert(total == 6295830249262);
  console.log("[Day 6, Puzzle 1] Answer:", total);
};

const puzzle2 = () => {
  console.log("[Day 6, Puzzle 2] Starting…");
  const input = fs.readFileSync("day6.txt", "utf8");
  const problems = parseInput2(input);
  let total = 0;

  problems.forEach((problem) => {
    total += solve(problem);
  });

  assert(total == 9194682052782);
  console.log("[Day 6, Puzzle 2] Answer:", total);
};

const solve = (problem) => {
  return problem.operands.reduce((accumulator, currentValue) => {
    switch (problem.operator) {
      case "+":
        return accumulator + currentValue;
      case "*":
        return accumulator === 0 ? currentValue : accumulator * currentValue;
      default:
        console.log(`Unhandled operator! ${problem.operator}`);
        process.exit(1);
    }
  }, 0);
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

const parseInput2 = (input) => {
  const lines = input.split("\n").filter((line) => line.length > 0);
  const rows = lines.map((line) => line.split(""));
  const problems = [
    {
      operands: [],
      operator: "",
    },
  ];

  // Transpose into columns
  const columns = rows[0].map((_) => []);
  rows.forEach((row) => {
    row.forEach((char, index) => {
      columns[index].push(char);
    });
  });

  columns.forEach((column) => {
    const col = column.join("").trim();
    if (col === "") {
      problems.push({
        operands: [],
        operator: "",
      });
      return;
    }

    const problem = problems.at(-1);
    const lastChar = col.slice(-1);
    if (lastChar === "*" || lastChar === "+") {
      problem.operands.push(parseInt(col.slice(0, -1).trim()));
      problem.operator = lastChar;
    } else {
      problem.operands.push(parseInt(col));
    }
  });

  return problems;
};

puzzle1();
puzzle2();
