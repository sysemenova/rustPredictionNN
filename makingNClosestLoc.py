def distance(loc1, loc2):
    xPart = (loc1[0] - loc2[0]) ** 2
    yPart = (loc1[1] - loc2[1]) ** 2
    total = (xPart + yPart) ** 0.5
    return total


with open('longlat.txt', 'r') as doc:
    longLat = {}
    for line in doc:
        ke, value = line.split(",", 1)
        longLat[ke] = value.split(",")

numLoc = 93 # 0 -> 93 inclusive both sides
n = 2


for i in range(0, numLoc + 1):
    longLat[str(i)][0] = float(longLat[str(i)][0])
    longLat[str(i)][1] = float(longLat[str(i)][1])

dw = open("nClosest.txt", "w")

for curLoc in range(0, numLoc + 1):
    if (curLoc != 13):
        distances = []
        numbers = []
        for testLoc in range(0, numLoc + 1):
            if testLoc != curLoc and testLoc != 13:
                dist = distance(longLat[str(curLoc)], longLat[str(testLoc)])
                if len(distances) < n:
                    distances.append(dist)
                    if testLoc < 13:
                        numbers.append(testLoc + 1)
                    else:
                        numbers.append(testLoc)
                else:
                    for d in distances:
                        if dist < d:
                            index = distances.index(d)
                            distances.insert(index, dist)
                            if testLoc < 13:
                                numbers.insert(index, testLoc + 1)
                            else:
                                numbers.insert(index, testLoc)
                            distances.pop()
                            numbers.pop()
                            break
        if curLoc < 13:
            data = str(curLoc + 1) + ", " + str(numbers)[1:-1] + "\n"
        else:
            data = str(curLoc) + ", " + str(numbers)[1:-1] + "\n"
        dw.write(data)
dw.close()
