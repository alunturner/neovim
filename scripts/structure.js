const fs = require("fs");
const path = require("path");

const configDirectory = path.join(__dirname, "..");
const excludedFolders = [".git", "scripts"];

const spacer = "    ";
const runner = "│   ";
const pointer = "─── ";
(".├ ─ └ │ ");

function recursivelyRenderFolder(path, depth = 1) {
    const items = fs.readdirSync(path, {
        encoding: "utf8",
        withFileTypes: true,
    });
    items
        .sort(showFilesBeforeFolders)
        .filter(shouldRenderItem)
        .forEach(renderItem, depth);
}

function showFilesBeforeFolders(a, z) {
    if (a.isFile() && z.isDirectory()) return -1;
    else if (a.isDirectory() && z.isFile()) return 1;
    else return 0;
}

function renderItem(item, index, array) {
    const isLastOfDepth = index === array.length - 1;
    const depth = this;

    let start = "├";
    if (isLastOfDepth) start = "└";

    if (item.isFile()) {
        console.log(
            `${depth > 1 ? spacer : ""}${runner.repeat(
                Math.max(depth - 2, 0),
            )}${start}${pointer}${item.name}`,
        );
    } else if (item.isDirectory()) {
        console.log(
            `${depth > 1 ? spacer : ""}${runner.repeat(
                Math.max(depth - 2, 0),
            )}${start}${pointer}${item.name}`,
        );
        recursivelyRenderFolder(`${item.path}/${item.name}`, depth + 1);
    }
}

function shouldRenderItem(item) {
    if (item.isFile()) return shouldRenderFile(item);
    else if (item.isDirectory()) return shouldRenderDirectory(item);
    return false;
}

function shouldRenderFile(file) {
    return file.name.endsWith(".lua");
}

function shouldRenderDirectory(folder) {
    return !excludedFolders.includes(folder.name);
}

console.log(".");
recursivelyRenderFolder(configDirectory);
