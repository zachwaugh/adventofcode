import fs from "fs";

if (!process.argv[2]) {
  console.log("No day provided!");
  process.exit(1);
}

const day = parseInt(process.argv[2]);
console.log("Creating new day.js file for:", day);

let template = fs.readFileSync("template.js", "utf8");
template = template.replaceAll("{{day}}", day);
console.log(template);

fs.writeFileSync(`day${day}.js`, template);
