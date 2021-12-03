// zig run day2.zig
const std = @import("std");
const mem = std.mem;
const utils = @import("utils.zig");

const DataError = error{InvalidData};

const Command = struct {
    direction: Direction,
    distance: u32,

    const Direction = enum { up, down, forward };
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const commands = try loadData(allocator, "data/day2.txt");
    puzzle1(commands);
    puzzle2(commands);
}

fn puzzle1(commands: []const Command) void {
    var horizontal_position: u32 = 0;
    var depth: u32 = 0;

    for (commands) |command| {
        switch (command.direction) {
            .up => depth -= command.distance,
            .down => depth += command.distance,
            .forward => horizontal_position += command.distance,
        }
    }

    const result = horizontal_position * depth;
    std.debug.print("[Day 2/Puzzle 1] horizontal position: {}, depth: {}, result: {}\n", .{ horizontal_position, depth, result });
}

fn puzzle2(commands: []const Command) void {
    var aim: u32 = 0;
    var horizontal_position: u32 = 0;
    var depth: u32 = 0;

    for (commands) |command| {
        switch (command.direction) {
            .up => aim -= command.distance,
            .down => aim += command.distance,
            .forward => {
                horizontal_position += command.distance;
                depth += aim * command.distance;
            },
        }
    }

    const result = horizontal_position * depth;
    std.debug.print("[Day 2/Puzzle 2] aim: {}, horizontal position: {}, depth: {}, result: {}\n", .{ aim, horizontal_position, depth, result });
}

fn loadData(allocator: *mem.Allocator, path: []const u8) ![]const Command {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var commands = std.ArrayList(Command).init(allocator);
    defer commands.deinit();

    for (lines) |line| {
        var parts = mem.split(u8, line, " ");
        const direction_part = parts.next() orelse return DataError.InvalidData;
        const direction = directionFromString(direction_part) orelse return DataError.InvalidData;
        const distance_part = parts.next() orelse return DataError.InvalidData;
        const distance = try std.fmt.parseInt(u32, distance_part, 10);
        const command = Command{ .direction = direction, .distance = distance };
        try commands.append(command);
    }

    return commands.toOwnedSlice();
}

fn directionFromString(string: []const u8) ?Command.Direction {
    if (mem.eql(u8, string, "up")) {
        return .up;
    } else if (mem.eql(u8, string, "down")) {
        return .down;
    } else if (mem.eql(u8, string, "forward")) {
        return .forward;
    } else {
        return null;
    }
}
