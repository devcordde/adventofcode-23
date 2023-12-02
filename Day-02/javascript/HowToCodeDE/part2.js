const data = require("fs").readFileSync("input.txt").toString();
let gamecount = 0;
const games = data.split(/\r?\n|\r|\n/g);
games.forEach(game => {
    let multi = 1;
    const minValues = {
        "red": 0,
        "green": 0,
        "blue": 0,
    };
    let runs = game.split(": ")[1].split("; ");
    runs.forEach(run => {
        let cubes = run.split(", ");
        cubes.forEach(cube => {
            let count = cube.split(" ");
            if ( parseInt(count[0]) > minValues[count[1]]) minValues[count[1]] = parseInt(count[0]);
        });
    });
    for (let key in minValues) {
        multi *= minValues[key];
    }
    gamecount += multi;
});
console.log(gamecount);