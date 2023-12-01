import fs from 'fs';

const parseInput = (fileName) => {
    const inputString = fs.readFileSync(fileName).toString();
    const lines = inputString.split('\n');
    console.log(lines)
    return lines
}

const isNumber = (s) => {
    return !isNaN(parseInt(s, 10));
}

const findFirstNumber = (str) => {
    for (let i = 0; i < str.length; i++) {
        const char = str[i];
        if (isNumber(char)) {
            return char;
        }
    }
}

const findLastNumber = (str) => {
    for (let i = str.length - 1; i >= 0; i--) {
        const char = str[i];
        if (isNumber(char)) {
            return char;
        }
    }
}

const parseStringForNumber = (str) => {
    const firstNumber = findFirstNumber(str);
    const lastNumber = findLastNumber(str);
    const numberString = firstNumber + lastNumber;
    return parseInt(numberString, 10);
}

const parseNumbers = (fileName) => {
    const lines = parseInput(fileName);
    const result = lines.reduce((acc, line) => {
        const number = parseStringForNumber(line);
        return acc + number;
    }, 0)
    console.log('result', result);
}

parseNumbers('input')