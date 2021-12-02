const std = @import("std");
const mem = std.mem;
const fs = std.fs;

/// Load an array of u32 from file at path
/// TODO: make generic over type
pub fn loadData(allocator: *mem.Allocator, path: []const u8) ![]const u32 {
    const input = try std.fs.cwd().readFileAlloc(allocator, path, 1024 * 1024);
    var iterator = mem.tokenize(u8, input, "\n");
    var data = std.ArrayList(u32).init(allocator);

    while (iterator.next()) |value| {
        const number = try std.fmt.parseInt(u32, value, 10);
        try data.append(number);
    }

    return data.items;
}

/// Sum an array of integers
pub fn sum(array: []const u32) u32 {
    var result: u32 = 0;
    for (array) |value| {
        result += value;
    }

    return result;
}
