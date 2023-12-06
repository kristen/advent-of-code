import fs from 'fs';

const parseInput = (fileName: string, day: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/${day}/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const isNumber = (s: string): boolean => {
    return !isNaN(parseInt(s, 10));
}

const parseInts = (str: string): number[] => {
    return str.match(/(\d+)/g)?.map((d) => parseInt(d, 10)) ?? [];
}

const parseNumbers = (str: string): string[] => {
    return str.match(/(\d+)/g)?.map((d) => d) ?? [];
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

const concat = (values: string[]) => {
    return values.reduce((acc, value) => {
        return acc + value;
    }, "");
}

const mult = (values: number[]) => {
    return values.reduce((acc, value) => {
        return acc * value;
    }, 1);
}

const zip = <T>([top, bottom]: T[][]): T[][] => {
    return top.map((a, i) => [a, bottom[i]]);
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

const distance = (hold: number, maxTime: number): number => {
    return (maxTime - hold) * hold;
}

const numWaysToBeat = (maxTime: number, recordDistance: number): number => {
    let minTime = 0;
    for (let holdTime = 0; holdTime < maxTime; holdTime++) {
        const dist = distance(holdTime, maxTime);
        if (dist > recordDistance) {
            minTime = holdTime;
            break;
        }
    }

    let tempMaxTime = maxTime;
    for (let holdTime = maxTime; holdTime > 0; holdTime--) {
        const dist = distance(holdTime, maxTime);
        console.log({dist, holdTime})
        if (dist > recordDistance) {
            tempMaxTime = holdTime;
            break;
        }
    }

    console.log({ minTime, tempMaxTime });

    return tempMaxTime - minTime + 1;
}

const part1 = (fileName: string) => {
    const input = parseInput(fileName, 'day6');
    const nums = input.map((line) => parseInts(line));
    const records = zip(nums);
    const results = records.map(([maxTime, recordDistance]) => {
        return numWaysToBeat(maxTime, recordDistance);
    });
    console.log(mult(results))
    console.log("part1")
}


const part2 = (fileName: string) => {
    const input = parseInput(fileName, 'day6');
    const nums = input.map((line) => parseNumbers(line));
    // const records = zip(nums);
    const [maxTime, recordDistance] = [parseInt(concat(nums[0]), 10), parseInt(concat(nums[1]), 10)];
    const numWaysToBeatRecord = numWaysToBeat(maxTime, recordDistance)
    // const results = records.map(([maxTime, recordDistance]) => {
    //     return numWaysToBeat(maxTime, recordDistance);
    // });
    // console.log(mult(results))
    console.log("part2", numWaysToBeatRecord)
}


// part1('input')
part2('input')
