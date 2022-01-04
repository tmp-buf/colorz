const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

const colorfmt = @import("main.zig");

test "colorFormat function" {
    const s1 = "<red>Red<r>";
    const s2 = "\x1b[31mRed\x1b[0m";
    assert(std.mem.eql(u8, colorfmt.colorFormat(s1), s2));

    print("{s}\n", .{colorfmt.colorFormat("<green><b>[OK]<r> Color test <b>passed!<r>")});
}
