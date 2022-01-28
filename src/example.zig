const std = @import("std");
const print = std.debug.print;

const Palettes = @import("palettes.zig");

pub fn main() void {
    // 16 color table
    const p16 = Palettes.Palette16;
    const fg = @typeInfo(p16.fg).Struct.decls;
    const bg = @typeInfo(p16.bg).Struct.decls;

    // Print header and color names
    print("Palette16 colors\n\t\t", .{});
    inline for (fg) |v| {
        print(".{s}\t", .{v.name});
    }

    // Print field values for .fg
    print("\n.Foreground:\t", .{});
    inline for (fg) |v| {
        print("{s}MM\t", .{@field(p16.fg, v.name)});
    }
    print("{s}\n", .{Palettes.Mode.r});

    // Print field values for .bg
    print(".Background:\t", .{});
    inline for (bg) |v| {
        print("{s}  \t", .{@field(p16.bg, v.name)});
    }
    print("{s}\n\n", .{Palettes.Mode.r});

    // 256 color table
    const p256 = Palettes.Palette256;

    print("Palette256.Foreground dim/default colors\n", .{});
    print256ColorTable(p256.Foreground, Palettes.Mode.dim ++ "MM");
    print("\n", .{});

    print("Palette256.Foreground bold/bright colors\n", .{});
    print256ColorTable(p256.Foreground, Palettes.Mode.bold ++ "MM");
    print("\n", .{});

    print("Palette256.Background colors\n", .{});
    print256ColorTable(p256.Background, "  ");
}

fn print256ColorTable(array: [256][11]u8, placeholder: []const u8) void {
    const row_len = 16;

    var i: usize = 0;
    while (i < array.len) : (i += 1) {
        if (i == 0) {
            var j: usize = 0;
            print("   +\t", .{});
            while (j < row_len) : (j += 1) {
                print("{d:>2} ", .{j});
            }
        }
        if (@rem(i, row_len) == 0) {
            print("\n{s}{d:>4}\t", .{ Palettes.Mode.reset, i });
        }
        print("{s}{s}{s} ", .{ array[i], placeholder, Palettes.Mode.reset });
    }
    print("{s}\n", .{Palettes.Mode.reset});
}
