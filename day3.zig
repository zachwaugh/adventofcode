const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const entries = try loadData("data/day3.txt");
    try puzzle1(entries);
    try puzzle2(entries);
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

fn puzzle2(entries: []const u32) !void {
    const bits: u8 = 12;
    var bit: u5 = bits - 1;
    var oxygen_entries = entries[0..entries.len];
    var co2_entries = entries[0..entries.len];

    while (bit >= 0) {
        oxygen_entries = find_common_entries(oxygen_entries, bit, true);

        if (oxygen_entries.len == 1) {
            break;
        }

        bit -= 1;
    }

    bit = bits - 1;
    while (bit >= 0) {
        co2_entries = find_common_entries(co2_entries, bit, false);

        if (co2_entries.len == 1) {
            break;
        }

        bit -= 1;
    }

    const oxygen_generator = oxygen_entries[0];
    const co2_scrubber: u32 = co2_entries[0];

    const life_support = oxygen_generator * co2_scrubber;
    std.debug.print("[Day 3, Puzzle 2] oxygen generator rating: {}, CO2 scrubber rating: {}, life support: {}\n", .{ oxygen_generator, co2_scrubber, life_support });
}

fn most_common_bit(numbers: []const u32, place: u5) u32 {
    var result: u32 = 0;
    const bit_shift: u32 = 1;
    const bit_mask: u32 = bit_shift << place;

    for (numbers) |number| {
        result += (number & bit_mask) >> place;
    }

    const value = math.divCeil(usize, numbers.len, 2) catch unreachable;

    if (result >= value) {
        return 1;
    } else {
        return 0;
    }
}

fn find_common_entries(numbers: []const u32, place: u5, most_common: bool) []u32 {
    const common_bit = most_common_bit(numbers, place);
    var filtered = std.ArrayList(u32).init(allocator);
    defer filtered.deinit();

    const bit_shift: u32 = 1;
    const bit_mask: u32 = bit_shift << place;

    for (numbers) |number| {
        const bit_value = (number & bit_mask) >> place;
        const is_match = bit_value == common_bit;

        if ((most_common and is_match) or (!most_common and !is_match)) {
            filtered.append(number) catch unreachable;
        }
    }

    return filtered.toOwnedSlice();
}

fn loadData(path: []const u8) ![]const u32 {
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
