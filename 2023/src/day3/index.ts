
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

const isNumber = (char: string): boolean => {
    return !!char.match(/\d/);
}

const containsSymbol = (chars: string[]): boolean => {
    return chars.some((char) => isSymbol(char));
}

const isValidPos = (n: number, m: number) => (i: number, j: number): boolean => {
    if (i < 0 || j < 0 || i > n - 1 || j > m - 1)
        return false;
    return true;
}

const getAdjacent = (lines: string[], i: number, j: number): string[] => {
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
            return [lines[k][l]];
        }
        return [];
    })
}

// given a position i, j
// is there a symbol touching it
// don't check out of bounds
// numbers can be more than 1 char long

// const findPartNumbers = (line: string): number[] => {
//     for (let i = 0; i < line.length; i++) {
//         const char = line[i];
//         const adjacentChar = getAdjacent()

//     }
//     return [...line.matchAll(/(\d+)/g)].reduce((acc, match, i) => {
//         const [numberStr, _, startsAt] = match;
//         // see if symbol is adjacent
//         const endAt = startsAt + numberStr.length;
//         console.log({
//             numberStr,
//             startsAt,
//             endAt,
//         });

//         for (let j = 0; j < numberStr.length; j++) {
//             // if i check row above

//         }

//         return acc;
//     }, [])
// }

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
                    if (containsSymbol(adjacentChars)) {
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

part1('input')