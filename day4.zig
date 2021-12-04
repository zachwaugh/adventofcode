const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

const Board = struct {
    numbers: []const []const u8,
    markers: [5][5]bool = [5][5]bool{ [_]bool{ false, false, false, false, false }, [_]bool{ false, false, false, false, false }, [_]bool{ false, false, false, false, false }, [_]bool{ false, false, false, false, false }, [_]bool{ false, false, false, false, false } },

    fn mark_number(self: *Board, called_number: u8) void {
        for (self.numbers) |row, row_index| {
            for (row) |number, column_index| {
                if (number == called_number) {
                    self.markers[row_index][column_index] = true;
                }
            }
        }
    }

    fn is_bingo(self: Board) bool {
        // Check rows
        for (self.markers) |row| {
            var bingo = true;

            for (row) |value, column_index| {
                bingo = bingo and value;

                if (column_index == 4 and bingo) {
                    return true;
                }
            }
        }

        // Check columns
        for ([_]u8{ 0, 1, 2, 3, 4 }) |column_index| {
            var bingo = true;

            for ([_]u8{ 0, 1, 2, 3, 4 }) |row_index| {
                const value = self.markers[row_index][column_index];
                bingo = bingo and value;

                if (bingo and row_index == 4) {
                    return true;
                }
            }
        }

        return false;
    }

    fn unmarked_numbers(self: Board) []const u32 {
        var unmarked = std.ArrayList(u32).init(allocator);
        defer unmarked.deinit();

        for (self.numbers) |row, row_index| {
            for (row) |number, column_index| {
                if (!self.markers[row_index][column_index]) {
                    unmarked.append(number) catch unreachable;
                }
            }
        }

        return unmarked.toOwnedSlice();
    }
};

const Data = struct { numbers: []const u8, boards: []Board };

pub fn main() !void {
    const data = try loadData("data/day4.txt");
    try puzzle1(data);
    try puzzle2();
}

fn puzzle1(data: Data) !void {
    var bingo = false;

    for (data.numbers) |number| {
        for (data.boards) |_, index| {
            data.boards[index].mark_number(number);
            const board = data.boards[index];

            if (board.is_bingo()) {
                const unmarked = utils.sum(board.unmarked_numbers());
                std.debug.print("[Day 4/Puzzle 1] Bingo!: {d}\n", .{ unmarked * number });
                bingo = true;
                break;
            }
        }

        if (bingo) {
            break;
        }
    }
}

fn puzzle2() !void {
    std.debug.print("[Day 4/Puzzle 2] not implemented\n", .{});
}

fn loadData(path: []const u8) !Data {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var numbers: []const u8 = undefined;
    var boards = std.ArrayList(Board).init(allocator);
    defer boards.deinit();

    var rows = std.ArrayList([]const u8).init(allocator);
    defer rows.deinit();

    for (lines) |line, index| {
        if (index == 0) {
            numbers = try parseNumbers(line);
        } else if (mem.eql(u8, line, "\n")) {
            continue;
        } else {
            const row = try parseBingoRow(line);
            try rows.append(row);
        }

        if (rows.items.len == 5) {
            const board = Board{ .numbers = rows.toOwnedSlice() };
            try boards.append(board);
            // TODO: can I clear instead of creating a new one?
            rows = std.ArrayList([]const u8).init(allocator);
        }
    }

    return Data{ .numbers = numbers, .boards = boards.toOwnedSlice() };
}

fn parseNumbers(line: []const u8) ![]u8 {
    var iterator = std.mem.split(u8, line, ",");
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    while (iterator.next()) |value| {
        const number = try std.fmt.parseInt(u8, value, 10);
        try list.append(number);
    }

    return list.toOwnedSlice();
}

fn parseBingoRow(line: []const u8) ![]u8 {
    var iterator = std.mem.tokenize(u8, line, " ");
    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    while (iterator.next()) |value| {
        const number = try std.fmt.parseInt(u8, value, 10);
        try list.append(number);
    }

    return list.toOwnedSlice();
}
