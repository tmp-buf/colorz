const std = @import("std");
const print = std.debug.print;

const Palettes = @import("palettes.zig");

pub fn main() void {
    const p256 = Palettes.Palette256;

    print("Palette256.Foreground dim/default colors\n", .{});
    printColorTable(p256.Foreground, Palettes.Mode.Dim ++ "MM");
    print("\n", .{});

    print("Palette256.Foreground bold/bright colors\n", .{});
    printColorTable(p256.Foreground, Palettes.Mode.Bold ++ "MM");
    print("\n", .{});

    print("Palette256.Background colors\n", .{});
    printColorTable(p256.Background, "  ");
}

fn printColorTable(array: [256][11]u8, placeholder: []const u8) void {
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
            print("\n{s}{d:>4}\t", .{ Palettes.Mode.Reset, i });
        }
        print("{s}{s}{s} ", .{ array[i], placeholder, Palettes.Mode.Reset });
    }
    print("{s}\n", .{Palettes.Mode.Reset});
}
