const std = @import("std");
const print = std.debug.print;
const assert = std.debug.assert;

const colorfmt = @import("main.zig");

test "Formatting with colorFormat function" {
    const s1 = "<red>Red<r>";
    const s2 = "\x1b[31mRed\x1b[0m";
    assert(std.mem.eql(u8, colorfmt.colorFormat(s1), s2));

    print("{s}\n", .{colorfmt.colorFormat("<green><b>[OK]<r>")});
}

test "Formatting with Palette struct" {
    const p = colorfmt.Palette;
    const s1 = "\x1b[32m" ++ "\x1b[1m" ++ "[OK]" ++ "\x1b[0m";
    const s2 = p.green ++ p.bold ++ "[OK]" ++ p.reset;
    assert(std.mem.eql(u8, s1, s2));
    print("{s}\n", .{s1});

}
