const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const enable_clean = b.option(bool, "clean", "Enable clean (portable) implementation") orelse true;
    const enable_avx2 = b.option(bool, "avx2", "Enable AVX2 implementation") orelse false;
    const enable_aarch64 = b.option(bool, "aarch64", "Enable AArch64 implementation") orelse false;

    const options = b.addOptions();
    options.addOption(bool, "clean", enable_clean);
    options.addOption(bool, "avx2", enable_avx2);
    options.addOption(bool, "aarch64", enable_aarch64);

    const lib_mod = b.createModule(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "pqc_falcon_padded_512",
        .root_module = lib_mod,
    });
    lib.linkLibC();

    // Common headers and files for all variants
    lib.addIncludePath(b.path("../libs/PQClean/common"));
    lib.addIncludePath(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/"));

    lib.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/randombytes.c"),
        .flags = &.{"-std=c99"},
    });
    lib.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/fips202.c"),
        .flags = &.{"-std=c99"},
    });

    // Clean implementation
    if (enable_clean) {
        const make_falcon512_clean = b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-padded-512/clean"), "CC=gcc" });
        lib.step.dependOn(&make_falcon512_clean.step);
        lib.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/clean/libfalcon-padded-512_clean.a"));
    }

    // AVX2 implementation
    if (enable_avx2) {
        const make_falcon512_avx2 = b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-padded-512/avx2"), "CC=gcc" });
        lib.step.dependOn(&make_falcon512_avx2.step);
        lib.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/avx2/libfalcon-padded-512_avx2.a"));
    }

    // AArch64 implementation
    if (enable_aarch64) {
        const make_falcon512_aarch64 = b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-padded-512/aarch64"), "CC=gcc" });
        lib.step.dependOn(&make_falcon512_aarch64.step);
        lib.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/aarch64/libfalcon-padded-512_aarch64.a"));
    }

    lib.root_module.addOptions("build_options", options);
    b.installArtifact(lib);

    // Unit tests with the same configuration
    const lib_unit_tests = b.addTest(.{
        .root_module = lib_mod,
    });
    lib_unit_tests.linkLibC();

    // Common headers and files for tests
    lib_unit_tests.addIncludePath(b.path("../libs/PQClean/common"));
    lib_unit_tests.addIncludePath(b.path("../libs/PQClean/crypto_sign/falcon-padded-512"));

    lib_unit_tests.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/randombytes.c"),
        .flags = &.{"-std=c99"},
    });
    lib_unit_tests.addCSourceFile(.{
        .file = b.path("../libs/PQClean/common/fips202.c"),
        .flags = &.{"-std=c99"},
    });
    // Add the same architecture implementations to tests
    if (enable_clean) {
        lib_unit_tests.step.dependOn(&(b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-padded-512/clean"), "CC=gcc" })).step);
        lib_unit_tests.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/clean/libfalcon-padded-512_clean.a"));
    }

    if (enable_avx2) {
        lib_unit_tests.step.dependOn(&(b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-padded-512/avx2"), "CC=gcc" })).step);
        lib_unit_tests.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/avx2/libfalcon-padded-512_avx2.a"));
    }

    if (enable_aarch64) {
        lib_unit_tests.step.dependOn(&(b.addSystemCommand(&.{ "make", "-C", b.pathFromRoot("../libs/PQClean/crypto_sign/falcon-padded-512/aarch64"), "CC=gcc" })).step);
        lib_unit_tests.addObjectFile(b.path("../libs/PQClean/crypto_sign/falcon-padded-512/aarch64/libfalcon-padded-512_aarch64.a"));
    }

    lib_unit_tests.root_module.addOptions("build_options", options);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}
