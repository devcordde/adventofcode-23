import { readFileLines, replaceWhitespaces } from '../../../shared/zFlxw/utils';

export function day06_01() {
  const values: string[][] = readFileLines('input.txt')
    .map((line) => replaceWhitespaces(line, ' '))
    .map((line) => line.split(': ')[1])
    .map((line) => line.split(' '));

  let totalProduct = 0;
  for (let race = 0; race < values[0].length; race++) {
    const time = +values[0][race];
    const distance = +values[1][race];

    let wins = 0;
    for (let i = 0; i < time; i++) {
      const dist = (time - i) * i;
      if (dist > distance) {
        wins++;
      }
    }

    totalProduct = totalProduct === 0 ? wins : totalProduct * wins;
  }

  console.log('Product: ' + totalProduct);
}

export function day06_02() {
  const values: string[] = readFileLines('input.txt')
    .map((line) => replaceWhitespaces(line, ' '))
    .map((line) => line.split(': ')[1])
    .map((line) => replaceWhitespaces(line, ''));

  let totalProduct = 0;
  const time = +values[0];
  const distance = +values[1];

  let wins = 0;
  for (let i = 0; i < time; i++) {
    const dist = (time - i) * i;
    if (dist > distance) {
      wins++;
    }
  }

  totalProduct = totalProduct === 0 ? wins : totalProduct * wins;
  console.log('Product: ' + totalProduct);
}
