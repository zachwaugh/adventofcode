const std = @import("std");
const mem = std.mem;
const math = std.math;
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Timer = std.time.Timer;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const instructions = try loadData("data/day13.txt");
    try puzzle1(instructions);
    try puzzle2(instructions);
}

/// Answers
/// - Test: 17
/// - Input: 607
fn puzzle1(instructions: Instructions) !void {
    print("[Day 13/Puzzle 1] processing instructions with {d} points, {d} folds\n", .{ instructions.points.len, instructions.folds.len });
    var points = instructions.points;
    for (instructions.folds) |point| {
        points = try fold(points, point);
        break;
    }

    print("[Day 13/Puzzle 1] points after 1 folds: {d}\n", .{points.len});
}

/// Answers
/// - Test: O
/// - Input: CPZLPFZL
fn puzzle2(instructions: Instructions) !void {
    print("[Day 13/Puzzle 2] processing instructions with {d} points, {d} folds\n", .{ instructions.points.len, instructions.folds.len });
    var points = instructions.points;
    for (instructions.folds) |point| {
        points = try fold(points, point);
    }

    print("[Day 13/Puzzle 2] points after {d} folds: {d}\n", .{ instructions.folds.len, points.len });
    try printPoints(points);
}

fn foldDirection(point: Point) Fold {
    if (point.x == 0 and point.y > 0) {
        return .up;
    } else if (point.y == 0 and point.x > 0) {
        return .left;
    }

    print("Invalid fold! {}\n", .{fold});
    std.os.abort();
}

fn fold(points: []Point, fold_point: Point) ![]Point {
    var folded = ArrayList(Point).init(allocator);
    defer folded.deinit();

    var map = std.AutoHashMap(Point, void).init(allocator);
    defer map.deinit();

    const max_y = findMaxY(points);
    const max_x = findMaxX(points);
    const new_height = max_y - fold_point.y;
    const new_width = max_x - fold_point.x;
    const fold_direction = foldDirection(fold_point);

    for (points) |point| {
        var inserted_point: Point = undefined;

        if (fold_direction == .up and point.y > fold_point.y) {
            const offset = point.y - fold_point.y;
            const new_y = new_height - offset;
            inserted_point = Point{ .x = point.x, .y = new_y };
        } else if (fold_direction == .left and point.x > fold_point.x) {
            const offset = point.x - fold_point.x;
            const new_x = new_width - offset;
            inserted_point = Point{ .x = new_x, .y = point.y };
        } else {
            inserted_point = point;
        }

        if (map.get(inserted_point) == null) {
            try folded.append(inserted_point);
            try map.put(inserted_point, {});
        }
    }

    return folded.toOwnedSlice();
}

fn findMaxY(points: []Point) u32 {
    var max: u32 = 0;

    for (points) |point| {
        if (point.y > max) {
            max = point.y;
        }
    }

    return max;
}

fn findMaxX(points: []Point) u32 {
    var max: u32 = 0;

    for (points) |point| {
        if (point.x > max) {
            max = point.x;
        }
    }

    return max;
}

fn printPoints(points: []Point) !void {
    var map = std.AutoHashMap(Point, void).init(allocator);
    defer map.deinit();

    for (points) |point| {
        try map.put(point, {});
    }

    const max_x = findMaxX(points);
    const max_y = findMaxY(points);

    var x: u32 = 0;
    var y: u32 = 0;

    print("\n", .{});

    while (y <= max_y) : (y += 1) {
        while (x <= max_x) : (x += 1) {
            const point = Point{ .x = x, .y = y };
            if (map.get(point) == null) {
                print(" ", .{});
            } else {
                print("*", .{});
            }
        }

        print("\n", .{});
        x = 0;
    }
}

fn loadData(path: []const u8) !Instructions {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var points = ArrayList(Point).init(allocator);
    var folds = ArrayList(Point).init(allocator);

    for (lines) |line| {
        if (line.len == 0) continue;

        if (line[0] == 'f') {
            var components = mem.split(u8, line, "=");
            const text = components.next().?;
            const num = try fmt.parseInt(u32, components.next().?, 10);

            if (text[text.len - 1] == 'x') {
                try folds.append(Point{ .x = num });
            } else {
                try folds.append(Point{ .y = num });
            }
        } else {
            var components = mem.split(u8, line, ",");
            const x = try fmt.parseInt(u32, components.next().?, 10);
            const y = try fmt.parseInt(u32, components.next().?, 10);
            try points.append(Point{ .x = x, .y = y });
        }
    }

    return Instructions{ .points = points.toOwnedSlice(), .folds = folds.toOwnedSlice() };
}

const Instructions = struct { points: []Point, folds: []Point };

const Point = struct { x: u32 = 0, y: u32 = 0 };

const Fold = enum { up, left };
