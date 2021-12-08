const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const entries = try loadData("data/day8.txt");
    try puzzle1(entries);
    try puzzle2();
}

/// Answers
/// - Test: 26
/// - Input: 321
fn puzzle1(entries: []Entry) !void {
    print("[Day 8/Puzzle 1] processing {d} entries\n", .{entries.len});

    var simple_digits: u32 = 0;

    for (entries) |entry| {
        for (entry.digits) |digit| {
            if (digit.len == 2 or digit.len == 4 or digit.len == 3 or digit.len == 7) {
                simple_digits += 1;
            }
        }
    }

    print("[Day 8/Puzzle 2] simple digits appeared {d} times\n", .{simple_digits});
}

fn puzzle2() !void {
    print("[Day 8/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) ![]Entry {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var entries = std.ArrayList(Entry).init(allocator);
    defer entries.deinit();

    for (lines) |line| {
        const entry = try parseLine(line);
        try entries.append(entry);
    }

    return entries.toOwnedSlice();
}

fn parseLine(line: []const u8) !Entry {
    var iterator = mem.split(u8, line, "|");

    const signals = try parseGroups(iterator.next().?);
    const digits = try parseGroups(iterator.next().?);

    return Entry{ .signals = signals, .digits = digits };
}

fn parseGroups(line: []const u8) ![][]const u8 {
    var iterator = mem.tokenize(u8, line, " ");
    var strings = std.ArrayList([]const u8).init(allocator);
    defer strings.deinit();

    while (iterator.next()) |string| {
        try strings.append(string);
    }

    return strings.toOwnedSlice();
}

const Entry = struct { signals: [][]const u8, digits: [][]const u8 };
