import fs from "fs";
import assert from "assert";

const puzzle1 = () => {
  console.log("[Day 8, Puzzle 1] Starting…");
  const input = fs.readFileSync("day8.txt", "utf8");
  const points = input.trim().split("\n");
  const closestPairs = computeDistances(points);

  let circuits = [];

  closestPairs.slice(0, 1000).forEach((pair) => {
    const circuit1 = circuits.find((circuit) => circuit.has(pair.point1));
    const circuit2 = circuits.find((circuit) => circuit.has(pair.point2));

    if (circuit1 && circuit2) {
      // Matched two separate circuits, need to merge them
      // otherwise circuit contains both junction boxes already
      if (circuit1 !== circuit2) {
        circuit2.forEach((point) => circuit1.add(point));
        circuit2.clear();
      }
    } else if (circuit1 || circuit2) {
      // Add to existing circuit
      const circuit = circuit1 ?? circuit2;
      circuit.add(pair.point1);
      circuit.add(pair.point2);
    } else {
      // Create new circuit
      circuits.push(new Set([pair.point1, pair.point2]));
    }
  });

  circuits = circuits.filter((c) => c.size > 0).sort((a, b) => a.size < b.size);

  const result = circuits[0].size * circuits[1].size * circuits[2].size;

  // Test input
  //assert(result == 40);
  assert(result == 127551);
  console.log("[Day 8, Puzzle 1] Answer:", result);
};

const puzzle2 = () => {
  console.log("[Day 8, Puzzle 2] Starting…");
  const input = fs.readFileSync("day8-test.txt", "utf8");
  const lines = input.trim().split("\n");
  const result = "";

  console.log("[Day 8, Puzzle 2] Answer:", result);
};

const computeDistances = (points) => {
  const distances = [];
  const checkedPairs = new Set();

  points.forEach((point1) => {
    points.forEach((point2) => {
      if (point1 === point2) {
        return;
      }

      let hash = [point1, point2].sort().join("|");
      if (checkedPairs.has(hash)) {
        return;
      }

      distances.push({
        point1,
        point2,
        distance: distance(point1, point2),
      });
      checkedPairs.add(hash);
    });
  });

  return distances.sort((a, b) => a.distance > b.distance);
};

const parsePoint = (point) => {
  return point.split(",").map((s) => parseInt(s));
};

const distance = (point1, point2) => {
  const [x1, y1, z1] = parsePoint(point1);
  const [x2, y2, z2] = parsePoint(point2);

  return Math.sqrt(
    Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2) + Math.pow(z1 - z2, 2),
  );
};

puzzle1();
puzzle2();
