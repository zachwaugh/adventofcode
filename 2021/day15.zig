const std = @import("std");
const mem = std.mem;
const math = std.math;
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Timer = std.time.Timer;
const utils = @import("utils.zig");
const Location = utils.Location;
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const grid = try loadData("data/day15.txt");
    try puzzle1(grid);
    try puzzle2(grid);
}

/// Answers
/// - Test: 40
/// - Input: 745
fn puzzle1(grid: [][]const u8) !void {
    var timer = try Timer.start();
    print("[Day 15/Puzzle 1] processing grid: {d}x{d}\n", .{ grid.len, grid[0].len });
    const risk = aStar(grid);
    print("[Day 15/Puzzle 1] lowest risk level: {d} in {d}\n", .{ risk, utils.seconds(timer.read()) });
}

/// Answers
/// - Test: 315
/// - Input: 3002
fn puzzle2(grid: [][]const u8) !void {
    var timer = try Timer.start();
    const expanded = try expandGrid(grid, 5);
    print("[Day 15/Puzzle 2] processing grid: {d}x{d}\n", .{ expanded.len, expanded[0].len });
    const risk = aStar(expanded);
    print("[Day 15/Puzzle 2] lowest risk level in expanded grid: {d} in {d}\n", .{ risk, utils.seconds(timer.read()) });
}

/// Ported almost verbatim from https://en.wikipedia.org/wiki/A*_search_algorithm
/// and https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
fn aStar(grid: [][]const u8) !?u32 {
    const start = Location.start();
    const max_score = std.math.maxInt(u32);

    var priority_queue = std.PriorityQueue(QueueItem, compare).init(allocator);
    defer priority_queue.deinit();
    try priority_queue.add(QueueItem{ .location = start, .risk = 0 });

    var paths = std.AutoHashMap(Location, Location).init(allocator);
    defer paths.deinit();

    var scores = std.AutoHashMap(Location, u32).init(allocator);
    defer scores.deinit();
    try scores.put(start, 0);

    while (priority_queue.count() > 0) {
        var item = priority_queue.remove();
        const current = item.location;

        if (current.isEnd(grid)) {
            return riskLevel(paths, current, grid);
        }

        const neighbors = try current.neighbors(grid, allocator);
        for (neighbors) |neighbor| {
            const current_score = scores.get(current) orelse max_score;
            const neighbor_score = scores.get(neighbor) orelse max_score;
            const risk = grid[neighbor.row][neighbor.col];
            const tentative_score = current_score + risk;

            if (tentative_score < neighbor_score) {
                try paths.put(neighbor, current);
                try scores.put(neighbor, tentative_score);
                try priority_queue.add(QueueItem{ .location = neighbor, .risk = tentative_score });
            }
        }
    }

    return null;
}

fn riskLevel(paths: std.AutoHashMap(Location, Location), current: Location, grid: [][]const u8) u32 {
    var risk_level: u32 = 0;
    var location: ?Location = current;

    while (location != null) {
        const value = grid[location.?.row][location.?.col];
        if (!location.?.isStart()) {
            risk_level += value;
        }

        location = paths.get(location.?);
    }

    return risk_level;
}

fn expandGrid(grid: [][]const u8, factor: u8) ![][]const u8 {
    const rows = grid.len * factor;
    const tile_size = grid[0].len;
    const cols = tile_size * factor;
    var row: usize = 0;
    var col: usize = 0;
    var new = ArrayList([]u8).init(allocator);

    while (row < rows) : (row += 1) {
        var new_row = try allocator.alloc(u8, cols);

        while (col < cols) : (col += 1) {
            const row_tile = col / tile_size;
            const col_tile = row / tile_size;
            const source_col = col % tile_size;
            const source_row = row % tile_size;
            const source = grid[source_row][source_col];
            const new_val = @intCast(u8, source + row_tile + col_tile);

            if (new_val > 9) {
                new_row[col] = new_val - 9;
            } else {
                new_row[col] = new_val;
            }
        }

        try new.append(new_row);
        col = 0;
    }

    return new.toOwnedSlice();
}

const QueueItem = struct { location: Location, risk: u32 };

fn compare(item1: QueueItem, item2: QueueItem) math.Order {
    if (item1.risk < item2.risk) {
        return .lt;
    } else if (item1.risk > item2.risk) {
        return .gt;
    } else {
        return .eq;
    }
}

fn loadData(path: []const u8) ![][]const u8 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);
    var rows = ArrayList([]const u8).init(allocator);

    for (lines) |line| {
        var buffer = try allocator.alloc(u8, line.len);
        for (line) |character, index| {
            buffer[index] = try fmt.charToDigit(character, 10);
        }

        try rows.append(buffer);
    }

    return rows.toOwnedSlice();
}
