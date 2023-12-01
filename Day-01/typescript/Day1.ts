const fs = require('fs');

const NUMBERS = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];

function main() {
    let content = fs.readFileSync('../../input.txt', 'utf-8');

    console.log(`Ergebnis aus Part (1): ${content.split('\n').map(line => findFirstNumber(line) + findLastNumber(line)).reduce((acc, curr) => acc + curr, 0)}`);

    for (let i = 0; i < NUMBERS.length; i++) {
        const regex = new RegExp(NUMBERS[i], 'g');
        content = content.replace(regex, `${NUMBERS[i]}${i + 1}${NUMBERS[i]}`);
    }

    console.log(`Ergebnis aus Part (2): ${content.split('\n').map(line => findFirstNumber(line) + findLastNumber(line)).reduce((acc, curr) => acc + curr, 0)}`);
}

function findFirstNumber(line) {
    for (let i = 0; i < line.length; i++) {
        const charAsNumber = parseInt(line.charAt(i));
        if (!isNaN(charAsNumber) && charAsNumber >= 1 && charAsNumber <= 9) {
            return charAsNumber * 10;
        }
    }
    return 0;
}

function findLastNumber(line) {
    for (let i = line.length - 1; i >= 0; i--) {
        const charAsNumber = parseInt(line.charAt(i));
        if (!isNaN(charAsNumber) && charAsNumber >= 1 && charAsNumber <= 9) {
            return charAsNumber;
        }
    }
    return 0;
}

main();