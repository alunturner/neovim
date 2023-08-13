const fs = require("fs");
const path = require("path");

const configDirectory = path.join(__dirname, "..");
const excludedFolders = [".git", "scripts"];

function recursivelyRenderFolder(path, depth = 0) {
  const items = fs.readdirSync(path, { encoding: "utf8", withFileTypes: true });
  const files = [];
  const folders = [];

  items.forEach((item) => {
    if (item.isFile() && item.name.endsWith(".lua")) {
      files.push(item);
    } else if (item.isDirectory() && !excludedFolders.includes(item.name)) {
      folders.push(item);
    }
  });

  files.forEach((file) => console.log(`${"  ".repeat(depth)}${file.name}`));
  folders.forEach((folder) => {
    console.log(`${"  ".repeat(depth)}${folder.name}`);
    recursivelyRenderFolder(`${folder.path}/${folder.name}`, depth + 1);
  });
}

recursivelyRenderFolder(configDirectory);
