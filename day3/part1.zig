const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn();

    var buff_curr = std.mem.zeroes([4 * 1024]u8);
    var buff_prev = std.mem.zeroes([4 * 1024]u8);
    var buff_next = std.mem.zeroes([4 * 1024]u8);

    var prev_line: ?[]u8 = null;
    var next_line: ?[]u8 = null;
    var line = (try stdin.reader().readUntilDelimiterOrEof(&buff_curr, '\n')).?;

    var sum: u64 = 0;
    while (true) {
        next_line = try stdin.reader().readUntilDelimiterOrEof(&buff_next, '\n');
        std.debug.print("Prev: {?s}\nLine: {s}\nNext: {?s}\n\n", .{prev_line, line, next_line});
        
        var offset: usize = 0;
        search: while (true) {
            const num_start = std.mem.indexOfAnyPos(u8, line, offset, "0123456789") orelse break;
            const num_end = std.mem.indexOfNonePos(u8, line, num_start+1, "0123456789") orelse num_start+1;

            const search_start = if (num_start > 0) num_start-1 else 0;
            const search_end = @min(num_end+1,line.len);

            const lines = [_]?[]u8{prev_line, line, next_line};
            for (0..lines.len) |lno| {
                if (lines[lno] == null) {
                    continue;
                }
                if (std.mem.indexOfNone(u8, lines[lno].?[search_start..search_end], ".0123456789")) |_| {
                    sum += try std.fmt.parseInt(u64, line[num_start..num_end], 10);
                    break :search;
                }
            }

            offset += num_end;
        }

        std.mem.copyForwards(u8, &buff_prev, line);
        prev_line = buff_prev[0..line.len];
        if (next_line) |l| {
            std.mem.copyForwards(u8, &buff_curr, l);
            line = buff_curr[0..l.len];
        } else {
            break;
        }
    }

    std.debug.print("Sum: {d}\n", .{sum});
}
