import fs from 'fs';

const DAY = "day7"

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

// Camel Cards
// Hands
// 5 cards
// strength of hand

enum Suit {
    A = 14,
    K = 13,
    Q = 12,
    J = 11,
    T = 10,
    Nine = 9,
    Eight = 8,
    Seven = 7,
    Six = 6,
    Five = 5,
    Four = 4,
    Three = 3,
    Two = 2
}

enum Strength {
    HighCard,
    OnePair,
    TwoPair,
    ThreeOfAKind,
    FullHouse,
    FourOfAKind,
    FiveOfAKind
}

type Hand = {
    hand: string;
    bet: number;
}

type Hand2 = {
    hand: string;
    bet: number;
    strength: { strength: Strength, breakdown: { [suit: string]: number } };
}

const getStrengthOfCardPart1 = (card: string): number => {
    if (["A", "K", "Q", "J", "T"].includes(card)) {
        // @ts-ignore
        return Suit[card] as number;
    }
    switch (card) {
        case "2": return Suit.Two as number;
        case "3": return Suit.Three as number;
        case "4": return Suit.Four as number;
        case "5": return Suit.Five as number;
        case "6": return Suit.Six as number;
        case "7": return Suit.Seven as number;
        case "8": return Suit.Eight as number;
        case "9": return Suit.Nine as number;
    }
    return 0;
}

const getStrengthOfHandPart1 = (hand: string): { strength: Strength, breakdown: { [suit: string]: number } } => {
    const handCount = hand.split("").reduce<{ [suit: string]: number }>((acc, card) => {
        if (!acc[card]) {
            acc[card] = 0
        }
        acc[card] += 1;
        return acc;
    }, {});

    const strength = Object.keys(handCount).reduce<Strength>((currentStrength, key) => {
        const count = handCount[key];
        if (count === 2) {
            if (currentStrength === Strength.OnePair) {
                return Strength.TwoPair;
            } else if (currentStrength === Strength.ThreeOfAKind) {
                return Strength.FullHouse;
            }
            return Strength.OnePair;
        } else if (count === 3) {
            if (currentStrength === Strength.OnePair) {
                return Strength.FullHouse;
            }
            return Strength.ThreeOfAKind;
        } else if (count === 4) {
            return Strength.FourOfAKind;
        } else if (count === 5) {
            return Strength.FiveOfAKind;
        }

        return currentStrength;
    }, Strength.HighCard)

    return {
        strength,
        breakdown: handCount,
    }
}

const strongerPart1 = (handA: string, handB: string): number => {
    const strengthA = getStrengthOfHandPart1(handA);
    const strengthB = getStrengthOfHandPart1(handB);

    if (strengthA.strength > strengthB.strength) {
        return 1;
    } else if (strengthA.strength < strengthB.strength) {
        return -1;
    } else {
        // compare individual cards
        for (let i = 0; i < handA.length; i++) {
            const cardA = getStrengthOfCardPart1(handA[i]);
            const cardB = getStrengthOfCardPart1(handB[i]);
            console.log({ handA, cardA, i });
            console.log({ handB, cardB, i });
            if (cardA > cardB) {
                return 1;
            } else if (cardA < cardB) {
                return -1;
            }
        }
        // exit for loop means they are identical
        return 0;
    }
}

const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    const hands = input.map<Hand>((line) => {
        const [hand, bet] = line.split(" ");
        return {
            hand,
            bet: parseInt(bet, 10),
        }
    }).sort((a: Hand, b: Hand) => {
        return strongerPart1(a.hand, b.hand);
    });
    const winnings = hands.reduce((acc, value, index) => {
        console.log(value, index)
        return acc + value.bet * (index + 1);
    }, 0)
    console.log("hands", hands)
    console.log("winnings", winnings)
    console.log("part1")
}


const getStrengthOfCardPart2 = (card: string): number => {
    if (["A", "K", "Q", "T"].includes(card)) {
        // @ts-ignore
        return Suit[card] as number;
    }
    switch (card) {
        case "2": return Suit.Two as number;
        case "3": return Suit.Three as number;
        case "4": return Suit.Four as number;
        case "5": return Suit.Five as number;
        case "6": return Suit.Six as number;
        case "7": return Suit.Seven as number;
        case "8": return Suit.Eight as number;
        case "9": return Suit.Nine as number;
        case "J": return 0;
    }
    return 0;
}

