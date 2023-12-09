import fs from 'fs';

const DAY = "day9"
const LOGGING = false;

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
    return str.match(/-?\d+/g)?.map((d) => parseInt(d, 10)) ?? [];
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

const differenceArray = (sequence: number[]): number[] => {
    const result = []
    for (let i = 0; i < sequence.length - 1; i++) {
        const x = sequence[i];
        const y = sequence[i + 1];
        result.push(y - x);
    }
    return result;
}

const findNextNumberInSequence = (sequence: number[]): number => {
    const allZero = (nums: number[]) => nums.every((n) => n === 0);
    const differences: number[][] = [sequence];
    if (LOGGING) console.log("sequence", sequence);
    // check if all 0s
    while (!allZero(differences[differences.length - 1])) {
        // array of difference at each step (length -1 of line length)
        const newDifferenceArray = differenceArray(differences[differences.length - 1]);
        if (LOGGING) console.log({
            differences,
            newDifferenceArray
        })
        differences.push(newDifferenceArray);
    }

    for (let i = differences.length - 1; i >= 0; i--) {
        const diffArray = differences[i];
        if (i === differences.length - 1) {
            if (LOGGING) console.log("at END - push 0")
            diffArray.push(0);
        } else {
            // get previous diffArray
            const prevDiffArray = differences[i + 1];
            // get last of both prev diff and diff and add
            const newValue = prevDiffArray[prevDiffArray.length - 1] + diffArray[diffArray.length - 1];
            if (LOGGING) console.log("summing values", {
                prevLastValue: prevDiffArray[prevDiffArray.length - 1],
                currLastValue: diffArray[diffArray.length - 1],
                newValue,
            })
            // push on new value
            diffArray.push(newValue);
        }
    }

    if (LOGGING) console.log(differences, differences[0][0])
    const [first] = differences;

    return first[first.length - 1];
}

const findPrevNumberInSequence = (sequence: number[]): number => {
    const allZero = (nums: number[]) => nums.every((n) => n === 0);
    const differences: number[][] = [sequence];
    if (LOGGING) console.log("sequence", sequence);
    // check if all 0s
    while (!allZero(differences[differences.length - 1])) {
        // array of difference at each step (length -1 of line length)
        const newDifferenceArray = differenceArray(differences[differences.length - 1]);
        if (LOGGING) console.log({
            differences,
            newDifferenceArray
        })
        differences.push(newDifferenceArray);
    }

    if (LOGGING) console.log("differences", differences);

    for (let i = differences.length - 1; i >= 0; i--) {
        const diffArray = differences[i];
        if (i === differences.length - 1) {
            diffArray.unshift(0);
            if (LOGGING) console.log("at END - unshift 0", diffArray)
        } else {
            // get previous diffArray
            const prevDiffArray = differences[i + 1];
            // get first of both prev diff and diff and add
            const newValue = diffArray[0] - prevDiffArray[0];
            if (LOGGING) console.log("summing values", {
                prevLastValue: prevDiffArray[0],
                currLastValue: diffArray[0 + 1],
                newValue,
            })
            // push on new value
            diffArray.unshift(newValue);
        }
    }

    if (LOGGING) console.log("differences[0][0]", differences[0][0])
    return differences[0][0];
}


/// END UTILS ///

const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    const numbers = input.map((line) => parseInts(line));
    const nextNumbers = numbers.map((nums) => findNextNumberInSequence(nums));
    const result = sum(nextNumbers);
    console.log("part1", result)
}

const part2 = (fileName: string) => {
    const input = parseInput(fileName);
    const numbers = input.map((line) => parseInts(line));
    const nextNumbers = numbers.map((nums) => findPrevNumberInSequence(nums));
    const result = sum(nextNumbers);
    console.log("part2", result)
}

// part1('example')
// part1('input')
// part2('example')
part2('input')
