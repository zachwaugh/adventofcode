const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;
const Location = utils.Location;

pub fn main() !void {
    var octopi = try loadData("data/day11.txt");
    try puzzle1(octopi);
    try puzzle2();
}

/// Answers
/// - Test: 1656
/// - Input: 
fn puzzle1(octopi: [][]u8) !void {
    print("[Day 11/Puzzle 1] processing {d} rows grid\n", .{octopi.len});

    var flashes: u32 = 0;
    const steps: u8 = 100;
    var step: u8 = 0;
    var flashed = std.AutoHashMap(Location, void).init(allocator);

    while (step < steps) {
        // Increase all by 1
        for (octopi) |row, row_index| {
            for (row) |octopus, col_index| {
                octopi[row_index][col_index] = octopus + 1;
            }
        }

        // Flash all neighbors
        for (octopi) |row, row_index| {
            for (row) |_, col_index| {
                const location = Location{ .row = @intCast(u8, row_index), .col = @intCast(u8, col_index) };
                flashOctopus(octopi, location, &flashed);
            }
        }

        // Reset values for all flashed octopi
        var iterator = flashed.keyIterator();
        while (iterator.next()) |location| {
            octopi[location.row][location.col] = 0;
        }

        step += 1;
        flashes += flashed.count();
        flashed.clearRetainingCapacity();
    }

    print("[Day 11/Puzzle 1] total flashes after {d} steps: {d}\n", .{ steps, flashes });
}

fn puzzle2() !void {
    print("[Day 11/Puzzle 2] not implemented\n", .{});
}

fn flashOctopus(octopi: [][]u8, location: Location, flashed: *std.AutoHashMap(Location, void)) void {
    const value = octopi[location.row][location.col];
    if (flashed.get(location) != null or value <= 9) return;

    // Mark this location as flashed
    flashed.put(location, {}) catch unreachable;
    flashNeighbors(octopi, location, flashed);
}

fn flashNeighbors(octopi: [][]u8, location: Location, flashed: *std.AutoHashMap(Location, void)) void {
    if (location.up()) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.left()) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.right(octopi)) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.down(octopi)) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.upLeft()) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.upRight(octopi)) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.downLeft(octopi)) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }

    if (location.downRight(octopi)) |loc| {
        octopi[loc.row][loc.col] += 1;
        flashOctopus(octopi, loc, flashed);
    }
}

fn printGrid(grid: [][]u8) void {
    for (grid) |row| {
        for (row) |value| {
            print("{d}", .{value});
        }
        print("\n", .{});
    }
}

fn loadData(path: []const u8) ![][]u8 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var octopi: [][]u8 = try allocator.alloc([]u8, lines.len);
    for (lines) |row, row_index| {
        octopi[row_index] = try allocator.alloc(u8, row.len);

        for (row) |value, col_index| {
            octopi[row_index][col_index] = try std.fmt.charToDigit(value, 10);
        }
    }

    return octopi;
}
