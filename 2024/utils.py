import math


class Point:
    def __init__(self, y, x):
        self.y = y
        self.x = x

    def __str__(self):
        return f"({self.y}, {self.x})"

    def __repr__(self):
        return f"({self.y}, {self.x})"

    def __eq__(self, other):
        if isinstance(other, Point):
            return self.x == other.x and self.y == other.y
        return False

    def __hash__(self):
        return hash((self.x, self.y))

    def copy(self):
        return Point(self.y, self.x)

    def distance(self, p):
        return math.sqrt(math.pow(p.x - self.x, 2) + math.pow(p.y - self.y, 2))
