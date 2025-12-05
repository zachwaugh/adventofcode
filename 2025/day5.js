import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 5, Puzzle 1] Starting…");
  const input = fs.readFileSync("day5.txt", "utf8");
  const lines = input.trim().split("\n");
  const delimeter = lines.findIndex((line) => line === "");
  const freshRanges = lines.slice(0, delimeter);
  const ingredients = lines.slice(delimeter + 1);
  let totalFresh = new Set();

  ingredients.forEach((ingredient) => {
    freshRanges.forEach((range) => {
      if (rangeContainsIngredient(range, ingredient)) {
        totalFresh.add(ingredient);
      }
    });
  });

  console.log("[Day 5, Puzzle 1] Answer:", totalFresh.size);
};

const puzzle2 = () => {
  console.log("[Day 5, Puzzle 2] Starting…");
  const input = fs.readFileSync("day5-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 5, Puzzle 2] Answer:", result);
};

const rangeContainsIngredient = (range, ingredient) => {
  const delimeter = range.indexOf("-");
  const start = parseInt(range.substr(0, delimeter));
  const end = parseInt(range.substr(delimeter + 1));
  const value = parseInt(ingredient);

  return value >= start && value <= end;
};

puzzle1();
puzzle2();
