const std = @import("std");
const build_options = @import("build_options");

// #define PQCLEAN_MLDSA65_CLEAN_CRYPTO_SECRETKEYBYTES 4032
pub const SK_BYTE_LEN: u32 = 4032;
// #define PQCLEAN_MLDSA65_CLEAN_CRYPTO_PUBLICKEYBYTES 1952
pub const PK_BYTE_LEN: u32 = 1952;
// #define PQCLEAN_MLDSA65_CLEAN_CRYPTO_BYTES 3309
pub const SIG_BYTE_LEN: u32 = 3309;

// #define PQCLEAN_MLDSA65_CLEAN_CRYPTO_ALGNAME "ML-DSA-65"
pub const ALG_NAME: []const u8 = "ML-DSA-65";

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_keypair(uint8_t *pk, uint8_t *sk);
pub fn crypto_sign_keypair(
    pk: *[PK_BYTE_LEN]u8,
    sk: *[SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_keypair(pk, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_keypair(pk, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_keypair(pk, sk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_signature_ctx(uint8_t *sig, size_t *siglen,
//         const uint8_t *m, size_t mlen,
//         const uint8_t *ctx, size_t ctxlen,
//         const uint8_t *sk);
pub fn crypto_sign_signature_ctx(
    sig: [*c]u8,
    siglen: [*c]usize,
    m: [*c]const u8,
    mlen: usize,
    ctx: [*c]const u8,
    ctxlen: usize,
    sk: *const [SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_signature_ctx(sig, siglen, m, mlen, ctx, ctxlen, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_signature_ctx(sig, siglen, m, mlen, ctx, ctxlen, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_signature_ctx(sig, siglen, m, mlen, ctx, ctxlen, sk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_verify_ctx(const uint8_t *sig, size_t siglen,
//         const uint8_t *m, size_t mlen,
//         const uint8_t *ctx, size_t ctxlen,
//         const uint8_t *pk);
pub fn crypto_sign_verify_ctx(
    sig: [*c]const u8,
    siglen: usize,
    m: [*c]const u8,
    mlen: usize,
    ctx: [*c]const u8,
    ctxlen: usize,
    pk: *const [PK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_verify_ctx(sig, siglen, m, mlen, ctx, ctxlen, pk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_verify_ctx(sig, siglen, m, mlen, ctx, ctxlen, pk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_verify_ctx(sig, siglen, m, mlen, ctx, ctxlen, pk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_ctx(uint8_t *sm, size_t *smlen,
//         const uint8_t *m, size_t mlen,
//         const uint8_t *ctx, size_t ctxlen,
//         const uint8_t *sk);
pub fn crypto_sign_ctx(
    sm: [*c]u8,
    smlen: [*c]usize,
    m: [*c]const u8,
    mlen: usize,
    ctx: [*c]const u8,
    ctxlen: usize,
    sk: *const [SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_ctx(sm, smlen, m, mlen, ctx, ctxlen, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_ctx(sm, smlen, m, mlen, ctx, ctxlen, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_ctx(sm, smlen, m, mlen, ctx, ctxlen, sk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_open_ctx(uint8_t *m, size_t *mlen,
//         const uint8_t *sm, size_t smlen,
//         const uint8_t *ctx, size_t ctxlen,
//         const uint8_t *pk);
pub fn crypto_sign_open_ctx(
    m: [*c]u8,
    mlen: [*c]usize,
    sm: [*c]const u8,
    smlen: usize,
    ctx: [*c]const u8,
    ctxlen: usize,
    pk: *const [PK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_open_ctx(m, mlen, sm, smlen, ctx, ctxlen, pk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_open_ctx(m, mlen, sm, smlen, ctx, ctxlen, pk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_open_ctx(m, mlen, sm, smlen, ctx, ctxlen, pk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_signature(uint8_t *sig, size_t *siglen,
//         const uint8_t *m, size_t mlen,
//         const uint8_t *sk);
pub fn crypto_sign_signature(
    sig: [*c]u8,
    siglen: [*c]usize,
    m: [*c]const u8,
    mlen: usize,
    sk: *const [SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_signature(sig, siglen, m, mlen, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_signature(sig, siglen, m, mlen, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_signature(sig, siglen, m, mlen, sk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_verify(const uint8_t *sig, size_t siglen,
//         const uint8_t *m, size_t mlen,
//         const uint8_t *pk);
pub fn crypto_sign_verify(
    sig: [*c]const u8,
    siglen: usize,
    m: [*c]const u8,
    mlen: usize,
    pk: *const [PK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_verify(sig, siglen, m, mlen, pk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_verify(sig, siglen, m, mlen, pk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_verify(sig, siglen, m, mlen, pk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign(uint8_t *sm, size_t *smlen,
//                                       const uint8_t *m, size_t mlen,
//                                       const uint8_t *sk);
pub fn crypto_sign(
    sm: [*c]u8,
    smlen: [*c]usize,
    m: [*c]const u8,
    mlen: usize,
    sk: *const [SK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign(sm, smlen, m, mlen, sk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign(sm, smlen, m, mlen, sk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign(sm, smlen, m, mlen, sk);
    }
}

// int PQCLEAN_MLDSA65_CLEAN_crypto_sign_open(uint8_t *m, size_t *mlen,
//         const uint8_t *sm, size_t smlen,
//         const uint8_t *pk);
pub fn crypto_sign_open(
    m: [*c]u8,
    mlen: [*c]usize,
    sm: [*c]const u8,
    smlen: usize,
    pk: *const [PK_BYTE_LEN]u8,
) c_int {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });
        return c.PQCLEAN_MLDSA65_AVX2_crypto_sign_open(m, mlen, sm, smlen, pk);
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });
        return c.PQCLEAN_MLDSA65_AARCH64_crypto_sign_open(m, mlen, sm, smlen, pk);
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });
        return c.PQCLEAN_MLDSA65_CLEAN_crypto_sign_open(m, mlen, sm, smlen, pk);
    }
}

test "keypair generation" {
    var pk: [PK_BYTE_LEN]u8 = undefined;
    var sk: [SK_BYTE_LEN]u8 = undefined;
    const result = crypto_sign_keypair(&pk, &sk);
    try std.testing.expectEqual(@as(c_int, 0), result);
}

test "sign signature and verify with context" {
    var pk: [PK_BYTE_LEN]u8 = undefined;
    var sk: [SK_BYTE_LEN]u8 = undefined;
    const result = crypto_sign_keypair(&pk, &sk);
    try std.testing.expectEqual(@as(c_int, 0), result);

    // Allocate memory for the message
    const message: []const u8 = "Hello, world!";
    const context: []const u8 = "context";

    var buffer: [SIG_BYTE_LEN]u8 = undefined;
    var buffer_len: usize = 0;

    // Sign the message
    const sign_result = crypto_sign_signature_ctx(
        &buffer,
        &buffer_len,
        message.ptr,
        message.len,
        context.ptr,
        context.len,
        &sk,
    );
    try std.testing.expectEqual(@as(c_int, 0), sign_result);

    // Verify the signature
    const verify_result = crypto_sign_verify_ctx(
        &buffer,
        buffer_len,
        message.ptr,
        message.len,
        context.ptr,
        context.len,
        &pk,
    );

    try std.testing.expectEqual(@as(c_int, 0), verify_result);
}

test "sign signature and verify" {
    var pk: [PK_BYTE_LEN]u8 = undefined;
    var sk: [SK_BYTE_LEN]u8 = undefined;
    const result = crypto_sign_keypair(&pk, &sk);
    try std.testing.expectEqual(@as(c_int, 0), result);

    // Allocate memory for the message
    const message: []const u8 = "Hello, world!";

    var buffer: [SIG_BYTE_LEN]u8 = undefined;
    var buffer_len: usize = 0;

    // Sign the message
    const sign_result = crypto_sign_signature(
        &buffer,
        &buffer_len,
        message.ptr,
        message.len,
        &sk,
    );
    try std.testing.expectEqual(@as(c_int, 0), sign_result);

    // // Verify the signature
    const verify_result = crypto_sign_verify(
        &buffer,
        buffer_len,
        message.ptr,
        message.len,
        &pk,
    );

    try std.testing.expectEqual(@as(c_int, 0), verify_result);

    const message2: []const u8 = "Some other message!";

    // Verify for different message
    const verify_result2 = crypto_sign_verify(
        &buffer,
        buffer_len,
        message2.ptr,
        message2.len,
        &pk,
    );

    try std.testing.expectEqual(@as(c_int, -1), verify_result2);
}

test "crypto sign and verify with context" {
    var pk: [PK_BYTE_LEN]u8 = undefined;
    var sk: [SK_BYTE_LEN]u8 = undefined;
    const result = crypto_sign_keypair(&pk, &sk);
    try std.testing.expectEqual(@as(c_int, 0), result);

    // Allocate memory for the message
    const message: []const u8 = "Hello, world!";
    const context: []const u8 = "context";

    // Allocate memory for the signature
    const alloc = std.heap.page_allocator;
    const buffer: []u8 = alloc.alloc(u8, SIG_BYTE_LEN + message.len) catch unreachable;
    defer alloc.free(buffer);
    var bufferlen: usize = 0;

    // Sign the message
    const sign_result = crypto_sign_ctx(
        @as([*c]u8, @ptrCast(buffer)),
        &bufferlen,
        message.ptr,
        message.len,
        context.ptr,
        context.len,
        &sk,
    );
    try std.testing.expectEqual(@as(c_int, 0), sign_result);

    // Create a new buffer for message
    const message_buffer: []u8 = alloc.alloc(u8, message.len) catch unreachable;
    var message_buffer_len: usize = 0;
    defer alloc.free(message_buffer);

    // Verify the signature
    const verify_result = crypto_sign_open_ctx(
        @as([*c]u8, @ptrCast(message_buffer)),
        &message_buffer_len,
        @ptrCast(buffer),
        bufferlen,
        context.ptr,
        context.len,
        &pk,
    );
    try std.testing.expectEqual(@as(c_int, 0), verify_result);

    try std.testing.expectEqual(message.len, message_buffer_len);

    try std.testing.expect(std.mem.eql(u8, message, message_buffer[0..message_buffer_len]));
}

// Works similar to sign_signature, but embeds the message in the signature
test "crypto sign and verify" {
    var pk: [PK_BYTE_LEN]u8 = undefined;
    var sk: [SK_BYTE_LEN]u8 = undefined;
    const result = crypto_sign_keypair(&pk, &sk);
    try std.testing.expectEqual(@as(c_int, 0), result);

    // Allocate memory for the message
    const message: []const u8 = "Hello, world!";

    // Allocate memory for the signature
    const alloc = std.heap.page_allocator;
    const buffer: []u8 = alloc.alloc(u8, SIG_BYTE_LEN + message.len) catch unreachable;
    defer alloc.free(buffer);
    var bufferlen: usize = 0;

    // Sign the message
    const sign_result = crypto_sign(
        @as([*c]u8, @ptrCast(buffer)),
        &bufferlen,
        message.ptr,
        message.len,
        &sk,
    );
    try std.testing.expectEqual(@as(c_int, 0), sign_result);

    // Create a new buffer for message
    const message_buffer: []u8 = alloc.alloc(u8, message.len) catch unreachable;
    var message_buffer_len: usize = 0;
    defer alloc.free(message_buffer);

    // Verify the signature
    const verify_result = crypto_sign_open(
        @as([*c]u8, @ptrCast(message_buffer)),
        &message_buffer_len,
        @ptrCast(buffer),
        bufferlen,
        &pk,
    );
    try std.testing.expectEqual(@as(c_int, 0), verify_result);

    try std.testing.expectEqual(message.len, message_buffer_len);

    try std.testing.expect(std.mem.eql(u8, message, message_buffer[0..message_buffer_len]));
}

test "byte lengths" {
    if (build_options.avx2) {
        const c = @cImport({
            @cInclude("avx2/api.h");
        });

        try std.testing.expectEqual(SK_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_SECRETKEYBYTES);
        try std.testing.expectEqual(PK_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_PUBLICKEYBYTES);
        try std.testing.expectEqual(SIG_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_BYTES);
        try std.testing.expect(std.mem.eql(u8, ALG_NAME, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_ALGNAME));
    } else if (build_options.aarch64) {
        const c = @cImport({
            @cInclude("aarch64/api.h");
        });

        try std.testing.expectEqual(SK_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_SECRETKEYBYTES);
        try std.testing.expectEqual(PK_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_PUBLICKEYBYTES);
        try std.testing.expectEqual(SIG_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_BYTES);
        try std.testing.expect(std.mem.eql(u8, ALG_NAME, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_ALGNAME));
    } else {
        const c = @cImport({
            @cInclude("clean/api.h");
        });

        try std.testing.expectEqual(SK_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_SECRETKEYBYTES);
        try std.testing.expectEqual(PK_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_PUBLICKEYBYTES);
        try std.testing.expectEqual(SIG_BYTE_LEN, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_BYTES);
        try std.testing.expect(std.mem.eql(u8, ALG_NAME, c.PQCLEAN_MLDSA65_CLEAN_CRYPTO_ALGNAME));
    }
}
