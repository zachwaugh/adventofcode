const std = @import("std");
const mem = std.mem;
const math = std.math;
const utils = @import("utils.zig");
const allocator = std.heap.page_allocator;
const print = @import("std").debug.print;

pub fn main() !void {
    const graph = try loadData("data/day12.txt");
    try puzzle1(graph);
    try puzzle2(graph);
}

/// Answers
/// - Test: 10
/// - Input: 4775
fn puzzle1(graph: []Edge) !void {
    print("[Day 12/Puzzle 1] processing graph with {d} edges\n", .{graph.len});
    var visited = std.StringHashMap(void).init(allocator);
    const paths = findPaths("start", graph, &visited);
    print("[Day 12/Puzzle 1] {d} paths found\n", .{paths.len});
}

/// Answers
/// - Test: 36
/// - Input: 152480
fn puzzle2(graph: []Edge) !void {
    print("[Day 12/Puzzle 2] processing graph with {d} edges\n", .{graph.len});
    var visited = std.StringHashMap(u8).init(allocator);
    const paths = findPaths2("start", graph, &visited);
    print("[Day 12/Puzzle 2] {d} paths found\n", .{paths.len});
}

fn findPaths(start: []const u8, graph: []Edge, visited: *std.StringHashMap(void)) [][]Edge {
    if (!isUppercase(start)) {
        visited.put(start, {}) catch unreachable;
    }

    const edges = findEdges(start, graph) catch unreachable;
    var paths = std.ArrayList([]Edge).init(allocator);

    for (edges) |edge| {
        if (visited.get(edge.end) != null) continue;

        if (mem.eql(u8, edge.end, "end")) {
            var path = std.ArrayList(Edge).init(allocator);
            path.append(edge) catch unreachable;
            paths.append(path.toOwnedSlice()) catch unreachable;
        } else {
            var visited_copy = visited.clone() catch unreachable;
            const child_paths = findPaths(edge.end, graph, &visited_copy);
            for (child_paths) |child_path| {
                var path = std.ArrayList(Edge).init(allocator);
                path.append(edge) catch unreachable;

                for (child_path) |child_edge| {
                    path.append(child_edge) catch unreachable;
                }

                paths.append(path.toOwnedSlice()) catch unreachable;
            }
        }
    }

    return paths.toOwnedSlice();
}

fn findPaths2(start: []const u8, graph: []Edge, visited: *std.StringHashMap(u8)) [][]Edge {
    if (isLowercase(start)) {
        if (visited.get(start)) |count| {
            visited.put(start, count + 1) catch unreachable;
        } else {
            visited.put(start, 1) catch unreachable;
        }
    }

    const edges = findEdges(start, graph) catch unreachable;
    var paths = std.ArrayList([]Edge).init(allocator);

    for (edges) |edge| {
        if (!isVisitable(edge.end, visited)) continue;

        if (mem.eql(u8, edge.end, "end")) {
            var path = std.ArrayList(Edge).init(allocator);
            path.append(edge) catch unreachable;
            paths.append(path.toOwnedSlice()) catch unreachable;
        } else {
            var visited_copy = visited.clone() catch unreachable;
            const child_paths = findPaths2(edge.end, graph, &visited_copy);
            for (child_paths) |child_path| {
                var path = std.ArrayList(Edge).init(allocator);
                path.append(edge) catch unreachable;

                for (child_path) |child_edge| {
                    path.append(child_edge) catch unreachable;
                }

                paths.append(path.toOwnedSlice()) catch unreachable;
            }
        }
    }

    return paths.toOwnedSlice();
}

fn isVisitable(cave: []const u8, visited: *std.StringHashMap(u8)) bool {
    if (isUppercase(cave)) return true;
    if (mem.eql(u8, cave, "start")) return false;

    if (visited.get(cave)) |count| {
        if (count >= 2) {
            return false;
        } else {
            // Only allow a single small cave to be visited twice
            var iterator = visited.iterator();
            while (iterator.next()) |entry| {
                if (isLowercase(entry.key_ptr.*) and entry.value_ptr.* >= 2) {
                    return false;
                }
            }

            return true;
        }
    } else {
        // Not visited yet
        return true;
    }
}

fn findEdges(cave: []const u8, graph: []Edge) ![]Edge {
    var edges = std.ArrayList(Edge).init(allocator);

    for (graph) |edge| {
        if (edge.has_vertex(cave)) {
            try edges.append(Edge{ .start = cave, .end = edge.vertex(cave) });
        }
    }

    return edges.toOwnedSlice();
}

const Edge = struct {
    start: []const u8,
    end: []const u8,

    fn has_vertex(self: Edge, name: []const u8) bool {
        return mem.eql(u8, self.start, name) or mem.eql(u8, self.end, name);
    }

    fn vertex(self: Edge, excluding: []const u8) []const u8 {
        if (mem.eql(u8, self.start, excluding)) {
            return self.end;
        } else {
            return self.start;
        }
    }
};

fn loadData(path: []const u8) ![]Edge {
    const lines = try utils.readLines(allocator, path);
    defer allocator.free(lines);

    var edges = std.ArrayList(Edge).init(allocator);
    defer edges.deinit();

    var id: u32 = 0;

    for (lines) |line| {
        var iterator = std.mem.split(u8, line, "-");
        const start = iterator.next().?;
        const end = iterator.next().?;
        const edge = Edge{ .start = start, .end = end };

        try edges.append(edge);
        id += 1;
    }

    return edges.toOwnedSlice();
}

/// Only looking at first character, good enough for our use case
fn isUppercase(string: []const u8) bool {
    if (string.len == 0) return false;
    return string[0] >= 'A' and string[0] <= 'Z';
}

fn isLowercase(string: []const u8) bool {
    return !isUppercase(string);
}
