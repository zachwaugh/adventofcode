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
    //const entries = try loadData("data/dayN.txt");
    try puzzle1();
    try puzzle2();
}

fn puzzle1() !void {
    var timer = try Timer.start();
    print("[Day N/Puzzle 1] not implemented in {d}\n", .{utils.seconds(timer.read())});
}

fn puzzle2() !void {
    var timer = try Timer.start();
    print("[Day N/Puzzle 2] not implemented in {d}\n", .{utils.seconds(timer.read())});
}

fn loadData(path: []const u8) !void {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    // Convert file data
}
