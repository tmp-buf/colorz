const std = @import("std");
const palettes = @import("palettes.zig");
const assert = std.debug.assert;

/// Format `fmt` with ANSI color codes.
/// 16-color format:
/// - `<fg.black>`
/// - `<bg.blue>`
/// 256-color format:
/// - `<fg.88>`
/// - `<bg.255>`
/// Modes:
/// - `<b>`: Bold
/// - `<d>`: Dim
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
                const encoded = parseColorName(color_name);
                var orig = new_fmt_i;
                new_fmt_i += encoded.len;
                std.mem.copy(u8, new_fmt[orig..new_fmt_i], encoded);
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

fn parseColorName(comptime s: []const u8) []const u8 {
    const cmp = std.ascii.startsWithIgnoreCase;

    if (cmp(s, "fg.") == true) {
        const name = s[3..];
        if (std.ascii.isAlpha(name[0])) {
            // E.g.: fg.white
            return @field(palettes.Palette16.fg, name);
        } else if (std.ascii.isDigit(name[0])) {
            // E.g.: fg.32
            const index = std.fmt.parseInt(u8, name, 10) catch unreachable;
            return palettes.Palette256.fg[index][0..11];
        } else {
            @compileError("Unknown formatting: " ++ s);
        }
    } else if (cmp(s, "bg.") == true) {
        const name = s[3..];
        if (std.ascii.isAlpha(name[0])) {
            return @field(palettes.Palette16.bg, name);
        } else if (std.ascii.isDigit(name[0])) {
            const index = std.fmt.parseInt(u8, name, 10) catch unreachable;
            return palettes.Palette256.bg[index][0..11];
        } else {
            @compileError("Unknown formatting: " ++ s);
        }
    } else {
        return @field(palettes.Mode, s);
    }
}
