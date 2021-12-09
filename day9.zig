const std = @import("std");
const mem = std.mem;
const math = std.math;
const sort = std.sort;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;
const asc_u32 = sort.desc(u32);

pub fn main() !void {
    const rows = try loadData("data/day9.txt");
    try puzzle1(rows);
    try puzzle2(rows);
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

            // Up
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

            // Down
            if (row_index < rows.len - 1) {
                const value = rows[row_index + 1][col_index];
                if (value < low) {
                    low = value;
                }
            }

            if (number < low) {
                // This is the lowest of its neighbors
                risk_level += number + 1;
            }
        }
    }

    print("[Day 9/Puzzle 1] total risk level: {d}\n", .{risk_level});
}

/// Answers
/// - Test: 1134
/// - Input: 847504
fn puzzle2(rows: [][]u8) !void {
    print("[Day 9/Puzzle 2] processing {d} rows\n", .{rows.len});
    var basins = std.ArrayList(u32).init(allocator);
    var visited = std.AutoHashMap(Location, bool).init(allocator);
    defer visited.deinit();

    for (rows) |row, row_index| {
        for (row) |_, col_index| {
            const location = Location{ .row = @intCast(u8, row_index), .col = @intCast(u8, col_index) };
            const size = basinSize(location, rows, &visited);
            try basins.append(size);
        }
    }

    var sizes = basins.toOwnedSlice();
    sort.sort(u32, sizes, {}, asc_u32);
    const risk_level: u32 = sizes[0] * sizes[1] * sizes[2];
    print("[Day 9/Puzzle 2] risk level: {d}\n", .{risk_level});
}

fn basinSize(location: Location, rows: [][]u8, visited: *std.AutoHashMap(Location, bool)) u32 {
    if (rows[location.row][location.col] == 9 or visited.get(location) != null) return 0;

    var size: u32 = 1;
    visited.put(location, true) catch unreachable;

    if (location.up()) |loc| {
        size += basinSize(loc, rows, visited);
    }

    if (location.left()) |loc| {
        size += basinSize(loc, rows, visited);
    }

    if (location.right(rows)) |loc| {
        size += basinSize(loc, rows, visited);
    }

    if (location.down(rows)) |loc| {
        size += basinSize(loc, rows, visited);
    }

    return size;
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

const Location = struct {
    row: u8,
    col: u8,

    fn left(self: Location) ?Location {
        if (self.col == 0) return null;
        return Location{ .row = self.row, .col = self.col - 1 };
    }

    fn right(self: Location, rows: [][]u8) ?Location {
        if (self.col >= rows[self.row].len - 1) return null;
        return Location{ .row = self.row, .col = self.col + 1 };
    }

    fn up(self: Location) ?Location {
        if (self.row == 0) return null;
        return Location{ .row = self.row - 1, .col = self.col };
    }

    fn down(self: Location, rows: [][]u8) ?Location {
        if (self.row >= rows.len - 1) return null;
        return Location{ .row = self.row + 1, .col = self.col };
    }
};
