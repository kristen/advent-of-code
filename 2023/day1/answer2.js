import fs from 'fs';

const wordNumbersToStringNumbers = {
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
}

const wordNumbers = Object.keys(wordNumbersToStringNumbers);

const parseInput = (fileName) => {
    const inputString = fs.readFileSync(fileName).toString();
    const lines = inputString.split('\n');
    return lines
}

const isNumber = (s) => {
    return !isNaN(parseInt(s, 10));
}

const wordNumberStartingAtIndex = (str, index) => {
    for (let wordNumber of wordNumbers) {
        const indexOfWord = str.indexOf(wordNumber, index);
        if (indexOfWord === index) {
            return wordNumber;
        }
    }
}

const wordNumberEndingAtIndex = (str, index) => {
    for (let wordNumber of wordNumbers) {
        const wordAdjustedIndex = index - wordNumber.length + 1;
        const indexOfWord = str.indexOf(wordNumber, wordAdjustedIndex);
        if (indexOfWord > 0 && indexOfWord === wordAdjustedIndex) {
            return wordNumber;
        }
    }
}

const findFirstNumber = (str) => {
    for (let i = 0; i < str.length; i++) {
        // check if first letter is a digit
        const char = str[i];
        if (isNumber(char)) {
            return char;
        }
        // or check if indexOf starting at i has wordNumber at i
        const wordNumber = wordNumberStartingAtIndex(str, i);
        if (wordNumber) {
            return wordNumbersToStringNumbers[wordNumber];
        }
    }
}

const findLastNumber = (str) => {
    for (let i = str.length - 1; i >= 0; i--) {
        // check if last letter is a digit
        const char = str[i];
        if (isNumber(char)) {
            return char;
        }
        // or check if indexOf ending at i has wordNumber at i
        const wordNumber = wordNumberEndingAtIndex(str, i);
        if (wordNumber) {
            return wordNumbersToStringNumbers[wordNumber];
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