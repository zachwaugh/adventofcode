const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;
const Timer = std.time.Timer;

pub fn main() !void {
    const entries = try loadData("data/day8.txt");
    try puzzle1(entries);
    try puzzle2(entries);
}

/// Answers
/// - Test: 26
/// - Input: 321
fn puzzle1(entries: []Entry) !void {
    print("[Day 8/Puzzle 1] processing {d} entries\n", .{entries.len});

    var simple_digits: u32 = 0;

    for (entries) |entry| {
        for (entry.digits) |digit| {
            if (digit.len == 2 or digit.len == 4 or digit.len == 3 or digit.len == 7) {
                simple_digits += 1;
            }
        }
    }

    print("[Day 8/Puzzle 1] simple digits appeared {d} times\n", .{simple_digits});
}

/// Answers
/// - Test: 61229
/// - Input: 1028926
fn puzzle2(entries: []Entry) !void {
    print("[Day 8/Puzzle 2] processing {d} entries\n", .{entries.len});
    var timer = try Timer.start();
    const mappings = generate_mappings();
    var solved_entries = std.AutoHashMap(usize, void).init(allocator);
    var total: u32 = 0;

    for (mappings) |mapping| {
        for (entries) |entry, entry_index| {
            if (solved_entries.get(entry_index) != null) continue;

            if (is_valid_mapping(mapping, entry)) {
                total += combined_digits(entry, mapping);
                try solved_entries.put(entry_index, {});
            }
        }
    }

    print("[Day 8/Puzzle 2] all digits combined: {d} in {d:.3}\n", .{ total, utils.seconds(timer.read()) });
}

/// Generate all possible mappings for our display
fn generate_mappings() [][]const u8 {
    var alphabet = [_]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g' };
    var mappings = std.ArrayList([]u8).init(allocator);
    utils.permutations(&alphabet, alphabet.len, &mappings);
    return mappings.toOwnedSlice();
}

fn is_valid_mapping(mapping: []const u8, entry: Entry) bool {
    var valid = true;

    for (entry.signals) |signal| {
        const display = make_display(signal, mapping) catch unreachable;

        if (display.digit() == null) {
            valid = false;
            break;
        }
    }

    return valid;
}

/// Make a display using a particular mapping
/// A mapping is an array of characters, index 0 is the character used for 'a', index 1 for 'b', etc
fn make_display(string: []const u8, mapping: []const u8) !SegmentDisplay {
    var display = SegmentDisplay{};

    for (string) |character| {
        display.enable(mapping[character - 'a']);
    }

    return display;
}

/// Combine multiple individual digits into a single number
fn combined_digits(entry: Entry, mapping: []const u8) u32 {
    var total: u32 = 0;

    for (entry.digits) |digit, index| {
        const display = make_display(digit, mapping) catch unreachable;
        const value: u32 = display.digit().? * @intCast(u32, math.pow(usize, 10, entry.digits.len - index - 1));
        total += value;
    }

    return total;
}

const segments = [10]u8{
    0b11101110, // 0 = abcefg
    0b00100100, // 1 = cf
    0b10111010, // 2 = acdeg
    0b10110110, // 3 = acdfg
    0b01110100, // 4 = bcdf
    0b11010110, // 5 = abdfg
    0b11011110, // 6 = abdefg
    0b10100100, // 7 = acf
    0b11111110, // 8 = abcdefg
    0b11110110, // 9 = abcdfg
};

const SegmentDisplay = struct {
    // Each bit is a segment with the lsb ignored
    // 0b00000000
    //   abcdefg_
    segments: u8 = 0,

    fn digit(self: SegmentDisplay) ?u8 {
        for (segments) |segment, index| {
            if (self.segments == segment) {
                return @intCast(u8, index);
            }
        }

        return null;
    }

    fn enable(self: *SegmentDisplay, segment: u8) void {
        switch (segment) {
            'a' => self.segments |= 0b10000000,
            'b' => self.segments |= 0b01000000,
            'c' => self.segments |= 0b00100000,
            'd' => self.segments |= 0b00010000,
            'e' => self.segments |= 0b00001000,
            'f' => self.segments |= 0b00000100,
            'g' => self.segments |= 0b00000010,
            else => return,
        }
    }
};

const Entry = struct { signals: [][]const u8, digits: [][]const u8 };

fn loadData(path: []const u8) ![]Entry {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var entries = std.ArrayList(Entry).init(allocator);
    defer entries.deinit();

    for (lines) |line| {
        const entry = try parseLine(line);
        try entries.append(entry);
    }

    return entries.toOwnedSlice();
}

fn parseLine(line: []const u8) !Entry {
    var iterator = mem.split(u8, line, "|");

    const signals = try parseGroups(iterator.next().?);
    const digits = try parseGroups(iterator.next().?);

    return Entry{ .signals = signals, .digits = digits };
}

fn parseGroups(line: []const u8) ![][]const u8 {
    var iterator = mem.tokenize(u8, line, " ");
    var strings = std.ArrayList([]const u8).init(allocator);
    defer strings.deinit();

    while (iterator.next()) |string| {
        try strings.append(string);
    }

    return strings.toOwnedSlice();
}
