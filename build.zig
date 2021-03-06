const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Optional user selected target platform and optimizations
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("colorz", "src/main.zig");
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.install();

    const tests = b.addTest("src/tests.zig");
    tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&tests.step);

    const example = b.addExecutable("colors", "src/example.zig");
    example.setBuildMode(mode);

    const example_run = example.run();
    const example_step = b.step("example", "Run example program");
    example_step.dependOn(&example_run.step);

}