const getStrengthIncludingJokers = (
    handCount: { [suit: string]: number },
    strength: Strength
): Strength => {
    const numberOfJokers = handCount["J"]
    if (numberOfJokers > 0) {
        // console.log("has jokers", { hand, numberOfJokers, handCount, strength });
        if (numberOfJokers === 1) {
            switch (strength) {
                case Strength.HighCard: return Strength.OnePair;
                case Strength.OnePair: return Strength.ThreeOfAKind;
                case Strength.TwoPair: return Strength.FullHouse;
                case Strength.ThreeOfAKind: return Strength.FourOfAKind;
                case Strength.FullHouse: return Strength.FourOfAKind;
                case Strength.FourOfAKind: return Strength.FiveOfAKind;
                // case Strength.FiveOfAKind: return Strength.FiveOfAKind;
            }
        } else if (numberOfJokers === 2) {
            switch (strength) {
                // case Strength.HighCard: return Strength.OnePair;
                case Strength.OnePair: return Strength.ThreeOfAKind;
                // one pair was the JJ
                case Strength.TwoPair: return Strength.FourOfAKind;
                // not possible because it would already be a full house w/ 2 J
                // case Strength.ThreeOfAKind: return Strength.FourOfAKind;
                case Strength.FullHouse: return Strength.FiveOfAKind;
                // not possible
                // case Strength.FourOfAKind: return Strength.FiveOfAKind;
                // no need to map 5 of a kind
                // case Strength.FiveOfAKind: return Strength.FiveOfAKind;
            }
        } else if (numberOfJokers === 3) {
            switch (strength) {
                // case Strength.HighCard: return Strength.OnePair;
                // case Strength.OnePair: return Strength.ThreeOfAKind;
                // case Strength.TwoPair: return Strength.FullHouse;
                case Strength.ThreeOfAKind: return Strength.FourOfAKind;
                case Strength.FullHouse: return Strength.FiveOfAKind;
                // not possible if 3 are J
                // case Strength.FourOfAKind: return Strength.FiveOfAKind;
                // case Strength.FiveOfAKind: return Strength.FiveOfAKind;
            }
        } else if (numberOfJokers === 4) {
            switch (strength) {
                // case Strength.HighCard: return Strength.OnePair;
                // case Strength.OnePair: return Strength.ThreeOfAKind;
                // case Strength.TwoPair: return Strength.FullHouse;
                // case Strength.ThreeOfAKind: return Strength.FourOfAKind;
                // case Strength.FullHouse: return Strength.FourOfAKind;
                case Strength.FourOfAKind: return Strength.FiveOfAKind;
                // case Strength.FiveOfAKind: return Strength.FiveOfAKind;
            }
        }
        // should already be 5 of a kind, so no need to do anything
        //  else if (numberOfJokers === 5) {
        //     switch (strength) {
        //         case Strength.HighCard: return Strength.OnePair;
        //         case Strength.OnePair: return Strength.ThreeOfAKind;
        //         case Strength.TwoPair: return Strength.FullHouse;
        //         case Strength.ThreeOfAKind: return Strength.FourOfAKind;
        //         case Strength.FullHouse: return Strength.FourOfAKind;
        //         case Strength.FourOfAKind: return Strength.FiveOfAKind;
        //         case Strength.FiveOfAKind: return Strength.FiveOfAKind;
        //     }
        // }
    }
    return strength;
}

const getStrengthOfHandPart2 = (hand: string): { strength: Strength, breakdown: { [suit: string]: number } } => {
    const handCount = hand.split("").reduce<{ [suit: string]: number }>((acc, card) => {
        if (!acc[card]) {
            acc[card] = 0
        }
        acc[card] += 1;
        return acc;
    }, {});

    const strength = Object.keys(handCount).reduce<Strength>((currentStrength, key) => {
        const count = handCount[key];
        if (count === 2) {
            if (currentStrength === Strength.OnePair) {
                return Strength.TwoPair;
            } else if (currentStrength === Strength.ThreeOfAKind) {
                return Strength.FullHouse;
            }
            return Strength.OnePair;
        } else if (count === 3) {
            if (currentStrength === Strength.OnePair) {
                return Strength.FullHouse;
            }
            return Strength.ThreeOfAKind;
        } else if (count === 4) {
            return Strength.FourOfAKind;
        } else if (count === 5) {
            return Strength.FiveOfAKind;
        }

        return currentStrength;
    }, Strength.HighCard);

    // check if any jokers would make stronger hand
    const updatedStrength = getStrengthIncludingJokers(handCount, strength);

    console.log(`${hand},${Strength[strength]},${Strength[updatedStrength]},${handCount["J"] ?? 0}`);

    // if (strength !== updatedStrength) {
    //     console.log("updated strength", {hand, handCount, strength: Strength[strength], updatedStrength: Strength[updatedStrength]})
    // }

    return {
        strength: updatedStrength,
        breakdown: handCount,
    }
}

const strongerPart2 = (handA: Hand2, handB: Hand2): number => {
    const strengthA = handA.strength;
    const strengthB = handB.strength;

    if (strengthA.strength > strengthB.strength) {
        return 1;
    } else if (strengthA.strength < strengthB.strength) {
        return -1;
    } else {
        // compare individual cards
        for (let i = 0; i < handA.hand.length; i++) {
            const cardA = getStrengthOfCardPart2(handA.hand[i]);
            const cardB = getStrengthOfCardPart2(handB.hand[i]);
            // console.log({ handA, cardA, i });
            // console.log({ handB, cardB, i });
            if (cardA > cardB) {
                return 1;
            } else if (cardA < cardB) {
                return -1;
            }
        }
        // exit for loop means they are identical
        return 0;
    }
}

const part2 = (fileName: string) => {
    const input = parseInput(fileName);
    const hands = input.map<Hand2>((line) => {
        const [hand, bet] = line.split(" ");
        return {
            hand,
            bet: parseInt(bet, 10),
            strength: getStrengthOfHandPart2(hand),
        }
    }).sort((a: Hand2, b: Hand2) => {
        return strongerPart2(a, b);
    });
    console.log("---winnings---")
    const winnings = hands.reduce((acc, value, index) => {
        console.log(`${value.hand},${Strength[value.strength.strength]},${value.bet},${index}`);
        return acc + value.bet * (index + 1);
    }, 0)
    // console.log("hands", hands)
    console.log("winnings", winnings)
    console.log("part2")
}

// part1('input')
part2('input')
