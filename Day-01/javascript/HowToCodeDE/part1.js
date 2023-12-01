const fs = require("fs");
const data = fs.readFileSync("input.txt").toString();
const wordToDigit = { one: '1', two: '2', three: '3', four: '4', five: '5', six: '6', seven: '7', eight: '8', nine: '9' };
const values = data.split(/\r?\n|\r|\n/g);
let addedNums = 0;
const exp = /(one|two|three|four|five|six|seven|eight|nine)/g;
values.forEach(value => {
    value = value.replace(/[a-z]+/g, '');
    addedNums += parseInt(value[0] + value[value.length - 1]);
});
console.log(addedNums);
