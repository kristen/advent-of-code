
import fs from 'fs';

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/day3/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

// how to define adjacent in programming

// literally before or after
// literally above or below
// what about diagonal
//    above +- 1
//    below +- 1

// symbol is defined as not . and not digit

const isSymbol = (char: string): boolean => {
    return !char.match(/\d|\./)
}

const isGear = (char: string): boolean => {
    return char === "*";
}

const isNumber = (char: string): boolean => {
    return !!char.match(/\d/);
}

const containsSymbol = (chars: string[]): boolean => {
    return chars.some((char) => isSymbol(char));
}

const containsGear = (chars: { char: string; k: number; l: number }[]): { char: string; k: number; l: number } | undefined => {
    return chars.find(({ char }) => {
        return isGear(char);
    });
}

const isValidPos = (n: number, m: number) => (i: number, j: number): boolean => {
    if (i < 0 || j < 0 || i > n - 1 || j > m - 1)
        return false;
    return true;
}

const getAdjacent = (lines: string[], i: number, j: number): { char: string; k: number; l: number }[] => {
    // boundaries
    const n = lines.length;
    const m = lines[0].length;

    const isValid = isValidPos(n, m);

    const adjacentIndicies = [
        [i - 1, j - 1],
        [i - 1, j],
        [i - 1, j + 1],
        [i, j - 1],
        [i, j + 1],
        [i + 1, j - 1],
        [i + 1, j],
        [i + 1, j + 1],
    ];

    return adjacentIndicies.flatMap(([k, l]) => {
        if (isValid(k, l)) {
            return [{ char: lines[k][l], k, l }];
        }
        return [];
    })
}


const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    const partNumbers = [];
    for (let i = 0; i < input.length; i++) {
        const line = input[i];
        console.log("---line---")
        console.log(line)
        let partNumber = "";
        let hasAdjacentSymbol = false;
        for (let j = 0; j < line.length; j++) {
            const char = line[j];
            if (isNumber(char)) {
                console.log("is number", {
                    partNumber,
                    char,
                    i,
                    j,
                    length: line.length
                })
                partNumber = partNumber + char;
                if (!hasAdjacentSymbol) {
                    const adjacentChars = getAdjacent(input, i, j);
                    console.log("adjacentChars", adjacentChars)
                    if (containsSymbol(adjacentChars.map(({ char }) => char))) {
                        console.log("has adjacent symbol", { char })
                        hasAdjacentSymbol = true;
                    }
                }
            }
            // if not number anymore or at end of line
            if (!isNumber(char) || j === line.length - 1) {
                console.log('NOT number anymore', { char, partNumber, hasAdjacentSymbol })
                if (hasAdjacentSymbol && partNumber) {
                    const number = parseInt(partNumber, 10);
                    console.log("SAVING part number", number)
                    partNumbers.push(number)
                } else {
                    if (partNumber) {
                        console.log("NOT saving part", parseInt(partNumber, 10));
                    }
                }
                partNumber = "";
                hasAdjacentSymbol = false;
            }
        }
    }
    console.log("part1", partNumbers)
    console.log("result", partNumbers.reduce((acc, n) => acc + n), 0);
}


// iterate through lines
// if find gear, look at adjacent numbers
// if exactly 2 adjacent number, find full numbers and multiply
// sum up all numbers

const part2 = (fileName: string) => {
    const input = parseInput(fileName);
    // store numbers adjacent to gears
    // gears identified by position
    const gearParts: { [gearLocation: string]: number[] } = {};
    for (let i = 0; i < input.length; i++) {
        const line = input[i];
        console.log("---line---")
        console.log(line)
        let partNumber = "";
        let gearLocation = "";
        for (let j = 0; j < line.length; j++) {
            const char = line[j];
            if (isNumber(char)) {
                console.log("is number", {
                    partNumber,
                    char,
                    i,
                    j,
                    length: line.length
                })
                partNumber = partNumber + char;
                const adjacentChars = getAdjacent(input, i, j);
                console.log("adjacentChars", adjacentChars)
                const maybeGear = containsGear(adjacentChars);
                if (maybeGear) {
                    gearLocation = `(${maybeGear.k}, ${maybeGear.l})`;
                    console.log("has adjacent GEAR", { char, gearLocation })
                }
            }
            // if not number anymore or at end of line
            if (!isNumber(char) || j === line.length - 1) {
                console.log('NOT number anymore', { char, partNumber, gearLocation })
                if (gearLocation && partNumber) {
                    const number = parseInt(partNumber, 10);
                    console.log("SAVING part number", number)
                    gearParts[gearLocation] = gearParts[gearLocation] ?? [];
                    gearParts[gearLocation].push(number);
                } else {
                    if (partNumber) {
                        console.log("NOT saving part", parseInt(partNumber, 10));
                    }
                }
                partNumber = "";
                gearLocation = "";
            }
        }
    }
    console.log("part2", gearParts)
    const validGears = Object.values(gearParts).filter((parts) => {
        return parts.length === 2;
    })
    console.log("validGears", validGears)
    const result = validGears.map(([p1, p2]) => p1 * p2).reduce((sum, ratio) => sum + ratio, 0);
    console.log("result", result);
}

part2('input')