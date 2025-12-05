import fs from "fs";

if (!process.argv[2]) {
  console.log("No day provided!");
  process.exit(1);
}

const day = parseInt(process.argv[2]);
console.log("Creating new day.js file for:", day);
const filename = `day${day}.js`;

if (fs.existsSync(filename)) {
  console.error("File already exists!", filename);
  process.exit(1);
}

let template = fs.readFileSync("template.js", "utf8");
template = template.replaceAll("{{day}}", day);
console.log(template);

fs.writeFileSync(filename, template);
