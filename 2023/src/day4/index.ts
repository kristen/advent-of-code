import fs from 'fs';

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/day4/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

const parseLine = (line: string) => {
    const [card, numbers] = line.split(":")
    const cardNumber = card.match(/(\d+)/)![1]
    const [winningNumbersStr, scratchedNumbersStr] = numbers.split("|");
    const winningNumbers = winningNumbersStr.split(" ").filter((s) => s)
    const scratchedNumbers = scratchedNumbersStr.split(" ").filter((s) => s)
    return { cardNumber, winningNumbers, scratchedNumbers }
}

const getMatches = (winningNumbers: string[], scratchedNumbers: string[]): number => {
    return scratchedNumbers.reduce((acc, number) => {
        if (winningNumbers.includes(number)) {
            return acc + 1
        }
        return acc;
    }, 0);
}

const getScore = (winningNumbers: string[], scratchedNumbers: string[]): number => {
    const matches = getMatches(winningNumbers, scratchedNumbers);
    if (matches > 0) {
        return Math.pow(2, matches - 1);
    }
    return 0;
}

const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    const finalScore = input.reduce((runningScore, line) => {
        const { winningNumbers, scratchedNumbers } = parseLine(line);
        const scratcherScore = getScore(winningNumbers, scratchedNumbers)
        return runningScore + scratcherScore;
    }, 0)
    console.log("part1", { finalScore })
}

type Matches = {
    [cardNumber: string]: number
}

const part2 = (fileName: string) => {
    const input = parseInput(fileName);
    const cardCountTotals: Matches = {}
    const matches = input.reduce<Matches>((matches, line) => {
        const { cardNumber, winningNumbers, scratchedNumbers } = parseLine(line);
        cardCountTotals[cardNumber] = 1;
        const numOfMatches = getMatches(winningNumbers, scratchedNumbers);
        matches[cardNumber] = numOfMatches;
        return matches
    }, {});

    // cards are indexed starting at 1
    for (let i = 1; i < input.length + 1; i++) {
        const cardNumber = i + "";
        const numOfMatches = matches[cardNumber];
        console.log({ cardNumber, cardCountTotals, numOfMatches });
        for (let j = 0; j < numOfMatches; j++) {
            const additionalCardNumber = j + i + 1 + "";
            console.log({ j, additionalCardNumber });
            cardCountTotals[additionalCardNumber] += cardCountTotals[cardNumber];
        }
    }

    const result = Object.values(cardCountTotals).reduce((acc, count) => acc + count, 0);
    console.log("result", { result })
}

// part1('input')
part2('input')