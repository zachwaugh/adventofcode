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
    try puzzle2();
}

/// Answers
/// - Test: 1588
/// - Input: 3143
fn puzzle1(polymer: Polymer) !void {
    print("[Day 14/Puzzle 1] processing polymer template: {s} with {d} rules\n", .{ polymer.template, polymer.rules.len });

    var output = ArrayList(u8).init(allocator);
    for (polymer.template) |character| {
        try output.append(character);
    }

    const steps: u32 = 10;
    var step: u32 = 0;

    while (step < steps) : (step += 1) {
        var step_output = ArrayList(u8).init(allocator);
        var index: u32 = 0;
        while (index < output.items.len - 1) : (index += 1) {
            const pair = output.items[index .. index + 2];

            for (polymer.rules) |rule| {
                if (mem.eql(u8, rule.pair, pair)) {
                    try step_output.append(pair[0]);
                    try step_output.append(rule.insertion);
                }
            }
        }

        try step_output.append(output.items[index]);
        output = step_output;
    }

    var counter = std.AutoHashMap(u8, u32).init(allocator);

    for (output.items) |character| {
        const count = counter.get(character) orelse 0;
        try counter.put(character, count + 1);
    }

    const min = minValue(counter);
    const max = maxValue(counter);
    const delta = max - min;
    print("[Day 14/Puzzle 2] max: {d}, min: {d} => {d}\n", .{ max, min, delta });
}

fn puzzle2() !void {
    print("[Day 14/Puzzle 2] not implemented\n", .{});
}

fn minValue(counter: std.AutoHashMap(u8, u32)) u32 {
    var iterator = counter.iterator();
    var min: u32 = std.math.maxInt(u32);

    while (iterator.next()) |entry| {
        if (entry.value_ptr.* < min) {
            min = entry.value_ptr.*;
        }
    }

    return min;
}

fn maxValue(counter: std.AutoHashMap(u8, u32)) u32 {
    var iterator = counter.iterator();
    var max: u32 = 0;

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
            const insertion = components.next().?[0];
            const rule = Rule{ .pair = pair, .insertion = insertion };
            try rules.append(rule);
        }
    }

    return Polymer{ .template = template, .rules = rules.toOwnedSlice() };
}

const Polymer = struct { template: []const u8, rules: []Rule };

const Rule = struct { pair: []const u8, insertion: u8 };
