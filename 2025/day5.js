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
  const input = fs.readFileSync("day5.txt", "utf8");
  const lines = input.trim().split("\n");
  const delimeter = lines.findIndex((line) => line === "");
  const ranges = lines.slice(0, delimeter).map((r) => parseRange(r));
  let totalCount = 0;

  // Merge overlapping ranges before counting
  for (let i = 0; i < ranges.length; i++) {
    for (let j = 0; j < ranges.length; j++) {
      if (i === j) {
        continue;
      }

      const range1 = ranges[i];
      const range2 = ranges[j];
      const merged = mergeRanges(range1, range2);
      if (merged) {
        ranges[i] = merged;
        ranges.splice(j, 1);

        // Need to go back and re-run against the newly merged range
        i--;
        break;
      }
    }
  }

  ranges.forEach((range) => {
    const { start, end } = range;
    totalCount += end - start + 1;
  });

  console.log("[Day 5, Puzzle 2] Answer:", totalCount);
};

const rangeContainsIngredient = (rawRange, ingredient) => {
  const { start, end } = parseRange(rawRange);
  const value = parseInt(ingredient);

  return value >= start && value <= end;
};

const parseRange = (range) => {
  const delimeter = range.indexOf("-");
  const start = parseInt(range.substr(0, delimeter));
  const end = parseInt(range.substr(delimeter + 1));
  return { start, end };
};

const mergeRanges = (range1, range2) => {
  if (range1.end < range2.start || range2.end < range1.start) {
    return null;
  }

  return {
    start: Math.min(range1.start, range2.start),
    end: Math.max(range1.end, range2.end),
  };
};

puzzle1();
puzzle2();
