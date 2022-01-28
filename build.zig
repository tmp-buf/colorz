const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("colorz", "src/main.zig");
    lib.setBuildMode(mode);
    lib.install();

    const tests = b.addTest("src/tests.zig");
    tests.setBuildMode(mode);

    const example = b.addExecutable("colors", "src/example.zig");
    example.setBuildMode(mode);

    const example_run = example.run();
    const example_step = b.step("example", "Run example program");
    example_step.dependOn(&example_run.step);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);
}
