import fs from 'fs';

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/day2/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

type Cubes = {
    red: number;
    green: number;
    blue: number;
}

type Color = keyof Cubes;

type Game = {
    id: number;
    rounds: Cubes[];
}

const cubes: Cubes = {
    red: 12,
    green: 13,
    blue: 14
};

// slit :, ;, ,
const parseGame = (gameStr: string): Game => {
    const [game, record] = gameStr.split(':');
    const [_, id] = game.match(/Game (\d+)/) ?? [];
    const rounds = record.split(';').map((round) => {
        return round.split(',').reduce((acc, cube) => {
            console.log('cube', { cube });
            const [_, count, color] = cube.match(/(\d+) (red|green|blue)/) ?? [];
            if (color) {
                acc[color as Color] = parseInt(count, 10);
            }
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

const isValidRound = ({ red, green, blue }: Cubes) => {
    return red <= cubes.red && green <= cubes.green && blue <= cubes.blue;
}

const isValidGame = ({ rounds }: Game) => {
    return rounds.reduce((acc, round) => {
        return acc && isValidRound(round);
    }, true)
}

const sumGames = (fileName: string) => {
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