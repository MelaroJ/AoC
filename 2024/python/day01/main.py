l, r = [], []  # noqa: E741

with open("input") as f:
    for line in f:
        x, y = map(int, line.strip().split())
        l.append(x)
        r.append(y)

l.sort()
r.sort()

# part1
total = 0
for a, b in zip(l, r):
    diff = abs(a - b)
    total += diff
print(total)

# part2
print(sum(x * r.count(x) for x in l))
