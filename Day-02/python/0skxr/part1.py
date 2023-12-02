id, value, f = 1, 0, open("/input.txt", "r")
for line in f.readlines():
  sets, isInBounds = line.split(":")[1:len(line)][0].split(";"), True
  for set in sets: r, g, b, currentSet = 0, 0, 0, set.split(",")
    for sample in currentSet:
      if (sample.strip().endswith("red")): r += int(sample.strip().strip(" red"))
      elif (sample.strip().endswith("green")): g += int(sample.strip().strip(" green"))
      elif (sample.strip().endswith("blue")): b += int(sample.strip().strip(" blue"))
    if (not (r <= 12 and g <= 13 and b <= 14)): isInBounds = False
  if (isInBounds): value += id 
  id += 1
print(value)
