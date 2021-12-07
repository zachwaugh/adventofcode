const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

const FuelUsage = struct { position: u32, fuel: u32 };

pub fn main() !void {
    const crabs = try utils.loadData(u32, allocator, "data/day7.txt");
    try puzzle1(crabs);
    try puzzle2(crabs);
}

/// Answers
/// - Test: position: 2, fuel: 37
/// - Input: position: 321, fuel: 343441
fn puzzle1(crabs: []const u32) !void {
    print("[Day 7/Puzzle 1] processing {d} crabs\n", .{crabs.len});
    const fuel_usage = minimumFuelUsage(crabs, true);
    print("[Day 7/Puzzle 1] crabs fuel usage: {}\n", .{fuel_usage});
}

/// Answers
/// - Test: position: 5, fuel: 168
/// - Input: position: 473, fuel: 98925151
fn puzzle2(crabs: []const u32) !void {
    print("[Day 7/Puzzle 2] processing {d} crabs\n", .{crabs.len});
    const fuel_usage = minimumFuelUsage(crabs, false);
    print("[Day 7/Puzzle 2] crabs fuel usage: {}\n", .{fuel_usage});
}

fn minimumFuelUsage(crabs: []const u32, constant_rate: bool) !FuelUsage {
    const min = utils.min(crabs);
    const max = utils.max(crabs);
    var position = min;
    var min_fuel: ?u32 = undefined;
    var min_position: ?u32 = undefined;

    while (position <= max) {
        const fuel = try fuelUsage(crabs, position, constant_rate);

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

    return FuelUsage{ .position = min_position.?, .fuel = min_fuel.? };
}

fn fuelUsage(crabs: []const u32, position: u32, constant_rate: bool) !u32 {
    var fuel: u32 = 0;
    for (crabs) |crab| {
        const distance: u32 = @intCast(u32, try math.absInt(@intCast(i32, crab) - @intCast(i32, position)));
        if (constant_rate) {
            fuel += distance;
        } else {
            fuel += summation(distance);
        }
    }
    return fuel;
}

fn summation(distance: u32) u32 {
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
