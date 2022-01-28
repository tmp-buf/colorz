const std = @import("std");

/// Modes' escape codes.
pub const Mode = struct {
    pub const r = "\x1b[0m";
    pub const b = "\x1b[1m";
    pub const d = "\x1b[2m";
    pub const n = "\x1b[3m";
    pub const u = "\x1b[4m";

    // Aliases
    pub const Reset = r;
    pub const Underline = u;
    pub const Negate = n;
    pub const Bold = b;
    pub const Bright = b;
    pub const Dim = d;
};

/// Palette struct with 16 colors.
/// * Foregound colors: 30-37
/// * Background colors: 40-47
/// Example, red foreground: `\x1b[31m`
/// Example, red background: `\x1b[41m`
pub const Palette16 = struct {
    pub const Foreground = struct {
        pub const Black = "\x1b[30m";
        pub const Red = "\x1b[31m";
        pub const Green = "\x1b[32m";
        pub const Yellow = "\x1b[33m";
        pub const Blue = "\x1b[34m";
        pub const Magenta = "\x1b[35m";
        pub const Cyan = "\x1b[36m";
        pub const White = "\x1b[37m";
    };

    pub const Background = struct {
        pub const Black = "\x1b[40m";
        pub const Red = "\x1b[41m";
        pub const Green = "\x1b[42m";
        pub const Yellow = "\x1b[43m";
        pub const Blue = "\x1b[44m";
        pub const Magenta = "\x1b[45m";
        pub const Cyan = "\x1b[46m";
        pub const White = "\x1b[47m";
    };

    // Aliases
    pub const Fg = Foreground;
    pub const Bg = Background;
};

/// Palette struct with 256 colors.
/// * Foreground and background colors: 0-255
/// * Font color is prepended with 38;5;
/// * Background color is prepended with 48;5;
/// Example, Foreground[196]: `\x1b[38;5;196m`
/// Example, Background[123]: `\x1b[48;5;123m`
pub const Palette256 = struct {
    const FG_EC = "\x1b[38;5;";
    const BG_EC = "\x1b[48;5;";

    pub const Foreground = blk: {
        var colors: [256][11]u8 = undefined;
        var i: usize = 0;
        inline while (i < colors.len) : (i += 1) {
            _ = std.fmt.bufPrint(colors[i][0..], FG_EC ++ "{d:0>3}m", .{i}) catch unreachable;
        }
        break :blk colors;
    };

    pub const Background = blk: {
        var colors: [256][11]u8 = undefined;
        var i: usize = 0;
        inline while (i < colors.len) : (i += 1) {
            _ = std.fmt.bufPrint(colors[i][0..], BG_EC ++ "{d:0>3}m", .{i}) catch unreachable;
        }
        break :blk colors;
    };

    // Aliases
    pub const Fg = Foreground;
    pub const Bg = Background;
};
