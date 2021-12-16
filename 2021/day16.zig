const std = @import("std");
const mem = std.mem;
const math = std.math;
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Timer = std.time.Timer;
const AllocatorError = mem.Allocator.Error;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const bytes = try loadData("data/day16.txt");
    try puzzle1(bytes);
    try puzzle2();
}

/// Answers
/// - Test: 31
/// - Input: 977
fn puzzle1(bytes: []u4) !void {
    var timer = try Timer.start();
    const bits = try convertToBits(bytes);
    print("[Day 16/Puzzle 1] processing input: {d} bits\n", .{bits.len});
    var versions: u32 = 0;
    _ = try readPacket(bits, &versions);
    print("[Day 16/Puzzle 1] {d} total versions in {d}\n", .{ versions, utils.seconds(timer.read()) });
}

fn puzzle2() !void {
    var timer = try Timer.start();
    print("[Day 16/Puzzle 2] not implemented in {d}\n", .{utils.seconds(timer.read())});
}

fn readPacket(bits: []u1, versions: *u32) AllocatorError!usize {
    var index: usize = 0;
    const version = try readNum(bits, &index, 3);
    const kind = try readNum(bits, &index, 3);
    versions.* += version;

    switch (kind) {
        4 => {
            index += try readNumberPacket(bits[index..]);
        },
        else => {
            index += try readOperatorPacket(bits[index..], versions);
        },
    }

    return index;
}

fn readNumberPacket(bits: []u1) !usize {
    var index: usize = 0;
    var num_bits = ArrayList(u1).init(allocator);
    defer num_bits.deinit();

    while (index < bits.len - 1) {
        const group = readBits(bits, &index, 5);

        // First bit indicates status
        try num_bits.append(group[1]);
        try num_bits.append(group[2]);
        try num_bits.append(group[3]);
        try num_bits.append(group[4]);

        if (group[0] == 0) break;
    }

    //const num = try toNum(num_bits.toOwnedSlice());
    //print("  => {d}\n", .{num});

    return index;
}

fn readOperatorPacket(bits: []u1, versions: *u32) !usize {
    var index: usize = 0;
    const length_type = readBit(bits, &index);

    if (length_type == 0) {
        const sub_packet_bit_count = try readNum(bits, &index, 15);
        const sub_packets = readBits(bits, &index, sub_packet_bit_count);
        var sub_index: usize = 0;
        while (sub_index < sub_packet_bit_count) {
            sub_index += try readPacket(sub_packets[sub_index..], versions);
        }
    } else {
        const remaining_packets = try readNum(bits, &index, 11);
        var read_packets: usize = 0;
        while (read_packets < remaining_packets) : (read_packets += 1) {
            index += try readPacket(bits[index..], versions);
        }
    }

    return index;
}

fn readBit(bits: []u1, index: *usize) u1 {
    const start = index.*;
    index.* += 1;
    return bits[start];
}

fn readBits(bits: []u1, index: *usize, len: usize) []u1 {
    const start = index.*;
    const end = start + len;
    index.* += len;
    return bits[start..end];
}

fn readNum(bits: []u1, index: *usize, len: usize) !u32 {
    return try toNum(readBits(bits, index, len));
}

const OperatorResult = struct { num: u32, bits: bool };

const ParseErrors = error{
    Invalid,
};

fn toNum(bits: []const u1) !u32 {
    var num: u32 = 0;
    var index: usize = 0;
    while (index < bits.len) : (index += 1) {
        const value = @intCast(u32, bits[index]);
        num |= value << @intCast(u5, bits.len - 1 - index);
    }

    return num;
}

test "toNum" {
    const num0 = try toNum(&[_]u1{0});
    const num1 = try toNum(&[_]u1{1});
    const num2 = try toNum(&[_]u1{ 1, 0 });
    const num4 = try toNum(&[_]u1{ 1, 0, 0 });
    const num15 = try toNum(&[_]u1{ 1, 1, 1, 1 });

    try std.testing.expect(num0 == 0);
    try std.testing.expect(num1 == 1);
    try std.testing.expect(num2 == 2);
    try std.testing.expect(num4 == 4);
    try std.testing.expect(num15 == 15);
}

fn convertToBits(bytes: []u4) ![]u1 {
    var bits = ArrayList(u1).init(allocator);
    defer bits.deinit();

    for (bytes) |byte| {
        try bits.append(@intCast(u1, (byte & 0b1000) >> 3));
        try bits.append(@intCast(u1, (byte & 0b0100) >> 2));
        try bits.append(@intCast(u1, (byte & 0b0010) >> 1));
        try bits.append(@intCast(u1, byte & 0b0001));
    }

    return bits.toOwnedSlice();
}

fn loadData(path: []const u8) ![]u4 {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var bytes = ArrayList(u4).init(allocator);
    defer bytes.deinit();

    for (lines) |line| {
        for (line) |character| {
            const buf = [_]u8{character};
            const num = try std.fmt.parseInt(u4, &buf, 16);
            try bytes.append(num);
        }
    }

    return bytes.toOwnedSlice();
}
