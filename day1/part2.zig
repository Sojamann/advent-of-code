const std = @import("std");

fn isMatch(buff: []u8) ?u8 {
    return switch (buff[0]) {
        '0'...'9' => buff[0],
        else => {
            if (std.mem.startsWith(u8, buff, "zero")) return '0';
            if (std.mem.startsWith(u8, buff, "one")) return '1';
            if (std.mem.startsWith(u8, buff, "two")) return '2';
            if (std.mem.startsWith(u8, buff, "three")) return '3';
            if (std.mem.startsWith(u8, buff, "four")) return '4';
            if (std.mem.startsWith(u8, buff, "five")) return '5';
            if (std.mem.startsWith(u8, buff, "six")) return '6';
            if (std.mem.startsWith(u8, buff, "seven")) return '7';
            if (std.mem.startsWith(u8, buff, "eight")) return '8';
            if (std.mem.startsWith(u8, buff, "nine")) return '9';

            return null;
        },
    };
}

pub fn main() !void {
    const stdin = std.io.getStdIn();

    var buff = std.mem.zeroes([4 * 1024]u8);

    var sum: u64 = 0;
    while (true) {
        const line = try stdin.reader().readUntilDelimiterOrEof(&buff, '\n') orelse break;

        var joined = std.mem.zeroes([2]u8);
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            if (isMatch(line[i..])) |digit| {
                joined[0] = digit;
                break;
            }
        }
        i = line.len - 1;
        while (i >= 0) : (i -= 1) {
            if (isMatch(line[i..])) |digit| {
                joined[1] = digit;
                break;
            }
        }

        const parsed = try std.fmt.parseInt(u8, &joined, 10);
        sum += parsed;
    }

    std.debug.print("Sum: {d}\n", .{sum});
}
