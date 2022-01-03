const std = @import("std");
const testing = std.testing;

// Valid colors:
// <black>
// <blue>
// <cyan>
// <green>
// <magenta>
// <red>
// <white>
// <yellow>
// <b> - bold
// <d> - dim
// </r> - reset
// <r> - reset
fn colorFormat(comptime fmt: []const u8, comptime is_enabled: bool) []const u8 {
    comptime var new_fmt: [fmt.len * 4]u8 = undefined;
    comptime var new_fmt_i: usize = 0;
    const ED = "\x1b[";

    // @setEvalBranchQuota(9999);

    comptime var i: usize = 0;
    comptime while (i < fmt.len) {
        const c = fmt[i];
        switch (c) {
            '\\' => {
                i += 1;
                if (fmt.len < i) {
                    switch (fmt[i]) {
                        '<', '>' => {
                            i += 1;
                        },
                        else => {
                            new_fmt[new_fmt_i] = '\\';
                            new_fmt_i += 1;
                            new_fmt[new_fmt_i] = fmt[i];
                            new_fmt_i += 1;
                        },
                    }
                }
            },
            '>' => {
                i += 1;
            },
            '{' => {
                while (fmt.len > i and fmt[i] != '}') {
                    new_fmt[new_fmt_i] = fmt[i];
                    new_fmt_i += 1;
                    i += 1;
                }
            },
            '<' => {
                i += 1;
                var is_reset: bool = fmt[i] == '/';
                if (is_reset) i += 1;
                var start: usize = i;
                while (i < fmt.len and fmt[i] != '>') {
                    i += 1;
                }

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
                        is_reset = true;
                        break :color_picker "";
                    } else {
                        @compileError("Invalid color name passed: " ++ color_name);
                    }
                };
                var orig = new_fmt_i;

                if (is_enabled) {
                    if (!is_reset) {
                        orig = new_fmt_i;
                        new_fmt_i += color_str.len;
                        std.mem.copy(u8, new_fmt[orig..new_fmt_i], color_str);
                    } else {
                        const reset_sequence = "\x1b[0m";
                        orig = new_fmt_i;
                        new_fmt_i += reset_sequence.len;
                        std.mem.copy(u8, new_fmt[orig..new_fmt_i], reset_sequence);
                    }
                }
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
    try testing.expect(strEql(colorFormat(s1, true), s2));
}
