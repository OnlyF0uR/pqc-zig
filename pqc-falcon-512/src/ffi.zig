const std = @import("std");
const ffi = @import("ffi.zig");
const build_options = @import("build_options");

// #define PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES   1281
pub const SK_BYTE_LEN: u32 = 1281;
// #define PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES   897
pub const PK_BYTE_LEN: u32 = 897;
// #define PQCLEAN_FALCON512_CLEAN_CRYPTO_BYTES            752
pub const SIG_BYTE_LEN: u32 = 752;

// #define PQCLEAN_FALCON512_CLEAN_CRYPTO_ALGNAME          "Falcon-512"
pub const ALG_NAME: []const u8 = "Falcon-512";

// #define PQCLEAN_FALCONPADDED512_CLEAN_CRYPTO_BYTES      666 // used in signature verification
pub const SIG_PADDED_BYTE_LEN: u32 = 666; // used in signature verification

// int PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(
//     uint8_t *pk, uint8_t *sk);
pub fn crypto_sign_keypair(
    pk: *[ffi.PK_BYTE_LEN]u8,
    sk: *[ffi.SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_FALCON512_AVX2_crypto_sign_keypair(pk, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_FALCON512_AARCH64_crypto_sign_keypair(pk, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(pk, sk);
    }
}

// int PQCLEAN_FALCON512_CLEAN_crypto_sign_signature(
//     uint8_t *sig, size_t *siglen,
//     const uint8_t *m, size_t mlen, const uint8_t *sk);
pub fn crypto_sign_signature(
    sig: [*c]u8,
    siglen: [*c]usize,
    m: [*c]const u8,
    mlen: usize,
    sk: *[ffi.SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_FALCON512_AVX2_crypto_sign_signature(sig, siglen, m, mlen, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_FALCON512_AARCH64_crypto_sign_signature(sig, siglen, m, mlen, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_FALCON512_CLEAN_crypto_sign_signature(sig, siglen, m, mlen, sk);
    }
}

// int PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(
//     const uint8_t *sig, size_t siglen,
//     const uint8_t *m, size_t mlen, const uint8_t *pk);
pub fn crypto_sign_verify(
    sig: [*c]const u8,
    siglen: usize,
    m: [*c]const u8,
    mlen: usize,
    pk: *[ffi.PK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_FALCON512_AVX2_crypto_sign_verify(sig, siglen, m, mlen, pk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_FALCON512_AARCH64_crypto_sign_verify(sig, siglen, m, mlen, pk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_FALCON512_CLEAN_crypto_sign_verify(sig, siglen, m, mlen, pk);
    }
}

// int PQCLEAN_FALCON512_CLEAN_crypto_sign(
//     uint8_t *sm, size_t *smlen,
//     const uint8_t *m, size_t mlen, const uint8_t *sk);
pub fn crypto_sign(
    sm: [*c]u8,
    smlen: [*c]usize,
    m: [*c]const u8,
    mlen: usize,
    sk: *[ffi.SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_FALCON512_AVX2_crypto_sign(sm, smlen, m, mlen, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_FALCON512_AARCH64_crypto_sign(sm, smlen, m, mlen, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_FALCON512_CLEAN_crypto_sign(sm, smlen, m, mlen, sk);
    }
}

// int PQCLEAN_FALCON512_CLEAN_crypto_sign_open(
//     uint8_t *m, size_t *mlen,
//     const uint8_t *sm, size_t smlen, const uint8_t *pk);
pub fn crypto_sign_open(
    m: [*c]u8,
    mlen: [*c]usize,
    sm: [*c]const u8,
    smlen: usize,
    pk: *[ffi.PK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_FALCON512_AVX2_crypto_sign_open(m, mlen, sm, smlen, pk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_FALCON512_AARCH64_crypto_sign_open(m, mlen, sm, smlen, pk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_FALCON512_CLEAN_crypto_sign_open(m, mlen, sm, smlen, pk);
    }
}

test "keypair generation" {
    // Allocate memory for the public and secret keys
    var pk: [ffi.PK_BYTE_LEN]u8 = undefined;
    var sk: [ffi.SK_BYTE_LEN]u8 = undefined;

    // Generate a new keypair
    const result = crypto_sign_keypair(&pk, &sk);
    // Check if key generation was successful
    try std.testing.expectEqual(@as(c_int, 0), result);
}

// TODO: Write tests
test "sign signature" {
    var pk: [ffi.PK_BYTE_LEN]u8 = undefined;
    var sk: [ffi.SK_BYTE_LEN]u8 = undefined;
    const result = crypto_sign_keypair(&pk, &sk);
    try std.testing.expectEqual(@as(c_int, 0), result);

    // Allocate memory for the message
    const message: []const u8 = "Hello, world!";
    const message_len: usize = message.len;

    // Allocate memory for the signature
    const alloc = std.heap.page_allocator;
    const sig: []u8 = alloc.alloc(u8, SIG_BYTE_LEN) catch unreachable;
    defer alloc.free(sig);
    var siglen: usize = 0;

    // Sign the message
    const sign_result = crypto_sign_signature(
        @as([*c]u8, @ptrCast(sig)),
        &siglen,
        @ptrCast(message),
        message_len,
        &sk,
    );
    try std.testing.expectEqual(@as(c_int, 0), sign_result);

    // Verify the signature
    const verify_result = crypto_sign_verify(
        @ptrCast(sig),
        siglen,
        @ptrCast(message),
        message_len,
        &pk,
    );

    try std.testing.expectEqual(@as(c_int, 0), verify_result);

    const message2: []const u8 = "Some other message!";
    const message_len2: usize = message2.len;

    // Verify for different message
    const verify_result2 = crypto_sign_verify(
        @ptrCast(sig),
        siglen,
        @ptrCast(message2),
        message_len2,
        &pk,
    );

    try std.testing.expectEqual(@as(c_int, -1), verify_result2);
}
