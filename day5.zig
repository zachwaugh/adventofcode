const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const lineSegments = try loadData("data/test.txt");
    try puzzle1(lineSegments);
    try puzzle2();
}

fn puzzle1(lineSegments: []const LineSegment) !void {
    std.debug.print("[Day 5/Puzzle 1] processing {d} line segments\n", .{lineSegments.len});
    var hashMap = std.AutoHashMap(Point, u32).init(allocator);
    defer hashMap.deinit();

    // For each line segment
    for (lineSegments) |line, index| {
        if (line.isDiagonal()) continue;

        for (lineSegments) |other, other_index| {
            if (index == other_index or other.isDiagonal()) continue;

            if (line.overlappingPoints(other)) |points| {
                for (points) |point| {
                    if (hashMap.get(point) == null) {
                        try hashMap.put(point, 1);
                    }
                }
            }
        }
    }

    std.debug.print("[Day 5/Puzzle 1] overlap points: {d}\n", .{hashMap.count()});
}

fn puzzle2() !void {
    std.debug.print("[Day 5/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) ![]LineSegment {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var lineSegments = std.ArrayList(LineSegment).init(allocator);
    defer lineSegments.deinit();

    for (lines) |line| {
        const segment = try parseLineSegment(line);
        try lineSegments.append(segment);
    }

    return lineSegments.toOwnedSlice();
}

fn parseLineSegment(line: []const u8) !LineSegment {
    var iterator = mem.split(u8, line, " -> ");
    var start: ?Point = null;
    var end: ?Point = null;

    while (iterator.next()) |part| {
        if (start == null) {
            start = try parsePoint(part);
        } else if (end == null) {
            end = try parsePoint(part);
        } else {
            break;
        }
    }

    return LineSegment{ .start = start.?, .end = end.? };
}

fn parsePoint(string: []const u8) !Point {
    var iterator = mem.tokenize(u8, string, ",");
    var x: ?u32 = null;
    var y: ?u32 = null;

    while (iterator.next()) |part| {
        if (x == null) {
            x = try std.fmt.parseInt(u32, part, 10);
        } else if (y == null) {
            y = try std.fmt.parseInt(u32, part, 10);
        } else {
            break;
        }
    }

    return Point{ .x = x.?, .y = y.? };
}

const LineSegment = struct {
    start: Point,
    end: Point,

    fn xRange(self: LineSegment) Range {
        if (self.start.x < self.end.x) {
            return Range{ .start = self.start.x, .end = self.end.x };
        } else {
            return Range{ .start = self.end.x, .end = self.start.x };
        }
    }

    fn yRange(self: LineSegment) Range {
        if (self.start.y < self.end.y) {
            return Range{ .start = self.start.y, .end = self.end.y };
        } else {
            return Range{ .start = self.end.y, .end = self.start.y };
        }
    }

    fn isVertical(self: LineSegment) bool {
        return self.start.x == self.end.x;
    }

    fn isHorizontal(self: LineSegment) bool {
        return self.start.y == self.end.y;
    }

    fn isDiagonal(self: LineSegment) bool {
        return !self.isVertical() and !self.isHorizontal();
    }

    fn isColinear(self: LineSegment, other: LineSegment) bool {
        return (self.isVertical() and other.isVertical()) or (self.isHorizontal() and other.isHorizontal());
    }

    fn isParallel(self: LineSegment, other: LineSegment) bool {
        if (self.isHorizontal() and other.isHorizontal() and self.start.y != other.start.y) {
            return true;
        }

        if (self.isVertical() and other.isVertical() and self.start.x != other.start.x) {
            return true;
        }

        return false;
    }

    fn intersects(self: LineSegment, other: LineSegment) bool {
        if (self.isParallel(other) or self.isColinear(other)) {
            return false;
        }

        // Perpendicular, check for overlap
        if (self.isVertical()) {
            return self.intersectsVertical(other);
        } else {
            return other.intersectsVertical(self);
        }

        return false;
    }

    // When this line is vertical and other line is horizontal
    fn intersectsVertical(self: LineSegment, other: LineSegment) bool {
        std.debug.assert(self.isVertical());
        std.debug.assert(other.isHorizontal());

        const intersects_y_axis = self.yRange().contains(other.start.y);
        const intersects_x_axis = other.xRange().contains(self.start.x);
        return intersects_y_axis and intersects_x_axis;
    }

    fn intersectionPoint(self: LineSegment, other: LineSegment) Point {
        if (self.isVertical()) {
            return Point{ .x = self.start.x, .y = other.start.y };
        } else {
            return Point{ .x = other.start.x, .y = self.start.y };
        }
    }

    fn isOverlapping(self: LineSegment, other: LineSegment) bool {
        if (!self.isColinear(other)) {
            return false;
        }

        if (self.isHorizontal() and other.isHorizontal()) {
            return self.xRange().overlaps(other.xRange()) or other.xRange().overlaps(self.xRange());
        }

        if (self.isVertical() and other.isVertical()) {
            return self.yRange().overlaps(other.yRange()) or other.yRange().overlaps(self.yRange());
        }

        return false;
    }

    fn overlappingPoints(self: LineSegment, other: LineSegment) ?[]Point {
        if (self.isParallel(other)) {
            return null;
        }

        if (self.isOverlapping(other)) {
            return self.overlappingColinearPoints(other);
        } else if (self.intersects(other)) {
            return &[1]Point{self.intersectionPoint(other)};
        } else {
            return null;
        }
    }

    fn overlappingColinearPoints(self: LineSegment, other: LineSegment) []Point {
        std.debug.assert(self.isColinear(other));

        if (self.isHorizontal()) {
            const range = self.xRange().overlapRange(other.xRange());
            const y = self.start.y;
            var points = std.ArrayList(Point).init(allocator);
            defer points.deinit();

            var x = range.start;
            while (x <= range.end) {
                const point = Point{ .x = x, .y = y };
                points.append(point) catch unreachable;
                x += 1;
            }

            return points.toOwnedSlice();
        } else {
            const range = self.yRange().overlapRange(other.yRange());
            const x = self.start.x;
            var points = std.ArrayList(Point).init(allocator);
            defer points.deinit();

            var y = range.start;
            while (y <= range.end) {
                const point = Point{ .x = x, .y = y };
                points.append(point) catch unreachable;
                y += 1;
            }

            return points.toOwnedSlice();
        }
    }
};

test "LineSegment: vertical/horizontal" {
    const point1 = Point{ .x = 0, .y = 0 };
    const point2 = Point{ .x = 0, .y = 4 };
    const point3 = Point{ .x = 10, .y = 4 };

    const line1 = LineSegment{ .start = point1, .end = point2 };
    const line2 = LineSegment{ .start = point2, .end = point3 };
    const line3 = LineSegment{ .start = point1, .end = point3 };

    try std.testing.expect(line1.isVertical() == true);
    try std.testing.expect(line1.isHorizontal() == false);
    try std.testing.expect(line2.isVertical() == false);
    try std.testing.expect(line2.isHorizontal() == true);
    try std.testing.expect(line3.isVertical() == false);
    try std.testing.expect(line3.isHorizontal() == false);
}

test "LineSegment: intersects" {
    const point1 = Point{ .x = 0, .y = 0 };
    const point2 = Point{ .x = 0, .y = 4 };
    const point3 = Point{ .x = 10, .y = 4 };

    // Vertical
    const line1 = LineSegment{ .start = point1, .end = point2 };

    // Horizontal
    const line2 = LineSegment{ .start = point2, .end = point3 };

    try std.testing.expect(line1.intersects(line2));
}

test "LineSegment: isParallel" {
    const line1 = LineSegment{ .start = Point{ .x = 0, .y = 0 }, .end = Point{ .x = 10, .y = 0 } };
    const line2 = LineSegment{ .start = Point{ .x = 2, .y = 4 }, .end = Point{ .x = 6, .y = 4 } };
    try std.testing.expect(line1.isParallel(line2));
    try std.testing.expect(line2.isParallel(line1));

    const line3 = LineSegment{ .start = Point{ .x = 0, .y = 9 }, .end = Point{ .x = 5, .y = 9 } };
    const line4 = LineSegment{ .start = Point{ .x = 3, .y = 4 }, .end = Point{ .x = 1, .y = 4 } };
    try std.testing.expect(line3.isParallel(line4));
    try std.testing.expect(line4.isParallel(line3));
}

const Point = struct {
    x: u32,
    y: u32,

    fn isEqual(self: Point, other: Point) bool {
        return self.x == other.x and self.y == other.y;
    }
};

const Range = struct {
    start: u32,
    end: u32,

    fn len(self: Range) u32 {
        if (self.start == self.end) {
            return 0;
        }

        return self.end - self.start + 1;
    }

    fn contains(self: Range, value: u32) bool {
        return value >= self.start and value <= self.end;
    }

    fn overlaps(self: Range, range: Range) bool {
        return (self.start >= range.start and self.end <= range.end) or self.contains(range.start) or self.contains(range.end);
    }

    fn overlap(self: Range, other: Range) u32 {
        return self.overlapRange(other).len();
    }

    fn overlapRange(self: Range, other: Range) Range {
        if (!self.overlaps(other)) {
            return Range{ .start = 0, .end = 0 };
        }

        if (self.start < other.start) {
            return Range{ .start = other.start, .end = math.min(self.end, other.end) };
        } else if (other.start < self.start) {
            return Range{ .start = self.start, .end = math.min(self.end, other.end) };
        } else {
            return Range{ .start = self.start, .end = math.min(self.end, other.end) };
        }
    }
};

test "Range: overlaps" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 2, .end = 7 };

    try std.testing.expect(range1.overlaps(range2));
    try std.testing.expect(range2.overlaps(range1));
}

