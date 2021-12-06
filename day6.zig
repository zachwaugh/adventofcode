const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const fish = try loadData("data/day6.txt");
    try puzzle1(fish);
    try puzzle2(fish);
}

// Answer
// Test: 5934
// Input: 362666
fn puzzle1(data: []const u8) !void {
    std.debug.print("[Day 6/Puzzle 1] processing {d} fish\n", .{data.len});
    var fish = std.ArrayList(u8).init(allocator);
    defer fish.deinit();

    for (data) |timer| {
        try fish.append(timer);
    }

    const days: u32 = 80;
    var day: u32 = 0;

    while (day < days) {
        for (fish.items) |timer, index| {
            if (timer > 0) {
                fish.items[index] = timer - 1;
            } else {
                fish.items[index] = 6;
                try fish.append(8);
            }
        }

        day += 1;
    }

    std.debug.print("[Day 6/Puzzle 1] {d} fish after {d} days\n", .{ fish.items.len, days });
}

fn puzzle2(fish: []const u8) !void {
    std.debug.print("[Day 6/Puzzle 2] processing {d} fish\n", .{fish.len});
    std.debug.print("[Day 6/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) ![]const u8 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);
    std.debug.assert(lines.len == 1);

    const line = lines[0];
    var tokens = mem.split(u8, line, ",");
    var numbers = std.ArrayList(u8).init(allocator);
    defer numbers.deinit();

    while (tokens.next()) |token| {
        const number = try std.fmt.parseInt(u8, token, 10);
        try numbers.append(number);
    }

    return numbers.toOwnedSlice();
}
