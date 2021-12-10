const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;

const Board = struct {
    squares: [5][5]Square,
    won: bool = false,

    const Square = struct{
        number: u8,
        called: bool = false
    };

    fn mark_number(self: *Board, called_number: u8) void {
        for (self.squares) |row, row_index| {
            for (row) |square, column_index| {
                if (square.number == called_number) {
                    self.squares[row_index][column_index].called = true;
                }
            }
        }
    }

    fn has_bingo(self: Board) bool {
        // Check rows
        for (self.squares) |row| {
            var bingo = true;

            for (row) |square, column_index| {
                bingo = bingo and square.called;

                if (column_index == 4 and bingo) {
                    return true;
                }
            }
        }

        // Check columns
        for ([_]u8{ 0, 1, 2, 3, 4 }) |column_index| {
            var bingo = true;

            for ([_]u8{ 0, 1, 2, 3, 4 }) |row_index| {
                const square = self.squares[row_index][column_index];
                bingo = bingo and square.called;

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

        for (self.squares) |row| {
            for (row) |square| {
                if (!square.called) {
                    unmarked.append(square.number) catch unreachable;
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
    try puzzle2(data);
}

fn puzzle1(data: Data) !void {
    for (data.numbers) |number| {
        for (data.boards) |_, index| {
            data.boards[index].mark_number(number);
            const board = data.boards[index];

            if (board.has_bingo()) {
                const unmarked = utils.sum(board.unmarked_numbers());
                std.debug.print("[Day 4/Puzzle 1] Bingo! number: {d}, answer: {d}\n", .{ number, unmarked * number });
                return;
            }
        }
    }
}

fn puzzle2(data: Data) !void {
    var bingos: u32 = 0;

    for (data.numbers) |number| {
        for (data.boards) |board, index| {
            if (board.won) continue;

            data.boards[index].mark_number(number);
            const updated_board = data.boards[index];

            if (updated_board.has_bingo()) {
                data.boards[index].won = true;
                bingos += 1;

                if (bingos == data.boards.len) {
                    const unmarked = utils.sum(updated_board.unmarked_numbers());
                    std.debug.print("[Day 4/Puzzle 2] Final bingo! number: {d}, answer: {d}\n", .{ number, unmarked * number });
                    return;
                }
            }
        }
    }
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
            const squares = rowsToSquares(rows.toOwnedSlice());
            const board = Board{ .squares = squares };
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

fn rowsToSquares(rows: []const []const u8) [5][5]Board.Square {
    var squares: [5][5]Board.Square = undefined;

    for (rows) |row, row_index| {
        for (row) |number, column_index| {
            squares[row_index][column_index] = Board.Square{ .number = number };
        }
    }

    return squares;
}
