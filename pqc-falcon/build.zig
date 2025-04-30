const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // This creates a "module", which represents a collection of source files alongside
    // some compilation options, such as optimization mode and linked system libraries.
    // Every executable or library we compile will be based on one or more modules.
    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Now, we will create a static library based on the module we created above.
    // This creates a `std.Build.Step.Compile`, which is the build step responsible
    // for actually invoking the compiler.
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "pqc_falcon",
        .root_module = lib_mod,
    });
    lib.linkLibC();

    const make_falcon512 = b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-512/clean"), "CC=gcc" });
    lib.step.dependOn(&make_falcon512.step);

    // Headers
    lib.addIncludePath(b.path("../libs/PQClean/common"));
    lib.addIncludePath(b.path("../libs/PQClean/crypto_sign/falcon-512/clean"));
    // Objects
    lib.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-512/clean/libfalcon-512_clean.a"));
    // Source files
    lib.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/randombytes.c"),
        .flags = &.{"-std=c99"},
    });
    lib.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/fips202.c"),
        .flags = &.{"-std=c99"},
    });

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running `zig build`).
    b.installArtifact(lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    lib_unit_tests.step.dependOn(&make_falcon512.step);
    lib_unit_tests.linkLibC();

    // Headers
    lib_unit_tests.addIncludePath(b.path("../libs/PQClean/common"));
    lib_unit_tests.addIncludePath(b.path("../libs/PQClean/crypto_sign/falcon-512/clean"));
    // Objects
    lib_unit_tests.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-512/clean/libfalcon-512_clean.a"));
    // Source files
    lib_unit_tests.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/randombytes.c"),
        .flags = &.{"-std=c99"},
    });
    lib_unit_tests.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/fips202.c"),
        .flags = &.{"-std=c99"},
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");

    test_step.dependOn(&run_lib_unit_tests.step);
}
