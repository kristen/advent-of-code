import fs from 'fs';

const wordNumbersToStringNumbers: { [number: string]: string } = {
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

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/day1/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const isNumber = (s: string): boolean => {
    return !isNaN(parseInt(s, 10));
}

const wordNumberStartingAtIndex = (str: string, index: number): string => {
    for (let wordNumber of wordNumbers) {
        const indexOfWord = str.indexOf(wordNumber, index);
        if (indexOfWord === index) {
            return wordNumber;
        }
    }
    return ""
}

const wordNumberEndingAtIndex = (str: string, index: number): string => {
    for (let wordNumber of wordNumbers) {
        const wordAdjustedIndex = index - wordNumber.length + 1;
        const indexOfWord = str.indexOf(wordNumber, wordAdjustedIndex);
        if (indexOfWord > 0 && indexOfWord === wordAdjustedIndex) {
            return wordNumber;
        }
    }
    return ""
}

const findFirstNumber = (str: string): string => {
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
    return ""
}

const findLastNumber = (str: string): string => {
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