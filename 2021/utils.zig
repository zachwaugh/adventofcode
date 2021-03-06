const std = @import("std");
const mem = std.mem;
const fs = std.fs;

/// Read a file into an array of strings, each representing a line in the file
pub fn readLines(allocator: *mem.Allocator, path: []const u8) ![][]const u8 {
    const input = try std.fs.cwd().readFileAlloc(allocator, path, 1024 * 1024);
    defer allocator.free(input);

    var list = std.ArrayList([]const u8).init(allocator);

    var iterator = mem.tokenize(u8, input, "\n");
    while (iterator.next()) |value| {
        try list.append(try allocator.dupe(u8, value));
    }

    return list.toOwnedSlice();
}

test "read lines" {
    const allocator = std.testing.allocator;
    const lines = try readLines(allocator, "test/lines.txt");
    defer {
        for (lines) |line| {
            allocator.free(line);
        }
        allocator.free(lines);
    }

    try std.testing.expect(lines.len == 3);
    try std.testing.expect(std.mem.eql(u8, lines[0], "line1") == true);
}

pub fn loadData(comptime T: type, allocator: *std.mem.Allocator, path: []const u8) ![]const T {
    const lines = try readLines(allocator, path);
    defer allocator.free(lines);
    std.debug.assert(lines.len == 1);
    return parseNumberLine(T, allocator, lines[0]);
}

/// Parse a single line of comma-separated numbers into array
pub fn parseNumberLine(comptime T: type, allocator: *std.mem.Allocator, line: []const u8) ![]const T {
    var tokens = mem.split(u8, line, ",");
    var numbers = std.ArrayList(T).init(allocator);
    defer numbers.deinit();

    while (tokens.next()) |token| {
        const number = try std.fmt.parseInt(T, token, 10);
        try numbers.append(number);
    }

    return numbers.toOwnedSlice();
}

/// Sum an array of integers
pub fn sum(comptime T: type, array: []const T) T {
    var result: T = 0;
    for (array) |value| {
        result += value;
    }

    return result;
}

test "sum" {
    const numbers = [_]u32{ 1, 2, 3, 4, 5 };
    const total = sum(u32, &numbers);

    try std.testing.expect(total == 15);
}

pub fn product(comptime T: type, array: []const T) T {
    var result: T = 1;
    for (array) |number| {
        result *= number;
    }

    return result;
}

/// Average of array of numbers
pub fn average(array: []const u32) u32 {
    const total = sum(array);
    return total / @intCast(u32, array.len);
}

pub fn min(comptime T: type, array: []const T) T {
    if (array.len == 0) return 0;

    var minimum: T = array[0];

    for (array) |number| {
        if (number < minimum) {
            minimum = number;
        }
    }

    return minimum;
}

test "min" {
    const array = [_]u32{ 4, 100, 5, 20, 2, 1, 8, 50 };
    try std.testing.expect(min(u32, &array) == 1);
}

pub fn max(comptime T: type, array: []const T) T {
    if (array.len == 0) return 0;

    var maximum: T = array[0];

    for (array) |number| {
        if (number > maximum) {
            maximum = number;
        }
    }

    return maximum;
}

test "max" {
    const array = [_]u32{ 4, 100, 5, 20, 2, 1, 8, 50 };
    try std.testing.expect(max(u32, &array) == 100);
}

pub fn summation(distance: u32) u32 {
    return (distance * (distance + 1)) / 2;
}

test "summation" {
    try std.testing.expect(summation(0) == 0);
    try std.testing.expect(summation(1) == 1);
    try std.testing.expect(summation(2) == 3);
    try std.testing.expect(summation(3) == 6);
    try std.testing.expect(summation(4) == 10);
    try std.testing.expect(summation(5) == 15);
}

pub fn seconds(time: u64) f64 {
    const t = @intToFloat(f64, time);
    const ns = @intToFloat(f64, std.time.ns_per_s);

    return t / ns;
}

pub fn factorial(num: u32) u32 {
    if (num == 1) return 1;
    return num * (factorial(num - 1));
}

