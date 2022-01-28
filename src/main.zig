const std = @import("std");
const palettes = @import("palettes.zig");
const assert = std.debug.assert;

/// Format `fmt` with ANSI color codes.
/// Valid color formats:
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
    return @field(Palette, s);
}
