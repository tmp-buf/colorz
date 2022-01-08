const std = @import("std");
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
/// - `<r>`: Reset
pub fn colorFormat(comptime fmt: []const u8) []const u8 {
    comptime var new_fmt: [fmt.len * 4]u8 = undefined;
    comptime var new_fmt_i: usize = 0;

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
                const color_str = colorCodeOf(color_name);
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

/// Return corresponding ANSI color code for the comptime string `s`
fn colorCodeOf(comptime s: []const u8) []const u8 {
    const ED = "\x1b[";
    const encoded = col: {
        if (strEql(s, "black")) {
            break :col ED ++ "30m";
        } else if (strEql(s, "blue")) {
            break :col ED ++ "34m";
        } else if (strEql(s, "b")) {
            break :col ED ++ "1m";
        } else if (strEql(s, "d")) {
            break :col ED ++ "2m";
        } else if (strEql(s, "cyan")) {
            break :col ED ++ "36m";
        } else if (strEql(s, "green")) {
            break :col ED ++ "32m";
        } else if (strEql(s, "magenta")) {
            break :col ED ++ "35m";
        } else if (strEql(s, "red")) {
            break :col ED ++ "31m";
        } else if (strEql(s, "white")) {
            break :col ED ++ "37m";
        } else if (strEql(s, "yellow")) {
            break :col ED ++ "33m";
        } else if (strEql(s, "r")) {
            break :col ED ++ "0m";
        } else {
            @compileError("Invalid color name: " ++ s);
        }
    };

    return encoded;
}

/// Test for equality between two strings `s1` and `s2`.
fn strEql(s1: []const u8, s2: []const u8) bool {
    return std.mem.eql(u8, s1, s2);
}
