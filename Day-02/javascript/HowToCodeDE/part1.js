const fs = require("fs");
const data = fs.readFileSync("input.txt").toString();
const limit = {
    "red": 12,
    "green": 13,
    "blue": 14,
};
let gamecount = 0;
const games = data.split(/\r?\n|\r|\n/g);
games.forEach(game => {
    let gameImpossible = 0;
    let gameId = parseInt(game.split(":")[0].replace("Game ", ""));
    let values = game.split(": ")[1];
    let runs = values.split("; ");
    runs.forEach(run => {
        let cubes = run.split(", ");
        cubes.forEach(cube => {
            let count = cube.split(" ");
            if ( parseInt(count[0]) > limit[count[1]]) gameImpossible = 1;
        });
    });
    if (gameImpossible == 0) {
        gamecount += gameId;
    }
});
console.log(gamecount);
