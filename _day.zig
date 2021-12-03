const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    //const entries = try loadData("data/dayN.txt");
    try puzzle1();
    try puzzle2();
}

fn puzzle1() !void {
    std.debug.print("[Day N/Puzzle 1] not implemented\n", .{});
}

fn puzzle2() !void {
    std.debug.print("[Day N/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) !void {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    // Convert file data
}
