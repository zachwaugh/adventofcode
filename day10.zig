const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const lines = try loadData("data/day10.txt");
    try puzzle1(lines);
    try puzzle2();
}

/// Answers
/// Test: 26397
/// Input: 296535
fn puzzle1(lines: [][]const u8) !void {
    print("[Day 10/Puzzle 1] processing {d}\n", .{lines.len});
    var corrupt_characters = std.ArrayList(u8).init(allocator);
    defer corrupt_characters.deinit();

    for (lines) |line, line_index| {
        var stack: [256]u8 = undefined;
        var index: u32 = 0;

        for (line) |character, position| {
            switch (character) {
                '(', '[', '{', '<' => {
                    stack[index] = character;
                    index += 1;
                },
                ')', ']', '}', '>' => {
                    if (stack.len == 0) {
                        print("Line {d}:{d} - Invalid character! Found closing character with no opening character: {c}\n", .{ line_index, position, character });
                        break;
                    } else {
                        const previous = stack[index - 1];

                        if ((character == ')' and previous != '(') or (character == ']' and previous != '[') or (character == '}' and previous != '{') or (character == '>' and previous != '<')) {
                            print("Line {d}:{d} - Corrupted chunk! Expected closing character for {c}, but found {c}\n", .{ line_index, position, previous, character });
                            try corrupt_characters.append(character);
                            break;
                        } else {
                            index -= 1;
                        }
                    }
                },
                else => {
                    print("Line {d}:{d} - Invalid character: {c}\n", .{ line_index, position, character });
                    break;
                },
            }
        }

        if (stack.len > 0) {
            print("Line {d} - Incomplete line, stack non-empty: {s}\n", .{ line_index, stack[0..index] });
        }
    }

    var points: u32 = 0;
    for (corrupt_characters.items) |character| {
        switch (character) {
            ')' => points += 3,
            ']' => points += 57,
            '}' => points += 1197,
            '>' => points += 25137,
            else => {
                print("Unexpected corrupt character: {c}\n", .{character});
            },
        }
    }

    print("[Day 10/Puzzle 1] total corrupt character points: {d}\n", .{points});
}

fn puzzle2() !void {
    print("[Day 10/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) ![][]const u8 {
    return try utils.readLines(allocator, path);
}
