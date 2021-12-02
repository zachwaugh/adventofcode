// zig run day1.zig
const std = @import("std");
const utils = @import("utils.zig");
const sum = utils.sum;

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const path = "data/day1.txt";
    const data = try utils.loadData(allocator, path);
    try puzzle1(data);
    try puzzle2(data);
}

fn puzzle1(data: []const u32) !void {
    std.debug.print("[Puzzle 1] Processing {any} entries\n", .{data.len});

    var previous: u32 = 0;
    var increases: u32 = 0;
    var decreases: u32 = 0;

    for (data) |value, index| {
        if (index == 0) {
            previous = value;
            continue;
        }

        if (value > previous) {
            increases += 1;
        } else if (value < previous) {
            decreases += 1;
        }

        previous = value;
    }

    std.debug.print("[Puzzle 1] Increases: {d}, decreases: {d}\n", .{ increases, decreases });
}

fn puzzle2(data: []const u32) !void {
    std.debug.print("[Puzzle 2] Processing {any} entries\n", .{data.len});

    var increases: u32 = 0;
    var decreases: u32 = 0;

    for (data) |_, index| {
        if (index + 3 >= data.len) {
            break;
        }

        const window1 = sum(data[index .. index + 3]);
        const window2 = sum(data[index + 1 .. index + 4]);

        if (window2 > window1) {
            increases += 1;
        } else if (window2 < window1) {
            decreases += 1;
        }
    }

    std.debug.print("[Puzzle 2] Increases: {d}, decreases: {d}\n", .{ increases, decreases });
}
