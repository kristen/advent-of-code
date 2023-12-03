import fs from 'fs';

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/dayCHANGEME/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    console.log("part1")
}

part1('example')
