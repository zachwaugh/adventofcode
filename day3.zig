const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const entries = try loadData(allocator, "data/day3.txt");
    try puzzle1(entries);
    try puzzle2();
}

fn puzzle1(entries: []const u32) !void {
    const bits: u8 = 12;
    var gamma: u32 = 0;
    var bit: u5 = 0;

    while (bit < bits) {
        gamma |= most_common_bit(entries, bit) << bit;
        bit += 1;
    }

    const epsilon: u32 = gamma ^ (math.pow(u32, 2, bits) - 1);
    const power_consumption = epsilon * gamma;
    std.debug.print("[Day 3, Puzzle 1] gamma: {}, epsilon: {}, power consumption: {}\n", .{ gamma, epsilon, power_consumption });
}

fn puzzle2() !void {}

fn most_common_bit(numbers: []const u32, place: u5) u32 {
    var result: u32 = 0;
    const bit_shift: u32 = 1;
    const bit_mask: u32 = bit_shift << place;

    for (numbers) |number| {
        result += (number & bit_mask) >> place;
    }

    if (result >= numbers.len / 2) {
        return 1;
    } else {
        return 0;
    }
}

fn loadData(allocator: *mem.Allocator, path: []const u8) ![]const u32 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var entries = std.ArrayList(u32).init(allocator);
    defer entries.deinit();

    for (lines) |line| {
        const value = try std.fmt.parseInt(u32, line, 2);
        try entries.append(value);
    }

    return entries.toOwnedSlice();
}
