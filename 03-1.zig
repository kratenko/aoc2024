const std = @import("std");
const data = @embedFile("03.input");
//const data = @embedFile("03.test-input");
const ArrayList = std.ArrayList;
const RegEx = @import("regex.zig").Regex;

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

    var splits = std.mem.splitScalar(u8, data, '\n');
    var rem = try RegEx.compile(allocator, "mul\\((\\d{1,3}),(\\d{1,3})\\)");
    var sum: i64 = 0;
    while (splits.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var pos: usize = 0;
        var capx = (try rem.captures(line[pos..]));
        while (capx != null) {
            const cap = capx.?;
            const sl = (cap.boundsAt(0)).?;
            pos += sl.upper;
            const f1  = try std.fmt.parseInt(i64, cap.sliceAt(1).?, 10);
            const f2  = try std.fmt.parseInt(i64, cap.sliceAt(2).?, 10);
            const prod = f1 * f2;
            sum += prod;

            capx = (try rem.captures(line[pos..]));
        }
    }
    std.debug.print("sum: {d}\n", .{sum});
}
