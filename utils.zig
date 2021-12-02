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
