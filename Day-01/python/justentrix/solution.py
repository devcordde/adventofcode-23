with open('input.txt') as file:
  lines = file.readlines()

numbers = []
numberWords = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']

for line in lines:
  numberLiterals = [line[i] for i in range(len(line)) if line[i].isnumeric()]
  numbers.append(int(numberLiterals[0] + numberLiterals[-1]))

print('Part 1:', sum(numbers))
numbers.clear()

for line in lines:
  digits = []

  for i in range(len(line)):
    if line[i].isnumeric():
      digits.append(line[i])
    else:
      for j in range(i, len(line) + 1):
        if line[i:j] in numberWords:
          digits.append(numberWords.index(line[i:j]) + 1)
  numbers.append(int(''.join(map(str, [digits[0], digits[-1]]))))

print('Part 2:', sum(numbers))

