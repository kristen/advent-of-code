import fs from 'fs';

const parseInput = (fileName: string): string[] => {
    const path = `${__dirname.replace("build", "src")}/day5/${fileName}`;
    const inputString = fs.readFileSync(path).toString();
    return inputString.split('\n');
}

export const parseInts = (str: string): number[] => {
    return str.match(/(\d+)/g)?.map((d) => parseInt(d, 10)) ?? [];
}

export const pairs = <T>(array: T[]): T[][] => {
    return array.reduce<T[][]>((result, _value, index, a) => {
        if (index % 2 === 0) {
            const pair = a.slice(index, index + 2);
            result.push(pair);
        }
        return result;
    }, []);
}

type Range = {
    destinationStart: number;
    sourceStart: number;
    rangeLength: number;
}

type SeedRange = {
    start: number;
    length: number;
}

type Farming = {
    seeds: number[]
    seedRange: SeedRange[]
    seedToSoil: Range[];
    soilToFertilizer: Range[];
    fertilizerToWater: Range[];
    waterToLight: Range[];
    lightToTemperature: Range[];
    temperatureToHumidity: Range[];
    humidityToLocation: Range[];
}

const parseFile = (lines: string[]) => {
    let currentMap: keyof Farming = "seeds";
    return lines.reduce((acc, line): Farming => {
        if (line.match(/seeds:/)) {
            const seeds = parseSeeds(line);
            const seedRange = parseSeedRange(line);
            acc.seeds = seeds;
            acc.seedRange = seedRange;
        } else if (line.match(/seed\-to\-soil map:/)) {
            currentMap = "seedToSoil";
        } else if (line.match(/soil\-to\-fertilizer map:/)) {
            currentMap = "soilToFertilizer";
        } else if (line.match(/fertilizer\-to\-water map:/)) {
            currentMap = "fertilizerToWater";
        } else if (line.match(/water\-to\-light map:/)) {
            currentMap = "waterToLight";
        } else if (line.match(/light\-to\-temperature map:/)) {
            currentMap = "lightToTemperature";
        } else if (line.match(/temperature\-to\-humidity map:/)) {
            currentMap = "temperatureToHumidity";
        } else if (line.match(/humidity\-to\-location map:/)) {
            currentMap = "humidityToLocation";
        } else if (line === "") {
            // skip empty lines
            return acc;
        }
        else {
            switch (currentMap) {
                case 'seedToSoil': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
                case 'soilToFertilizer': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
                case 'fertilizerToWater': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
                case 'waterToLight': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
                case 'lightToTemperature': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
                case 'temperatureToHumidity': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
                case 'humidityToLocation': {
                    acc[currentMap].push(parseRange(line));
                    break;
                }
            }
        }

        return acc;
    }, {
        seeds: [],
        seedRange: [],
        seedToSoil: [],
        soilToFertilizer: [],
        fertilizerToWater: [],
        waterToLight: [],
        lightToTemperature: [],
        temperatureToHumidity: [],
        humidityToLocation: [],
    } as Farming);
}

const parseSeeds = (str: string): number[] => {
    return parseInts(str);
}

const parseSeedRange = (str: string): SeedRange[] => {
    const nums = parseInts(str);
    return pairs(nums).map(([start, length]) => ({ start, length }))
}

const isSeedInRange = (seed: number, seedRanges: SeedRange[]): boolean => {
    return seedRanges.reduce<boolean>((acc, { start, length }) => {
        if (seed >= start && seed < start + length) {
            return true;
        }
        return acc;
    }, false);
}

const parseRange = (line: string): Range => {
    const nums = parseInts(line);
    return {
        destinationStart: nums[0],
        sourceStart: nums[1],
        rangeLength: nums[2],
    }
}

const sourceToDestination = (source: number, ranges: Range[]): number => {
    const match = ranges.find(({ sourceStart, rangeLength }) => {
        if (source >= sourceStart && source < sourceStart + rangeLength) {
            return true;
        } else {
            return false;
        }
    })
    if (match) {
        const diff = source - match.sourceStart;
        return match.destinationStart + diff;
    } else {
        return source;
    }
}

const destinationToSource = (destination: number, ranges: Range[]): number => {
    const match = ranges.find(({ destinationStart, rangeLength }) => {
        if (destination >= destinationStart && destination < destinationStart + rangeLength) {
            return true;
        } else {
            return false;
        }
    })
    if (match) {
        const diff = destination - match.destinationStart;
        return match.sourceStart + diff;
    } else {
        return destination;
    }
}

const seedToLocation = (seed: number, farming: Farming): {
    seed: number;
    soil: number;
    fertilizer: number;
    water: number;
    light: number;
    temperature: number;
    humidity: number;
    location: number
} => {
    const soil = sourceToDestination(seed, farming.seedToSoil);
    const fertilizer = sourceToDestination(soil, farming.soilToFertilizer);
    const water = sourceToDestination(fertilizer, farming.fertilizerToWater);
    const light = sourceToDestination(water, farming.waterToLight);
    const temperature = sourceToDestination(light, farming.lightToTemperature);
    const humidity = sourceToDestination(temperature, farming.temperatureToHumidity);
    const location = sourceToDestination(humidity, farming.humidityToLocation);
    return {
        seed,
        soil,
        fertilizer,
        water,
        light,
        temperature,
        humidity,
        location,
    };
}


const locationToSeed = (location: number, farming: Farming): {
    seed: number;
    soil: number;
    fertilizer: number;
    water: number;
    light: number;
    temperature: number;
    humidity: number;
    location: number
} => {
    const humidity = destinationToSource(location, farming.humidityToLocation);
    const temperature = destinationToSource(humidity, farming.temperatureToHumidity);
    const light = destinationToSource(temperature, farming.lightToTemperature);
    const water = destinationToSource(light, farming.waterToLight);
    const fertilizer = destinationToSource(water, farming.fertilizerToWater);
    const soil = destinationToSource(fertilizer, farming.soilToFertilizer);
    const seed = destinationToSource(soil, farming.seedToSoil);
    return {
        seed,
        soil,
        fertilizer,
        water,
        light,
        temperature,
        humidity,
        location,
    };
}

const part1 = (fileName: string) => {
    const input = parseInput(fileName);
    const farming = parseFile(input);
    const locations = farming.seeds.map((seed) => {
        return seedToLocation(seed, farming).location;
    })
    console.log("locations", locations)
    console.log("result", Math.min(...locations));
}

const part2 = (fileName: string) => {
    const input = parseInput(fileName);
    const farming = parseFile(input);
    console.log(farming);

    let done = false;
    let location = 50000000;

    while (!done) {
        const seed = locationToSeed(location, farming).seed;
        if (isSeedInRange(seed, farming.seedRange)) {
            done = true;
        } else {
            console.log({ seed, location })
            location += 1;
        }
    }

    console.log("location", location)
}

// part1('input')
part2('input')