test "Range: overlaps none" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 6, .end = 7 };

    try std.testing.expect(!range1.overlaps(range2));
    try std.testing.expect(!range2.overlaps(range1));
}

test "Range: overlap" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 2, .end = 7 };

    try std.testing.expect(range1.overlap(range2) == 4);
    try std.testing.expect(range2.overlap(range1) == 4);
}

test "Range: overlap partial" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 0, .end = 2 };

    try std.testing.expect(range1.overlap(range2) == 3);
    try std.testing.expect(range2.overlap(range1) == 3);
}

test "Range: overlap full" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 0, .end = 5 };

    try std.testing.expect(range1.overlap(range2) == 6);
    try std.testing.expect(range2.overlap(range1) == 6);
}

test "Range: overlap inside" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 2, .end = 4 };

    //std.debug.print("overlap range: {}, {}\n\n", .{range1.overlap(range2), range2.overlap(range1)});

    try std.testing.expect(range1.overlap(range2) == 3);
    try std.testing.expect(range2.overlap(range1) == 3);
}

test "Range: overlap none" {
    const range1 = Range{ .start = 0, .end = 5 };
    const range2 = Range{ .start = 12, .end = 20 };

    try std.testing.expect(range1.overlap(range2) == 0);
    try std.testing.expect(range2.overlap(range1) == 0);
}
