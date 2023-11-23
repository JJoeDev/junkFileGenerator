const std = @import("std");

fn ask_user() !u16 {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var writeBuf: [10]u8 = undefined;

    try stdout.print("Please input a number from 0 to 65530: ", .{});

    if (try stdin.readUntilDelimiterOrEof(writeBuf[0..], '\n')) |userInput| {
        return std.fmt.parseInt(u16, userInput, 10); // Parse to 16 bit base 10 unsigned int
    } else {
        return error.InvalidParam;
    }
}

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    const file = try std.fs.cwd().createFile(
        "JunkFile.txt",
        .{ .read = true },
    );
    defer file.close();

    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.os.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const random = prng.random();

    const size = try ask_user();

    const allocator = std.heap.page_allocator;
    const junkBuf = try allocator.alloc(u8, size);
    defer allocator.free(junkBuf);

    var i: u32 = 0;
    while (i < size) : (i += 1) {
        junkBuf[i] = random.intRangeAtMost(u8, 0, 255);
    }

    const written = try file.write(junkBuf[0..junkBuf.len]);
    _ = written;

    try stdout.print("Junk has been written to JunkFile.txt\n\n", .{});
}
