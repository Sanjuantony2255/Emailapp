import fs from 'fs';

const js = fs.readFileSync("technopark_app.js", "utf8");

// Search for imports or chunks related to JobListingPage
const searchStr = "JobListingPage";
let index = js.indexOf(searchStr);
if (index !== -1) {
  console.log("Found 'JobListingPage' at index", index);
  console.log("...", js.substring(index - 100, index + 300), "...");
} else {
  console.log("Could not find 'JobListingPage' in JS bundle.");
}

// Let's search for all .js file names in the bundle
const jsFiles = js.match(/[a-zA-Z0-9_\-\/]+\.js/g) || [];
const uniqueJsFiles = [...new Set(jsFiles)];
console.log("\nUnique JS files in bundle:");
console.log(uniqueJsFiles.filter(f => f.includes("job") || f.includes("List")));

// Let's print the chunk imports mapping
// Minified vite projects usually have a mapping function of chunk names to urls
const mappingIndex = js.indexOf("assets/");
if (mappingIndex !== -1) {
  console.log("\nFound mapping pattern with 'assets/' at index", mappingIndex);
  console.log("...", js.substring(mappingIndex - 100, mappingIndex + 1000), "...");
}
