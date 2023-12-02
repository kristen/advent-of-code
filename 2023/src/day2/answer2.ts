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

const parseGame = (gameStr: string): Game => {
    const [game, record] = gameStr.split(':');
    const [_, id] = game.match(/Game (\d+)/) ?? [];
    const rounds = record.split(';').map((round) => {
        return round.split(',').reduce((acc, cube) => {
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

const getMinimumCubesForRound = (existingCubes: Cubes, { red, green, blue }: Cubes): Cubes => {
    return {
        red: Math.max(existingCubes.red, red),
        green: Math.max(existingCubes.green, green),
        blue: Math.max(existingCubes.blue, blue),
    }
}

const getMinimumCubes = ({ rounds }: Game): Cubes => {
    return rounds.reduce((acc, round) => {
        return getMinimumCubesForRound(acc, round);
    }, {
        red: 0,
        green: 0,
        blue: 0
    })
}

const getCubePower = ({ red, green, blue }: Cubes): number => {
    return red * green * blue;
}

const sumGames = (fileName: string) => {
    const input = parseInput(fileName);
    const result = input.reduce((acc, gameStr) => {
        const game = parseGame(gameStr);
        const minimumCubes = getMinimumCubes(game);
        const cubePower = getCubePower(minimumCubes);
        return acc + cubePower;
    }, 0);
    console.log({ result })
}

sumGames('input');