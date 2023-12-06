import fs from 'fs';

export const parseInput = (fileName: string, day: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/${day}/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const isNumber = (s: string): boolean => {
    return !isNaN(parseInt(s, 10));
}

export const parseInts = (str: string): number[] => {
    return str.match(/(\d+)/g)?.map((d) => parseInt(d, 10)) ?? [];
}

export const pairs = <T>(array: T[]): T[][] => {
    return array.reduce<T[][]>((result, _value, index, a) => {
        if (index % 2 === 0) {
            const pair = a.slice(index, index + 2);
            result.push(pair);
        }
        return result;
    }, []);
}

const sum = (values: number[]) => {
    return values.reduce((acc, value) => {
        return acc + value;
    }, 0);
}

const isValidPosition = (n: number, m: number) => (i: number, j: number): boolean => {
    if (i < 0 || j < 0 || i > n - 1 || j > m - 1)
        return false;
    return true;
}

const getAdjacent = (lines: string[], i: number, j: number): { char: string; k: number; l: number }[] => {
    // boundaries
    const n = lines.length;
    const m = lines[0].length;

    const isValid = isValidPosition(n, m);

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
    const input = parseInput(fileName, 'CHANGEME');
    console.log("part1")
}

part1('example')
