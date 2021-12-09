const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const seconds = utils.seconds;
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;
const Timer = std.time.Timer;

pub fn main() !void {
    const fish = try loadData("data/day6.txt");
    try puzzle1(fish, 80);
    try puzzle2(fish, 256);
}

// Answer
// Test: 5934
// Input: 362666
fn puzzle1(data: []const u4, days: u32) !void {
    print("[Day 6/Puzzle 1] processing {d} fish\n", .{data.len});
    var time = try Timer.start();
    var fish = std.ArrayList(u4).init(allocator);
    defer fish.deinit();

    for (data) |timer| {
        try fish.append(timer);
    }

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

    print("[Day 6/Puzzle 1] {d} fish after {d} days in {d:.3}\n", .{ fish.items.len, days, seconds(time.read()) });
}

// Answer
// Test: 26984457539
// Input: 1640526601595
fn puzzle2(data: []const u4, days: u32) !void {
    print("[Day 6/Puzzle 2] processing {d} fish\n", .{data.len});
    var time = try Timer.start();
    var hashMap = std.AutoHashMap(u4, u64).init(allocator);
    defer hashMap.deinit();

    var totals = std.ArrayList(u64).init(allocator);
    defer totals.deinit();

    for (data) |timer| {
        if (hashMap.get(timer)) |total| {
            try totals.append(total);
        } else {
            const total = try population(timer, days);
            try hashMap.put(timer, total);
            try totals.append(total);
        }
    }

    var total: u64 = 0;
    for (totals.items) |value| {
        total += value;
    }

    print("[Day 6/Puzzle 2] {d} fish after {d} days in {d:.3}\n", .{ total, days, seconds(time.read()) });
}

fn population(start: u4, days: u32) !u64 {
    var fish = std.ArrayList(u4).init(allocator);
    defer fish.deinit();

    try fish.append(start);
    var day: u32 = 0;

    var time = try Timer.start();
    print("> Computing fish for timer {d} and days {d}\n", .{ start, days });

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

    print("> Total for timer {d} and days {d} is {d} in {d:.3}\n", .{ start, days, fish.items.len, seconds(time.read()) });

    return fish.items.len;
}

fn loadData(path: []const u8) ![]const u4 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);
    std.debug.assert(lines.len == 1);

    const line = lines[0];
    var tokens = mem.split(u8, line, ",");
    var numbers = std.ArrayList(u4).init(allocator);
    defer numbers.deinit();

    while (tokens.next()) |token| {
        const number = try std.fmt.parseInt(u4, token, 10);
        try numbers.append(number);
    }

    return numbers.toOwnedSlice();
}