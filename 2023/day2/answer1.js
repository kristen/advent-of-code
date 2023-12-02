import fs from 'fs';

const parseInput = (fileName) => {
    const inputString = fs.readFileSync(fileName).toString();
    const lines = inputString.split('\n');
    return lines
}

// only 12 red cubes, 13 green cubes, and 14 blue cubes

const cubes = {
    red: 12,
    green: 13,
    blue: 14
};

// slit :, ;, ,
const parseGame = (gameStr) => {
    const [game, record] = gameStr.split(':');
    const id = game.match(/Game (\d+)/)[1];
    const rounds = record.split(';').map((round) => {
        return round.split(',').reduce((acc, cube) => {
            console.log('cube', { cube });
            const [match, count, color] = cube.match(/(\d+) (red|green|blue)/);
            // console.log({ match, count, color });
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

const isValidRound = ({ red, green, blue }) => {
    return red <= cubes.red && green <= cubes.green && blue <= cubes.blue;
}

const isValidGame = ({ rounds }) => {
    return rounds.reduce((acc, round) => {
        return acc && isValidRound(round);
    }, true)
}

const sumGames = (fileName) => {
    const input = parseInput(fileName);
    const result = input.reduce((acc, gameStr) => {
        console.log(gameStr);
        const game = parseGame(gameStr);
        console.log('game', game)
        if (isValidGame(game)) {
            console.log('valid', game.id)
            return acc + game.id;
        }
        console.log('NOT valid', game.id);
        return acc;
    }, 0);
    console.log(result)
}

sumGames('input');