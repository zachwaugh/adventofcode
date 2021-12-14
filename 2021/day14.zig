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
    const polymer = try loadData("data/day14.txt");
    try puzzle1(polymer);
    try puzzle2(polymer);
}

/// Answers
/// - Test: 1588
/// - Input: 3143
fn puzzle1(polymer: Polymer) !void {
    var timer = try Timer.start();
    print("[Day 14/Puzzle 1] processing polymer template: {s} with {d} rules and 10 steps\n", .{ polymer.template, polymer.rules.len });
    const result = try run(polymer, 10);
    print("[Day 14/Puzzle 1] result: {d} in {d}\n", .{ result, utils.seconds(timer.read()) });
}

/// Answers
/// - Test: 2188189693529
/// - Input: 4110215602456
fn puzzle2(polymer: Polymer) !void {
    var timer = try Timer.start();
    print("[Day 14/Puzzle 2] processing polymer template: {s} with {d} rules and 40 steps\n", .{ polymer.template, polymer.rules.len });
    const result = try run(polymer, 40);
    print("[Day 14/Puzzle 2] result: {d} in {d}\n", .{ result, utils.seconds(timer.read()) });
}

fn run(polymer: Polymer, steps: u32) !u64 {
    var pairs = std.StringHashMap(u64).init(allocator);
    var index: usize = 0;
    while (index < polymer.template.len - 1) : (index += 1) {
        const pair = polymer.template[index .. index + 2];
        const count = pairs.get(pair) orelse 0;
        try pairs.put(pair, count + 1);
    }

    var step: u8 = 0;
    while (step < steps) : (step += 1) {
        var pairs_new = std.StringHashMap(u64).init(allocator);
        var iterator = pairs.iterator();

        while (iterator.next()) |entry| {
            const pair = entry.key_ptr.*;
            const count = entry.value_ptr.*;

            for (polymer.rules) |rule| {
                if (!mem.eql(u8, rule.pair, pair)) continue;

                var buffer = try allocator.alloc(u8, 3);
                buffer[0] = pair[0];
                buffer[1] = rule.insertion;
                buffer[2] = pair[1];

                const pair1 = buffer[0..2];
                const pair1_count = pairs_new.get(pair1) orelse 0;
                try pairs_new.put(pair1, pair1_count + count);

                const pair2 = buffer[1..3];
                const pair2_count = pairs_new.get(pair2) orelse 0;
                try pairs_new.put(pair2, pair2_count + count);
            }
        }

        pairs = pairs_new;
    }

    return maxMinDifference(pairs);
}

fn maxMinDifference(counts: std.StringHashMap(u64)) !u64 {
    var counter = std.AutoHashMap(u8, u64).init(allocator);
    var iterator = counts.iterator();

    while (iterator.next()) |entry| {
        const pair = entry.key_ptr.*;
        const count = entry.value_ptr.*;

        const char1 = pair[0];
        const count1 = counter.get(char1) orelse 0;
        try counter.put(char1, count1 + count);

        const char2 = pair[1];
        const count2 = counter.get(char2) orelse 0;
        try counter.put(char2, count2 + count);
    }

    // Each letter is counted twice (in adjacent pairs), so need to divide by 2
    const min = try math.divCeil(u64, minValue(counter), 2);
    const max = try math.divCeil(u64, maxValue(counter), 2);
    return max - min;
}

fn minValue(counter: std.AutoHashMap(u8, u64)) u64 {
    var iterator = counter.iterator();
    var min: u64 = std.math.maxInt(u64);

    while (iterator.next()) |entry| {
        if (entry.value_ptr.* < min) {
            min = entry.value_ptr.*;
        }
    }

    return min;
}

fn maxValue(counter: std.AutoHashMap(u8, u64)) u64 {
    var iterator = counter.iterator();
    var max: u64 = 0;

    while (iterator.next()) |entry| {
        if (entry.value_ptr.* > max) {
            max = entry.value_ptr.*;
        }
    }

    return max;
}

fn loadData(path: []const u8) !Polymer {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var rules = ArrayList(Rule).init(allocator);
    var template: []const u8 = undefined;

    for (lines) |line, index| {
        if (line.len == 0) continue;
        if (index == 0) {
            template = line;
        } else {
            var components = mem.split(u8, line, " -> ");
            const pair = components.next().?;
            const insertion = components.next().?;
            const rule = Rule{ .pair = pair, .insertion = insertion[0] };
            try rules.append(rule);
        }
    }

    return Polymer{ .template = template, .rules = rules.toOwnedSlice() };
}

const Polymer = struct { template: []const u8, rules: []Rule };
const Rule = struct { pair: []const u8, insertion: u8 };
