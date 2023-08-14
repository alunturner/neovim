const fs = require("fs");
const node_path = require("path");

const configDirectory = node_path.join(__dirname, "..");

const FILE = "file";
const FOLDER = "folder";

const spacer = "    ";
const runner = "│   ";
const lastPointer = "└── ";
const normalPointer = "├── ";

function updateStructureMarkdown() {
    const content = generateStructureText(configDirectory);
    fs.writeFileSync(node_path.join(__dirname, "structure.md"), content);
}

function generateStructureText(path) {
    return getAllFilesAndFolders(path)
        .filter(shouldRenderPath)
        .sort()
        .map(createTreeItems)
        .map(createDisplayLines)
        .join("\n");
}

function getAllFilesAndFolders(path) {
    return fs.readdirSync(path, {
        encoding: "utf8",
        recursive: true,
    });
}

function shouldRenderPath(path) {
    return path.startsWith("lua") || path.endsWith(".lua");
}

function createTreeItems(path) {
    const parts = path.split("/");
    const depth = parts.length;
    const name = parts.pop();
    const type = name.endsWith(".lua") ? FILE : FOLDER;

    return { name, depth, path, type };
}

function createDisplayLines(treeItem, index, array) {
    const { name, depth, type, path } = treeItem;
    const description = getDescriptionForTreeItem(treeItem);

    // we use the elbow when either the next line is less nested, or
    // we are looking at the last item at that level
    const isLastOfDepth =
        array.at(index + 1)?.depth < depth ||
        array.findLastIndex((item) => item.depth === depth) === index;

    // we need runners to track the vertical lines for nested files, to do
    // this we look ahead to see if there is a next item that is less nested
    const nextItems = array.slice(index + 1);
    const needsRunners = nextItems.find((item) => item.depth === depth - 1);

    const pointer = isLastOfDepth ? lastPointer : normalPointer;

    let display =
        spacer.repeat(Math.max(depth - 1, 0)) + pointer + name + description;
    if (needsRunners) {
        display =
            spacer +
            runner.repeat(Math.max(depth - 2, 0)) +
            pointer +
            name +
            description;
    }

    return display;
}

function getDescriptionForTreeItem({ path, type }) {
    if (type === FOLDER) return "";

    const file = fs.readFileSync(node_path.join(__dirname, "..", path), "utf8");
    const structureRegex = /--!structure::(?<comment>.*)/;
    const usesRegex = /\s*"(?<url>.*)".*--!uses::(?<displayName>.*)/;

    let description = "";

    file.split("\n").forEach((line) => {
        const structureMatches = line.match(structureRegex);
        const usesMatches = line.match(usesRegex);
        if (structureMatches) {
            description += " - " + structureMatches.groups.comment;
        } else if (usesMatches) {
            const githubUrl = "https://github.com/";
            const { url, displayName } = usesMatches.groups;
            const displayUrl = url.startsWith(githubUrl)
                ? url
                : githubUrl + url.trim();

            description += `, uses [${displayName}](${displayUrl})`;
        }
    });

    return description;
}

updateStructureMarkdown();