test "factorial" {
    try std.testing.expect(factorial(1) == 1);
    try std.testing.expect(factorial(2) == 2);
    try std.testing.expect(factorial(3) == 6);
    try std.testing.expect(factorial(4) == 24);
    try std.testing.expect(factorial(5) == 120);
}

fn swap(x: *u8, y: *u8) void {
    var temp: u8 = x.*;
    x.* = y.*;
    y.* = temp;
}

pub fn permutations(string: []u8, n: u32, results: *std.ArrayList([]u8)) void {
    if (n == 1) {
        const result = results.allocator.dupe(u8, string) catch unreachable;
        results.append(result) catch unreachable;
    } else {
        var i: u32 = 0;

        while (i < n) {
            permutations(string, n - 1, results);

            if (n % 2 == 1) {
                swap(&string[0], &string[n - 1]);
            } else {
                swap(&string[i], &string[n - 1]);
            }

            i += 1;
        }
    }
}

test "permutations" {
    var array = [_]u8{ 'a', 'b', 'c' };
    var results = std.ArrayList([]u8).init(std.heap.page_allocator);
    permutations(&array, array.len, &results);

    try std.testing.expect(results.items.len == factorial(array.len));
}

pub const Location = struct {
    row: u32,
    col: u32,

    pub fn start() Location {
        return Location{ .row = 0, .col = 0 };
    }

    pub fn end(grid: [][]const u8) Location {
        return Location{ .row = grid.len - 1, .col = grid[0].len - 1 };
    }

    pub fn isStart(self: Location) bool {
        return self.row == 0 and self.col == 0;
    }

    pub fn isEnd(self: Location, grid: [][]const u8) bool {
        return self.row == grid.len - 1 and self.col == grid[0].len - 1;
    }

    pub fn left(self: Location) ?Location {
        if (self.col == 0) return null;
        return Location{ .row = self.row, .col = self.col - 1 };
    }

    pub fn right(self: Location, rows: [][]const u8) ?Location {
        if (self.col >= rows[self.row].len - 1) return null;
        return Location{ .row = self.row, .col = self.col + 1 };
    }

    pub fn up(self: Location) ?Location {
        if (self.row == 0) return null;
        return Location{ .row = self.row - 1, .col = self.col };
    }

    pub fn down(self: Location, rows: [][]const u8) ?Location {
        if (self.row >= rows.len - 1) return null;
        return Location{ .row = self.row + 1, .col = self.col };
    }

    pub fn upLeft(self: Location) ?Location {
        if (self.col == 0 or self.row == 0) return null;
        return Location{ .row = self.row - 1, .col = self.col - 1 };
    }

    pub fn upRight(self: Location, rows: [][]const u8) ?Location {
        if (self.col >= rows[self.row].len - 1 or self.row == 0) return null;
        return Location{ .row = self.row - 1, .col = self.col + 1 };
    }

    pub fn downLeft(self: Location, rows: [][]const u8) ?Location {
        if (self.col == 0 or self.row >= rows.len - 1) return null;
        return Location{ .row = self.row + 1, .col = self.col - 1 };
    }

    pub fn downRight(self: Location, rows: [][]u8) ?Location {
        if (self.col >= rows[self.row].len - 1 or self.row >= rows.len - 1) return null;
        return Location{ .row = self.row + 1, .col = self.col + 1 };
    }

    pub fn neighbors(self: Location, grid: [][]const u8, allocator: *std.mem.Allocator) ![]Location {
        var locations = std.ArrayList(Location).init(allocator);

        if (self.down(grid)) |loc| {
            try locations.append(loc);
        }

        if (self.right(grid)) |loc| {
            try locations.append(loc);
        }

        if (self.left()) |loc| {
            try locations.append(loc);
        }

        if (self.up()) |loc| {
            try locations.append(loc);
        }

        return locations.toOwnedSlice();
    }

    pub fn eql(self: Location, other: Location) bool {
        return self.row == other.row and self.end == other.end;
    }
};
