f = open("day1.txt", "r")
value = 0
for line in f.readlines():
  numbers = []
  for c in line:
    if (c in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]): numbers.append(c)
  value += int(numbers[0] + numbers[-1])
print(value)