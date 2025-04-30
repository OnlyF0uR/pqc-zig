const std = @import("std");
const c = @cImport({
    @cInclude("api.h");
});

// TODO: Write actual functions to wrap the C functions from PQClean

test "Falcon-512 keypair generation" {
    // Allocate memory for the public and secret keys
    var pk: [c.PQCLEAN_FALCON512_CLEAN_CRYPTO_PUBLICKEYBYTES]u8 = undefined;
    var sk: [c.PQCLEAN_FALCON512_CLEAN_CRYPTO_SECRETKEYBYTES]u8 = undefined;

    // Generate a new keypair
    const result = c.PQCLEAN_FALCON512_CLEAN_crypto_sign_keypair(&pk, &sk);

    // Check if key generation was successful
    try std.testing.expectEqual(@as(c_int, 0), result);

    // Print sizes for verification
    std.debug.print("\nPublic key size: {}\n", .{pk.len});
    std.debug.print("Secret key size: {}\n", .{sk.len});

    // Optional: Print first few bytes of keys (for debugging)
    std.debug.print("Public key first bytes: ", .{});
    for (pk[0..8]) |byte| {
        std.debug.print("{X:0>2} ", .{byte});
    }
    std.debug.print("\n", .{});
}
