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
pub fn sum(array: []const u32) u32 {
    var result: u32 = 0;
    for (array) |value| {
        result += value;
    }

    return result;
}

test "sum" {
    const numbers = [_]u32{ 1, 2, 3, 4, 5 };
    const total = sum(&numbers);

    try std.testing.expect(total == 15);
}

/// Average of array of numbers
pub fn average(array: []const u32) u32 {
    const total = sum(array);
    return total / @intCast(u32, array.len);
}

pub fn min(array: []const u32) u32 {
    if (array.len == 0) return 0;

    var minimum: u32 = array[0];

    for (array) |number| {
        if (number < minimum) {
            minimum = number;
        }
    }

    return minimum;
}

test "min" {
    const array = [_]u32{ 4, 100, 5, 20, 2, 1, 8, 50 };
    try std.testing.expect(min(&array) == 1);
}

pub fn max(array: []const u32) u32 {
    if (array.len == 0) return 0;

    var maximum: u32 = array[0];

    for (array) |number| {
        if (number > maximum) {
            maximum = number;
        }
    }

    return maximum;
}

test "max" {
    const array = [_]u32{ 4, 100, 5, 20, 2, 1, 8, 50 };
    try std.testing.expect(max(&array) == 100);
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
