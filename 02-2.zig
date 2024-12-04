const std = @import("std");
const data = @embedFile("02.input");
//const data = @embedFile("02.test-input");
const ArrayList = std.ArrayList;

pub fn abs(n: i32) i32 {
    if (n < 0) {
        return -n;
    }
    return n;
}

pub fn sign(n: i32) i32 {
    if (n < 0) {
        return -1;
    }
    if (n > 0) {
        return 1;
    }
    return 0;
}

pub fn isSafe(nums: ArrayList(i32), skip: i32) bool {
    var last: i32 = -1;
    var dir: i32 = 0;
    for (nums.items, 0..) |n, i| {
        if (i == skip) {
            continue;
        }
        if (last == -1) {
            last = n;
            continue;
        }
        const d = n - last;
        last = n;
        if (d == 0 or abs(d) > 3) {
            return false;
        }
        if (dir == 0) {
            dir = sign(d);
        } else if (dir != sign(d)) {
            return false;
        }
    }
    return true;
}

pub fn isSafeDampened(nums: ArrayList(i32)) bool {
    if (isSafe(nums, -1)) {
        return true;
    }
    for (0..nums.items.len) |i| {
        if (isSafe(nums, @as(i32, @intCast(i)))) {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var safe: i32 = 0;
    var splits = std.mem.splitScalar(u8, data, '\n');
    while (splits.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var nums = std.mem.splitScalar(u8, line, ' ');
        var nn = ArrayList(i32).init(allocator);
        while (nums.next()) |num| {
            const n = try std.fmt.parseInt(i32, num, 10);
            try nn.append(n);
        }
        if (isSafeDampened(nn)) {
            safe += 1;
        }
    }
    std.debug.print("safe: {d}\n", .{safe});
}