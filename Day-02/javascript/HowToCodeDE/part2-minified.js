let gamecount = 0;
require("fs").readFileSync("input.txt").toString().split(/\r?\n|\r|\n/g).forEach(game => {
    let multi = 1;
    const minValues = { "red": 0, "green": 0, "blue": 0 };
    game.split(": ")[1].split("; ").forEach(run => {
        run.split(", ").forEach(cube => {
            if ( parseInt(cube.split(" ")[0]) > minValues[cube.split(" ")[1]]) minValues[cube.split(" ")[1]] = parseInt(cube.split(" ")[0]);
        });
    });
    for (let key in minValues) multi *= minValues[key];
    gamecount += multi;
});
console.log(gamecount);