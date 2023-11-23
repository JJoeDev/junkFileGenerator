const std = @import("std");

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

    var junkBuffer: [2048]u8 = undefined;

    var i: u16 = 0;
    while (i < 2048) : (i += 1) {
        junkBuffer[i] = random.intRangeAtMost(u8, 0, 255);
    }

    const written = try file.write(junkBuffer[0..junkBuffer.len]);
    _ = written;

    try stdout.print("Junk has been written to JunkFile.txt\n", .{});
}
