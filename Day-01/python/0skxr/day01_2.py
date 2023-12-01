numbers = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight","nine"]
value = 0
f = open("day1.txt", "r")
for line in f.readlines():
  current = []
  for i in range(len(line)):
    for n in numbers:
      if line[i:i + 5].startswith(n): current.append(str(numbers.index(n)))
    if line[i] in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]: current.append(line[i])
  value += int(current[0] + current[-1])
print(value)