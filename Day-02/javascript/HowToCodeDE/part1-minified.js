const limit = { "red": 12, "green": 13, "blue": 14 };
let gamecount = 0;
require("fs").readFileSync("input.txt").toString().split(/\r?\n|\r|\n/g).forEach(game => {
    let gameImpossible = 0;
    game.split(": ")[1].split("; ").forEach(run => {
        run.split(", ").forEach(cube => {
            if (parseInt(cube.split(" ")[0]) > limit[cube.split(" ")[1]]) gameImpossible = 1;
        });
    });
    if (gameImpossible == 0) gamecount += parseInt(game.split(":")[0].replace("Game ", ""));
});
console.log(gamecount);