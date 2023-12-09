import fs from 'fs';

const DAY = "day8"

/// BEGIN UTILS ///

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/${DAY}/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const isNumber = (s: string): boolean => {
    return !isNaN(parseInt(s, 10));
}

const parseInts = (str: string): number[] => {
    return str.match(/(\d+)/g)?.map((d) => parseInt(d, 10)) ?? [];
}

const pairs = <T>(array: T[]): T[][] => {
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

const mult = (values: number[]) => {
    return values.reduce((acc, value) => {
        return acc * value;
    }, 1);
}

const sumMult = (values: number[]) => {
    return values.reduce((acc, value, index) => {
        return acc + value * index + 1;
    }, 0)
}

const gcd = (x: number, y: number): number => (!x ? y : gcd(y % x, x));

const lcm = (arr: number[]) => {
    const _lcm = (x: number, y: number): number => (x * y) / gcd(x, y);
    return [...arr].reduce((a, b) => _lcm(a, b));
};

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

/// END UTILS ///

type Path = {
    start: string;
    left: string;
    right: string;
}

type Paths = {
    [path: string]: Path;
}

const startingPaths: Path[] = [];

const parseDirections = (line: string): string[] => {
    const directions = line.split("");
    return directions;
}

const parsePath = (line: string): Path => {
    const matches = line.match(/(\w+)\s+=\s+\((\w+),\s+(\w+)\)/)
    if (!matches) {
        console.log("ERROR not matches")
        return {
            start: "",
            left: "",
            right: "",
        }
    }
    return {
        start: matches[1],
        left: matches[2],
        right: matches[3],
    }
}

const parsePaths = (lines: string[]): Paths => {
    return lines.reduce<Paths>((acc, line) => {
        if (line === "") {
            return acc;
        }
        const path = parsePath(line);
        if (path.start.match(/^\w{2}A$/)) {
            startingPaths.push(path);
        }
        acc[path.start] = path;
        return acc;
    }, {})
}

const traverse1 = (directions: string[], paths: Paths): number => {
    const start = "AAA";
    const end = "ZZZ";
    let steps = 0;
    let currentNode = start;
    while (currentNode !== end) {
        const direction = directions[steps % directions.length];
        const path = paths[currentNode];
        switch (direction) {
            case "L": {
                currentNode = path.left;
                break;
            }
            case "R": {
                currentNode = path.right;
                break;
            }
            default: {
                console.log("ERROR - unknown direction", { direction })
                break;
            }
        }
        steps += 1;
    }
    return steps;
}

const atEnd = (path: string): boolean => {
    return !!path.match(/^\w{2}Z$/)
}
const allAtEnd = (paths: Path[]): boolean => {
    return paths.every((path) => atEnd(path.start));
}

// too slow
const traverse2Bad = (directions: string[], paths: Paths): number => {
    let steps = 0;
    let currentNodes: Path[] = startingPaths;
    while (!allAtEnd(currentNodes)) {
        const direction = directions[steps % directions.length];
        const nextNodes: Path[] = [];
        for (let i = 0; i < currentNodes.length; i++) {
            const currentNode = currentNodes[i];
            const path = paths[currentNode.start];
            switch (direction) {
                case "L": {
                    nextNodes.push(paths[path.left]);
                    break;
                }
                case "R": {
                    nextNodes.push(paths[path.right]);
                    break;
                }
                default: {
                    console.log("ERROR - unknown direction", { direction })
                    break;
                }
            }
        }
        currentNodes = nextNodes;
        steps += 1;
    }
    return steps;
}


const traverse2 = (start: string, directions: string[], paths: Paths): number => {
    let steps = 0;
    let currentNode = start;
    while (!atEnd(currentNode)) {
        const direction = directions[steps % directions.length];
        const path = paths[currentNode];
        switch (direction) {
            case "L": {
                currentNode = path.left;
                break;
            }
            case "R": {
                currentNode = path.right;
                break;
            }
            default: {
                console.log("ERROR - unknown direction", { direction })
                break;
            }
        }
        steps += 1;
    }
    return steps;
}

const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    const [directionStr, ...rest] = input;
    const directions = parseDirections(directionStr);
    const paths = parsePaths(rest);
    const steps = traverse1(directions, paths);
    console.log("part1", { steps })
}

const part2 = (fileName: string) => {
    const input = parseInput(fileName);
    const [directionStr, ...rest] = input;
    const directions = parseDirections(directionStr);
    const paths = parsePaths(rest);
    const steps = startingPaths.map((start) => {
        return traverse2(start.start, directions, paths);
    })
    const result = lcm(steps);
    console.log("part2", { steps, result })
}

// part1('example1')
// part1('example2')
// part1('input')
// part2('example3')
part2('input')
