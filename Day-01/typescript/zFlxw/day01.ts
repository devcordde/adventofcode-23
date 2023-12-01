// Made using the Deno.land runtime. The utils.ts file can be found in /shared/zFlxw.

import { readFileLines } from '../../../shared/zFlxw/utils.ts';

export function day01_01() {
  const lines = readFileLines('day01/input.txt');
  let totalSum = 0;
  for (const line of lines) {
    const digits: number[] = line.split('').filter(char => !isNaN(+char)).map(digit => +digit);
    totalSum += (digits[0] * 10) + digits[digits.length - 1];
  }

  console.log('Total sum of all digits: ' + totalSum);
}

export function day01_02() {
  const digits = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9
  }

  const lines = readFileLines('input.txt');

  let totalSum = 0;
  for (const line of lines) {
    const numbers: number[] = []; 

    for (let i = 0; i < line.length; i++) {
      const char = line.split('')[i];
      if (!isNaN(+char)) {
        numbers.push(+char)
        continue;
      }

      for (const key of Object.keys(digits)) {
        if (line.slice(i).startsWith(key)) {
          numbers.push(+digits[key as keyof typeof digits]);
        }
      }
    }
    
    totalSum += numbers[0] * 10 + numbers[numbers.length - 1];
  }

  console.log("Total Sum: " + totalSum);
}
