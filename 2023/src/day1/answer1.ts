import fs from 'fs';

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/day1/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const isNumber = (s: string): boolean => {
    return !isNaN(parseInt(s, 10));
}

const findFirstNumber = (str: string): string => {
    for (let i = 0; i < str.length; i++) {
        const char = str[i];
        if (isNumber(char)) {
            return char;
        }
    }
    return ""
}

const findLastNumber = (str: string): string | undefined => {
    for (let i = str.length - 1; i >= 0; i--) {
        const char = str[i];
        if (isNumber(char)) {
            return char;
        }
    }
    return ""
}

const parseStringForNumber = (str: string): number => {
    const firstNumber = findFirstNumber(str);
    const lastNumber = findLastNumber(str);
    const numberString = firstNumber + lastNumber;
    return parseInt(numberString, 10);
}

const parseNumbers = (fileName: string) => {
    const lines = parseInput(fileName);
    const result = lines.reduce((acc, line) => {
        const number = parseStringForNumber(line);
        return acc + number;
    }, 0)
    console.log('result', result);
}

parseNumbers('input')