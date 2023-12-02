import fs from "fs";

const day = process.argv[2];
const part = process.argv[3];
const file = `/${day}/${part}.js`;
const path = __dirname + file;
console.log("executing file", path);
eval(fs.readFileSync(path)+'');
