const std = @import("std");
const assert = std.debug.assert;
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
    const bits = try convertToBits(bytes);
    try puzzle1(bits);
    try puzzle2(bits);
}

/// Answers
/// - Test: 31
/// - Input: 977
fn puzzle1(bits: []u1) !void {
    var timer = try Timer.start();
    print("[Day 16/Puzzle 1] processing input: {d} bits\n", .{bits.len});
    var index: usize = 0;
    const packet = try readPacket(bits, &index);
    const versions = packet.versions();
    print("[Day 16/Puzzle 1] {d} total versions in {d}\n", .{ versions, utils.seconds(timer.read()) });
}

/// Answers
/// - Input: 101501020883
fn puzzle2(bits: []u1) !void {
    var timer = try Timer.start();
    print("[Day 16/Puzzle 2] processing input: {d} bits\n", .{bits.len});
    var index: usize = 0;
    const packet = try readPacket(bits, &index);
    const result = packet.evaluate();
    print("[Day 16/Puzzle 1] result = {d} in {d}\n", .{ result, utils.seconds(timer.read()) });
}

fn readPacket(bits: []u1, index: *usize) AllocatorError!Packet {
    const version = try readNum(bits, index, 3);
    const operation = @intToEnum(Operation, try readNum(bits, index, 3));

    switch (operation) {
        Operation.number => {
            const number = try readNumberPacketValue(bits, index);
            return Packet{ .version = version, .operation = .number, .value = number };
        },
        else => {
            const sub_packets = try readOperatorSubPackets(bits, index);
            return Packet{ .version = version, .operation = operation, .packets = sub_packets };
        },
    }
}

fn readNumberPacketValue(bits: []u1, index: *usize) !u64 {
    var num_bits = ArrayList(u1).init(allocator);
    defer num_bits.deinit();

    while (index.* < bits.len - 1) {
        const group = readBits(bits, index, 5);

        // First bit indicates status
        try num_bits.append(group[1]);
        try num_bits.append(group[2]);
        try num_bits.append(group[3]);
        try num_bits.append(group[4]);

        if (group[0] == 0) break;
    }

    return try toNum(num_bits.toOwnedSlice());
}

fn readOperatorSubPackets(bits: []u1, index: *usize) ![]Packet {
    var packets = ArrayList(Packet).init(allocator);
    defer packets.deinit();

    const length_type = readBit(bits, index);

    if (length_type == 0) {
        const sub_packet_bit_count = try readNum(bits, index, 15);
        const sub_packets = readBits(bits, index, sub_packet_bit_count);
        var sub_index: usize = 0;
        while (sub_index < sub_packet_bit_count) {
            try packets.append(try readPacket(sub_packets, &sub_index));
        }
    } else {
        const remaining_packets = try readNum(bits, index, 11);
        var read_packets: usize = 0;
        while (read_packets < remaining_packets) : (read_packets += 1) {
            try packets.append(try readPacket(bits, index));
        }
    }

    return packets.toOwnedSlice();
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

fn readNum(bits: []u1, index: *usize, len: usize) !u64 {
    return try toNum(readBits(bits, index, len));
}

const Packet = struct {
    version: u64,
    operation: Operation,
    packets: ?[]Packet = null,
    value: ?u64 = null,

    fn evaluate(self: Packet) u64 {
        const values = self.sub_values();
        switch (self.operation) {
            .sum => {
                assert(values.len > 0);
                return utils.sum(u64, values);
            },
            .product => {
                assert(values.len > 0);
                return utils.product(u64, values);
            },
            .minimum => {
                assert(values.len > 0);
                return utils.min(u64, values);
            },
            .maximum => {
                assert(values.len > 0);
                return utils.max(u64, values);
            },
            .lessThan => {
                assert(values.len == 2);
                return if (values[0] < values[1]) 1 else 0;
            },
            .greaterThan => {
                assert(values.len == 2);
                return if (values[0] > values[1]) 1 else 0;
            },
            .equalTo => {
                assert(values.len == 2);
                return if (values[0] == values[1]) 1 else 0;
            },
            .number => {
                assert(values.len == 1);
                return values[0];
            },
        }
    }

    fn sub_values(self: Packet) []u64 {
        var values = ArrayList(u64).init(allocator);
        if (self.packets) |packets| {
            for (packets) |packet| {
                values.append(packet.evaluate()) catch unreachable;
            }
        } else if (self.value) |value| {
            values.append(value) catch unreachable;
        }

        return values.toOwnedSlice();
    }

    fn versions(self: Packet) u64 {
        var total: u64 = self.version;

        if (self.packets) |packets| {
            for (packets) |packet| {
                total += packet.versions();
            }
        }

        return total;
    }
};

const Operation = enum(u8) { sum, product, minimum, maximum, number, greaterThan, lessThan, equalTo };

const ParseErrors = error{
    Invalid,
};

fn toNum(bits: []const u1) !u64 {
    var num: u64 = 0;
    var index: usize = 0;
    while (index < bits.len) : (index += 1) {
        const value = @intCast(u64, bits[index]);
        num |= value << @intCast(u6, bits.len - 1 - index);
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
