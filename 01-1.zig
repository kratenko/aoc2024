const std = @import("std");
const data = @embedFile("01.input");
//const data = @embedFile("01.test-input");
const ArrayList = std.ArrayList;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var splits = std.mem.splitScalar(u8, data, '\n');
    var left = ArrayList(i32).init(allocator);
    var right = ArrayList(i32).init(allocator);
    while (splits.next()) |line| {
//        std.debug.print("{s}\n", .{line});
        if (line.len == 5) {
            const l = std.fmt.parseInt(i32, line[0..1], 10) catch 0;
            const r = std.fmt.parseInt(i32, line[4..5], 10) catch 0;
//            std.debug.print("l: {d}\n", .{l});
//            std.debug.print("r: {d}\n", .{r});
            try left.append(l);
            try right.append(r);
        }
        if (line.len == 13) {
            const l = std.fmt.parseInt(i32, line[0..5], 10) catch 0;
            const r = std.fmt.parseInt(i32, line[8..13], 10) catch 0;
            try left.append(l);
            try right.append(r);
        }
    }
    std.mem.sort(i32, left.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, std.sort.asc(i32));
    var dist: i32 = 0;
    for (left.items, right.items) |l, r| {
        std.debug.print("{d}   {d}\n", .{l, r});
        var d = l - r;
        if (d < 0) {
            d = -d;
        }
        dist += d;
    }
    std.debug.print("dist: {d}\n", .{dist});
}