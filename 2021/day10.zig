const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;
const sort = std.sort;
const asc_u64 = sort.desc(u64);

pub fn main() !void {
    const lines = try loadData("data/day10.txt");
    try puzzle1(lines);
    try puzzle2(lines);
}

/// Answers
/// - Test: 26397
/// - Input: 296535
fn puzzle1(lines: [][]const u8) !void {
    print("[Day 10/Puzzle 1] processing {d} lines\n", .{lines.len});
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
                    if (index == 0) {
                        print("Line {d}:{d} - Invalid character! Found closing character with no opening character: {c}\n", .{ line_index, position, character });
                        break;
                    } else {
                        const previous = stack[index - 1];

                        if ((character == ')' and previous != '(') or (character == ']' and previous != '[') or (character == '}' and previous != '{') or (character == '>' and previous != '<')) {
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

/// Answers
/// - Test: 288957
/// - Input: 4245130838
fn puzzle2(lines: [][]const u8) !void {
    print("[Day 10/Puzzle 2] processing {d} lines\n", .{lines.len});
    var completion_scores = std.ArrayList(u64).init(allocator);
    defer completion_scores.deinit();

    for (lines) |line, line_index| {
        var stack: [256]u8 = undefined;
        var index: u32 = 0;
        var corrupt = false;

        for (line) |character, position| {
            switch (character) {
                '(', '[', '{', '<' => {
                    stack[index] = character;
                    index += 1;
                },
                ')', ']', '}', '>' => {
                    if (index == 0) {
                        print("Line {d}:{d} - Invalid character! Found closing character with no opening character: {c}\n", .{ line_index, position, character });
                        break;
                    } else {
                        const previous = stack[index - 1];

                        if ((character == ')' and previous != '(') or (character == ']' and previous != '[') or (character == '}' and previous != '{') or (character == '>' and previous != '<')) {
                            corrupt = true;
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

        if (!corrupt and index > 0) {
            const completion_string = try completionString(&stack, index);
            const score = completionStringScore(completion_string);
            try completion_scores.append(score);
        }
    }

    var scores = completion_scores.toOwnedSlice();
    sort.sort(u64, scores, {}, asc_u64);
    const middle_score = scores[scores.len / 2];
    print("[Day 10/Puzzle 2] middle score: {d}\n", .{middle_score});
}

fn completionString(stack: []const u8, len: usize) ![]const u8 {
    var string = std.ArrayList(u8).init(allocator);
    defer string.deinit();

    var index = len - 1;
    while (index >= 0) {
        const character = stack[index];

        switch (character) {
            '(' => try string.append(')'),
            '[' => try string.append(']'),
            '{' => try string.append('}'),
            '<' => try string.append('>'),
            else => print("Invalid character! {c}\n", .{character}),
        }

        if (index == 0) break;
        index -= 1;
    }

    return string.toOwnedSlice();
}

fn completionStringScore(string: []const u8) u64 {
    var score: u64 = 0;
    for (string) |character| {
        score *= 5;

        switch (character) {
            ')' => score += 1,
            ']' => score += 2,
            '}' => score += 3,
            '>' => score += 4,
            else => {
                print("Unexpected missing character: {c}\n", .{character});
            },
        }
    }

    return score;
}

fn loadData(path: []const u8) ![][]const u8 {
    return try utils.readLines(allocator, path);
}
