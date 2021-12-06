const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const lineSegments = try loadData("data/day5.txt");
    try puzzle1(lineSegments);
    try puzzle2(lineSegments);
}

// Answer:
// Test: 5
// Input: 5608
fn puzzle1(lineSegments: []const LineSegment) !void {
    std.debug.print("[Day 5/Puzzle 1] processing {d} line segments\n", .{lineSegments.len});
    var hashMap = std.AutoHashMap(Point, u32).init(allocator);
    defer hashMap.deinit();

    for (lineSegments) |line| {
        if (line.isDiagonal()) continue;

        const points = line.all_points();

        for (points) |point| {
            if (hashMap.get(point)) |count| {
                try hashMap.put(point, count + 1);
            } else {
                try hashMap.put(point, 1);
            }
        }
    }

    var iterator = hashMap.valueIterator();
    var total: u32 = 0;
    while (iterator.next()) |count| {
        if (count.* > 1) {
            total += 1;
        }
    }

    std.debug.print("[Day 5/Puzzle 1] overlap points: {d}\n", .{total});
}

// Answer
// Test: 12
// Input: 20299
fn puzzle2(lineSegments: []LineSegment) !void {
    std.debug.print("[Day 5/Puzzle 2] processing {d} line segments\n", .{lineSegments.len});
    var hashMap = std.AutoHashMap(Point, u32).init(allocator);
    defer hashMap.deinit();

    for (lineSegments) |line| {
        const points = line.all_points();

        for (points) |point| {
            if (hashMap.get(point)) |count| {
                try hashMap.put(point, count + 1);
            } else {
                try hashMap.put(point, 1);
            }
        }
    }

    var iterator = hashMap.valueIterator();
    var total: u32 = 0;
    while (iterator.next()) |count| {
        if (count.* > 1) {
            total += 1;
        }
    }

    std.debug.print("[Day 5/Puzzle 2] overlap points: {d}\n", .{total});
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

    fn isDownwardDiagonal(self: LineSegment) bool {
        return (self.xRange().start == self.start.x and self.start.y > self.end.y) or (self.xRange().start == self.end.x and self.end.y > self.start.y);
    }

    fn all_points(self: LineSegment) []Point {
        if (self.isHorizontal()) {
            return self.horizontalPoints();
        } else if (self.isVertical()) {
            return self.verticalPoints();
        } else {
            return self.diagonalPoints();
        }
    }

    fn horizontalPoints(self: LineSegment) []Point {
        const range = self.xRange();
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
    }

    fn verticalPoints(self: LineSegment) []Point {
        const range = self.yRange();
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

    fn diagonalPoints(self: LineSegment) []Point {
        if (self.isDownwardDiagonal()) {
            return self.diagonalDownwardPoints();
        } else {
            return self.diagonalUpwardPoints();
        }
    }

    fn diagonalUpwardPoints(self: LineSegment) []Point {
        const x_range = self.xRange();
        const y_range = self.yRange();
        var points = std.ArrayList(Point).init(allocator);
        defer points.deinit();

        var x = x_range.start;
        var y = y_range.start;

        while (x <= x_range.end) {
            const point = Point{ .x = x, .y = y };
            points.append(point) catch unreachable;
            y += 1;
            x += 1;
        }

        return points.toOwnedSlice();
    }

    fn diagonalDownwardPoints(self: LineSegment) []Point {
        const x_range = self.xRange();
        var points = std.ArrayList(Point).init(allocator);
        defer points.deinit();

        var x = x_range.start;
        var y = math.max(self.start.y, self.end.y);

        while (x <= x_range.end) {
            const point = Point{ .x = x, .y = y };
            points.append(point) catch unreachable;

            if (y > 0) {
                y -= 1;
            }

            x += 1;
        }

        return points.toOwnedSlice();
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

const Point = struct {
    x: u32,
    y: u32
};

const Range = struct {
    start: u32,
    end: u32
};
