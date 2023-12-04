id, value = 1, 0
f = open("input.txt", "r")
for line in f.readlines():
  isInBounds = True
  current = line.split(":")
  current.pop(0)
  sets = current[0].split(";")
  r, g, b = 0, 0, 0
  for set in sets:
    currentSet = set.split(",")
    for sample in currentSet:
      currentSample = sample.strip()
      if (currentSample.endswith("red")):
        if (int(currentSample.strip(" red")) > r):
          r = int(currentSample.strip(" red"))
      elif (currentSample.endswith("green")):
        if (int(currentSample.strip(" green")) > g):
          g = int(currentSample.strip(" green"))
      elif (currentSample.endswith("blue")):
        if (int(currentSample.strip(" blue")) > b):
          b = int(currentSample.strip(" blue"))
  if (isInBounds):
    value += r * g * b
  id += 1
print(value)
