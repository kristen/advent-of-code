import fs from 'fs';

const parseInput = (fileName) => {
    const inputString = fs.readFileSync(fileName).toString();
    return inputString.split('\n');
}

const parseGame = (gameStr) => {
    const [game, record] = gameStr.split(':');
    const id = game.match(/Game (\d+)/)[1];
    const rounds = record.split(';').map((round) => {
        return round.split(',').reduce((acc, cube) => {
            const [_, count, color] = cube.match(/(\d+) (red|green|blue)/);
            acc[color] = parseInt(count, 10);
            return acc;
        }, {
            red: 0,
            green: 0,
            blue: 0
        });
    });

    return {
        id: parseInt(id, 10),
        rounds
    }
}

const getMinimumCubesForRound = (existingCubes, {red, green, blue}) => {
    return {
        red: Math.max(existingCubes.red, red),
        green: Math.max(existingCubes.green, green),
        blue: Math.max(existingCubes.blue, blue),
    }
}

const getMinimumCubes = ({ rounds }) => {
    return rounds.reduce((acc, round) => {
        return getMinimumCubesForRound(acc, round);
    }, {
        red: 0,
        green: 0,
        blue: 0
    })
}

const getCubePower = ({red, green, blue}) => {
    return red * green * blue;
}

const sumGames = (fileName) => {
    const input = parseInput(fileName);
    const result = input.reduce((acc, gameStr) => {
        const game = parseGame(gameStr);
        const minimumCubes = getMinimumCubes(game);
        const cubePower = getCubePower(minimumCubes);
        return acc + cubePower;
    }, 0);
    console.log({result})
}

sumGames('input');