const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn();

    var buff = std.mem.zeroes([4 * 1024]u8);

    var sum: u64 = 0;
    while (true) {
        const line = try stdin.reader().readUntilDelimiterOrEof(&buff, '\n') orelse break;

        const first = std.mem.indexOfAny(u8, line, "0123456789") orelse continue;
        const last = std.mem.lastIndexOfAny(u8, line, "0123456789") orelse continue;

        var joined = std.mem.zeroes([2]u8);
        joined[0] = line[first];
        joined[1] = line[last];

        const parsed = try std.fmt.parseInt(u8, &joined, 10);
        sum += parsed;
        std.debug.print("{d} - {c}-{c} :  {s}\n", .{ parsed, line[first], line[last], line });
    }

    std.debug.print("Sum: {d}\n", .{sum});
}
