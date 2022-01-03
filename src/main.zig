const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

/// Format `fmt` with the corresponding ANSI color codes.
/// Valid colors:
/// - `<black>`
/// - `<blue>`
/// - `<cyan>`
/// - `<green>`
/// - `<magenta>`
/// - `<red>`
/// - `<white>`
/// - `<yellow>`
/// - `<b>`: Bold mode
/// - `<d>`: Dim mode
/// - `<r>`, `</r>`: Reset
pub fn colorFormat(comptime fmt: []const u8) []const u8 {
    comptime var new_fmt: [fmt.len * 4]u8 = undefined;
    comptime var new_fmt_i: usize = 0;
    const ED = "\x1b[";

    // TODO: Stress test to see if the line below is necessary
    @setEvalBranchQuota(9999);

    comptime var i: usize = 0;
    comptime while (i < fmt.len) {
        const c = fmt[i];
        switch (c) {
            '>' => {
                i += 1;
            },
            '<' => {
                i += 1;
                var start: usize = i;

                // Find closing bracket
                while (i < fmt.len and fmt[i] != '>') : (i += 1) {}

                const color_name = fmt[start..i];
                const color_str = color_picker: {
                    if (strEql(color_name, "black")) {
                        break :color_picker ED ++ "30m";
                    } else if (strEql(color_name, "blue")) {
                        break :color_picker ED ++ "34m";
                    } else if (strEql(color_name, "b")) {
                        break :color_picker ED ++ "1m";
                    } else if (strEql(color_name, "d")) {
                        break :color_picker ED ++ "2m";
                    } else if (strEql(color_name, "cyan")) {
                        break :color_picker ED ++ "36m";
                    } else if (strEql(color_name, "green")) {
                        break :color_picker ED ++ "32m";
                    } else if (strEql(color_name, "magenta")) {
                        break :color_picker ED ++ "35m";
                    } else if (strEql(color_name, "red")) {
                        break :color_picker ED ++ "31m";
                    } else if (strEql(color_name, "white")) {
                        break :color_picker ED ++ "37m";
                    } else if (strEql(color_name, "yellow")) {
                        break :color_picker ED ++ "33m";
                    } else if (strEql(color_name, "r")) {
                        break :color_picker ED ++ "0m";
                    } else {
                        @compileError("Invalid color name: " ++ color);
                    }
                };
                var orig = new_fmt_i;
                new_fmt_i += color_str.len;
                std.mem.copy(u8, new_fmt[orig..new_fmt_i], color_str);
            },

            else => {
                new_fmt[new_fmt_i] = fmt[i];
                new_fmt_i += 1;
                i += 1;
            },
        }
    };

    return new_fmt[0..new_fmt_i];
}

/// Test for equality between `s1` and `s2`.
fn strEql(s1: []const u8, s2: []const u8) bool {
    return std.mem.eql(u8, s1, s2);
}

test "strEql function" {
    const s1 = "function";
    const s2 = s1;
    try testing.expect(strEql(s1, s2) == true);
    try testing.expect(strEql(s1, "Function") == false);
}

test "colorFormat function" {
    const s1 = "<red>Red<r>";
    const s2 = "\x1b[31mRed\x1b[0m";
    assert(strEql(colorFormat(s1), s2));

    std.debug.print("{s}\n", .{colorFormat("<green><b>[OK]<r> Color test <b>passed!<r>")});
}
