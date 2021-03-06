const std = @import("std");
const mem = std.mem;
const math = std.math;
const fmt = std.fmt;
const ArrayList = std.ArrayList;
const Timer = std.time.Timer;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    // TEST: target area: x=20..30, y=-10..-5
    //const target = Target{ .min_x = 20, .max_x = 30, .min_y = -10, .max_y = -5 };

    // INPUT: target area: x=248..285, y=-85..-56
    const target = Target{ .min_x = 248, .max_x = 285, .min_y = -85, .max_y = -56 };

    try puzzle1(target);
    try puzzle2(target);
}

/// Answers
/// - Test: 6,9 => 45
/// - Input: 22,84 => 3570
fn puzzle1(target: Target) !void {
    var timer = try Timer.start();
    print("[Day 17/Puzzle 1] finding velocity to target: {}\n", .{target});
    const velocity = findVelocity(target);
    print("[Day 17/Puzzle 1] velocity found: {} in {d}\n", .{ velocity, utils.seconds(timer.read()) });
}

/// Answers
/// - Test: 112
/// - Input: 1919
fn puzzle2(target: Target) !void {
    var timer = try Timer.start();
    print("[Day 17/Puzzle 2] finding all velocities to target: {}\n", .{target});
    const velocities = findAllVelocities(target);
    print("[Day 17/Puzzle 2] {d} velocities found in {d}\n", .{ velocities, utils.seconds(timer.read()) });
}

fn findVelocity(target: Target) !?Point {
    const max_x: i32 = 100;
    const max_y: i32 = 100;
    const min_y: i32 = -100;

    var x: i32 = 0;
    var y: i32 = min_y;
    var best_y: i32 = 0;
    var best_velocity: ?Point = null;

    while (x < max_x) : (x += 1) {
        while (y < max_y) : (y += 1) {
            const velocity = Point{ .x = x, .y = y };
            if (checkVelocity(velocity, target)) |velocity_max_y| {
                if (velocity_max_y > best_y) {
                    best_y = velocity_max_y;
                    best_velocity = velocity;
                }
            }
        }

        y = min_y;
    }

    print("Max y of {d} reached with {}\n", .{ best_y, best_velocity });
    return best_velocity;
}

fn findAllVelocities(target: Target) !u32 {
    // These numbers are guesses for the bounds,
    // but would be better to narrow it down
    const max_x: i32 = 1000;
    const max_y: i32 = 1000;
    const min_y: i32 = -1000;

    var x: i32 = 0;
    var y: i32 = min_y;
    var count: u32 = 0;

    while (x < max_x) : (x += 1) {
        while (y < max_y) : (y += 1) {
            const velocity = Point{ .x = x, .y = y };
            if (checkVelocity(velocity, target) != null) {
                count += 1;
            }
        }

        y = min_y;
    }

    return count;
}

fn checkVelocity(velocity: Point, target: Target) ?i32 {
    const start = Point{ .x = 0, .y = 0 };
    var position = start;
    var current_velocity = velocity;
    var step: u32 = 0;
    var max_y: i32 = 0;

    while (!target.contains(position)) : (step += 1) {
        position.x += current_velocity.x;
        position.y += current_velocity.y;

        if (position.y > max_y) {
            max_y = position.y;
        }

        if (current_velocity.x > 0) current_velocity.x -= 1;
        current_velocity.y -= 1;

        if (target.below(position)) {
            return null;
        }
    }

    return max_y;
}

const Target = struct {
    min_x: i32,
    max_x: i32,
    min_y: i32,
    max_y: i32,

    fn contains(self: Target, point: Point) bool {
        return point.x >= self.min_x and point.x <= self.max_x and point.y >= self.min_y and point.y <= self.max_y;
    }

    fn below(self: Target, point: Point) bool {
        return point.y < self.min_y;
    }
};

const Point = struct { x: i32, y: i32 };
