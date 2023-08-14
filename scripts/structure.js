const fs = require("fs");
const path = require("path");

const configDirectory = path.join(__dirname, "..");
const excludedFolders = [".git", "scripts"];

const V = "│";
const T = "├";
const H = "─";
const L = "└";

const spacer = "    ";
const runner = "   ";
const pointer = "─── ";

function shouldRenderFile(file) {
    return file.name.endsWith(".lua");
}

function shouldRenderDirectory(folder) {
    return !excludedFolders.includes(folder.name);
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

// ***
function getFolderStructure(path) {
    return getAllFilesAndFolders(path)
        .filter(shouldRenderPath)
        .sort()
        .map(createTreeItems)
        .map(createDisplayItems);
}

function getAllFilesAndFolders(path) {
    return fs.readdirSync(path, {
        encoding: "utf8",
        recursive: true,
    });
}

function shouldRenderPath(path) {
    if (path.startsWith("lua") || path.endsWith(".lua")) return true;
    return false;
}

function createTreeItems(path) {
    const parts = path.split("/");
    const depth = parts.length;
    const name = parts.pop();
    const display = "    ".repeat(depth) + name;
    return { parts, depth, name, display };
}

function createDisplayItems(treeItem) {
    return treeItem.display;
}

console.log(getFolderStructure(configDirectory));
