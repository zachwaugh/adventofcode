const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const crabs = try utils.loadData(u32, allocator, "data/day7.txt");
    try puzzle1(crabs);
    try puzzle2(crabs);
}

/// Answers
/// - Test: position: 2, fuel: 37
/// - Input: position: 321, fuel: 343441
fn puzzle1(crabs: []const u32) !void {
    print("[Day 7/Puzzle 1] processing {d} crabs\n", .{ crabs.len });

    const min = utils.min(crabs);
    const max = utils.max(crabs);
    var position = min;
    var min_fuel: ?u32 = undefined;
    var min_position: ?u32 = undefined;

    while (position <= max) {
        const fuel = try fuelUsage(crabs, position);

        if (min_fuel) |minimum| {
            if (fuel < minimum) {
                min_fuel = fuel;
                min_position = position;
            }
        } else {
            min_fuel = fuel;
            min_position = position;
        }

        position += 1;
    }

    print("[Day 7/Puzzle 1] crabs move to position: {d}, fuel: {d}\n", .{ min_position, min_fuel });
}

fn puzzle2(crabs: []const u32) !void {
    print("[Day 7/Puzzle 2] processing {d} crabs\n", .{crabs.len});
}

fn fuelUsage(crabs: []const u32, position: u32) !u32 {
    var fuel: u32 = 0;
    for (crabs) |crab| {
        const distance: u32 = @intCast(u32, try math.absInt(@intCast(i32, crab) - @intCast(i32, position)));
        fuel += distance;
    }
    return fuel;
}
