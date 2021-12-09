const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const rows = try loadData("data/day9.txt");
    try puzzle1(rows);
    try puzzle2();
}


/// Answers
/// - Test: 15
/// - Input: 541
fn puzzle1(rows: [][]u8) !void {
    print("[Day 9/Puzzle 1] processing {d} rows\n", .{rows.len});

    var risk_level: u32 = 0;

    for (rows) |row, row_index| {
        for (row) |number, col_index| {
            var low: u8 = 255;

            // Top
            if (row_index > 0) {
                const value = rows[row_index - 1][col_index];
                if (value < low) {
                    low = value;
                }
            }

            // Left
            if (col_index > 0) {
                const value = rows[row_index][col_index - 1];
                if (value < low) {
                    low = value;
                }
            }

            // Right
            if (col_index < row.len - 1) {
                const value = rows[row_index][col_index + 1];
                if (value < low) {
                    low = value;
                }
            }

            // Bottom
            if (row_index < rows.len - 1) {
                const value = rows[row_index + 1][col_index];
                if (value < low) {
                    low = value;
                }
            }

            if (number < low) {
                // This is the lowest of its neighbors
                risk_level += number + 1;
                print("- Number at {d}x{d} is lowest of neighbors: {d}\n", .{row_index, col_index, number});
            }
        }
    }

    print("[Day 9/Puzzle 1] total risk level: {d}\n", .{risk_level});
}

fn puzzle2() !void {
    print("[Day 9/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) ![][]u8 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var number_lines = std.ArrayList([]u8).init(allocator);
    defer number_lines.deinit();

    for (lines) |line| {
        var buffer = try allocator.alloc(u8, line.len);

        for (line) |character, index| {
            buffer[index] = try std.fmt.charToDigit(character, 10);
        }

        try number_lines.append(buffer);
    }

    return number_lines.toOwnedSlice();
}
