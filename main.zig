const std = @import("std");

fn ask_user() !i64 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var buf: [10]u8 = undefined;

    try stdout.print("Guess a number from 1 to 100: ", .{}); // The try means it could return an error and if so it will be passed to the caller of this function (because of !)

    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return std.fmt.parseInt(i64, user_input, 10); // Parse to 64 bit int in base 10
    } else {
        return error.InvalidParam;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    // Psudo random number generator with random seed
    var prand = std.rand.DefaultPrng.init(blk: { // blk is used to create a scope for variables
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed; // Break the blk block and use seed as the default value
    });

    const value = prand.random().intRangeAtMost(i64, 1, 100);
    while (true) {
        const guess = try ask_user();
        if (guess == value) {
            break;
        }
        try stdout.print("Too {s}\n", .{if (guess < value) "low" else "high"});
    }
    try stdout.print("Correct!\n", .{});
}
