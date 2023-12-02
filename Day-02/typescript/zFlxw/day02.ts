import { readFileLines } from '../../../shared/zFlxw/utils';

export function day02_01() {
  const lines = readFileLines('input.txt');

  let validGamesSum = 0;
  for (const line of lines) {
    const limit = {
      red: 12,
      green: 13,
      blue: 14,
    };

    let possible = true;
    const gameId = line.split(' ')[1].slice(0, line.split(' ')[1].length - 1);
    const tries = line.split(': ')[1];
    tries.split('; ').forEach((run) => {
      run
        .split(', ')
        .map((val) => val.split(' '))
        .filter(([num, _]) => !isNaN(+num))
        .forEach(([num, cube]) => {
          if (limit[cube as keyof typeof limit] < +num) {
            possible = false;
          }
        });
    });

    if (possible) {
      validGamesSum += +gameId;
    }
  }

  console.log('Valid Games (sum): ' + validGamesSum);
}

export function day02_02() {
  const lines = readFileLines('input.txt');

  let totalPower = 0;
  for (const line of lines) {
    const tries = line.split(': ')[1];

    const minValues = {
      blue: 0,
      red: 0,
      green: 0,
    };

    tries.split('; ').forEach((run) => {
      run
        .split(', ')
        .map((val) => val.split(' '))
        .filter(([num, _]) => !isNaN(+num))
        .forEach(([num, cube]) => {
          if (minValues[cube as keyof typeof minValues] < +num) {
            minValues[cube as keyof typeof minValues] = +num;
          }
        });
    });

    let setPower = 0;
    Object.values(minValues).forEach((value) =>
      setPower === 0 ? (setPower = value) : (setPower *= value),
    );
    totalPower += setPower;
  }

  console.log('Total Power: ' + totalPower);
}
