import { readFileLines } from '../../../shared/zFlxw/utils';

const lines = readFileLines('input.txt');
const isNearSymbol = (
  symbolsIndices: number[][],
  line: number,
  startIndex: number,
  endIndex: number,
): string | undefined => {
  let found: string | undefined = undefined;

  // CHECK ABOVE
  if (line - 1 >= 0) {
    const aboveCheck = symbolsIndices[line - 1].find((value) => {
      return (
        value === (startIndex - 1 >= 0 ? startIndex - 1 : startIndex) ||
        value === startIndex ||
        value ===
          (startIndex + 1 <= lines.length - 1 ? startIndex + 1 : endIndex) ||
        value === (endIndex - 1 >= 0 ? endIndex - 1 : endIndex) ||
        value === endIndex ||
        value === (endIndex + 1 <= lines.length - 1 ? endIndex + 1 : endIndex)
      );
    });
    if (aboveCheck) {
      found = `${line - 1}-${aboveCheck}`;
    }
  }

  // CHECK NEXT TO
  const nextCheck = symbolsIndices[line].find((value) => {
    return (
      value === (startIndex - 1 >= 0 ? startIndex - 1 : startIndex) ||
      value === (endIndex + 1 <= lines.length - 1 ? endIndex + 1 : endIndex)
    );
  });
  if (nextCheck) {
    found = `${line}-${nextCheck}`;
  }

  // CHECK BELOW

  if (line + 1 <= lines.length - 1) {
    const belowCheck = symbolsIndices[line + 1].find((value) => {
      return (
        value === (startIndex - 1 >= 0 ? startIndex - 1 : startIndex) ||
        value === startIndex ||
        value ===
          (startIndex + 1 <= lines.length - 1 ? startIndex + 1 : endIndex) ||
        value === (endIndex - 1 >= 0 ? endIndex - 1 : endIndex) ||
        value === endIndex ||
        value === (endIndex + 1 <= lines.length - 1 ? endIndex + 1 : endIndex)
      );
    });
    if (belowCheck) {
      found = `${line + 1}-${belowCheck}`;
    }
  }

  return found;
};

export function day03_01() {
  const symbolsIndices: number[][] = [];

  let lineLength = 0;
  let sum = 0;

  // Scanning for location of the symbols
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (lineLength === 0) {
      lineLength = line.length;
    }

    for (let j = 0; j < line.length; j++) {
      const char = line[j];
      if (!symbolsIndices[i]) {
        symbolsIndices[i] = [];
      }

      if (char === '.') {
        continue;
      }

      if (isNaN(+char)) {
        symbolsIndices[i].push(j);
      }
    }
  }

  // Checking the numbers
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const currentNumber = {
      value: 0,
      startIndex: 0,
      endIndex: 0,
    };

    for (let j = 0; j < line.length; j++) {
      const char = line[j];
      if (!isNaN(+char)) {
        if (currentNumber.value === 0) {
          currentNumber.value = +char;
          currentNumber.startIndex = j;
        } else {
          currentNumber.value = currentNumber.value * 10 + +char;
        }

        if (j !== line.length - 1) {
          continue;
        }
      }

      if (currentNumber.value !== 0) {
        currentNumber.endIndex = j - 1;
        if (
          isNearSymbol(
            symbolsIndices,
            i,
            currentNumber.startIndex,
            currentNumber.endIndex,
          )
        ) {
          sum += currentNumber.value;
        }

        currentNumber.value = 0;
      }
    }
  }

  console.log('Total Sum: ' + sum);
}

export function day03_02() {
  const symbolsIndices: number[][] = [];
  const numbers: Record<string, number[]> = {};

  let lineLength = 0;

  // Scanning for location of the symbols
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    if (lineLength === 0) {
      lineLength = line.length;
    }

    for (let j = 0; j < line.length; j++) {
      const char = line[j];
      if (!symbolsIndices[i]) {
        symbolsIndices[i] = [];
      }

      if (char === '.') {
        continue;
      }

      if (char === '*') {
        symbolsIndices[i].push(j);
        numbers[`${i}-${j}`] = [];
      }
    }
  }

  // Checking the numbers
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const currentNumber = {
      value: 0,
      startIndex: 0,
      endIndex: 0,
    };

    for (let j = 0; j < line.length; j++) {
      const char = line[j];
      if (!isNaN(+char)) {
        if (currentNumber.value === 0) {
          currentNumber.value = +char;
          currentNumber.startIndex = j;
        } else {
          currentNumber.value = currentNumber.value * 10 + +char;
        }

        if (j !== line.length - 1) {
          continue;
        }
      }

      if (currentNumber.value !== 0) {
        currentNumber.endIndex = j - 1;
        const nearSymbol = isNearSymbol(
          symbolsIndices,
          i,
          currentNumber.startIndex,
          currentNumber.endIndex,
        );

        if (nearSymbol) {
          numbers[nearSymbol].push(currentNumber.value);
        }
        currentNumber.value = 0;
      }
    }
  }

  let sum = 0;
  for (const value of Object.values(numbers)) {
    if (value.length !== 2) {
      continue;
    }

    let product = 0;
    for (const number of value) {
      product = product > 0 ? product * number : number;
    }

    sum += product;
  }

  console.log('Sum: ' + sum);
}
