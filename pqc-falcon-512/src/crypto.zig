const std = @import("std");
const ffi = @import("ffi.zig");

const CryptoError = error{ KeyGenerationFailed, SignatureGenerationFailed };

const Verifier = struct {
    pub_key: [ffi.PK_BYTE_LEN]u8,

    pub fn from_pub(pub_key_bytes: [ffi.PK_BYTE_LEN]u8) Verifier {
        return Verifier{
            .pub_key = pub_key_bytes,
        };
    }

    pub fn verify(self: *const Verifier, message: []const u8, sig: *const [ffi.SIG_BYTE_LEN]u8, len: *const usize) bool {
        return ffi.crypto_sign_verify(
            sig,
            len.*,
            message.ptr,
            message.len,
            &self.pub_key,
        ) == 0;
    }
};

const SignerPair = struct {
    verifier: Verifier,
    sec_key: [ffi.SK_BYTE_LEN]u8,

    pub fn from_keys(pub_key_bytes: [ffi.PK_BYTE_LEN]u8, sec_key_bytes: [ffi.SK_BYTE_LEN]u8) SignerPair {
        return SignerPair{
            .verifier = Verifier.from_pub(pub_key_bytes),
            .sec_key = sec_key_bytes,
        };
    }

    pub fn create() CryptoError!SignerPair {
        var pub_key: [ffi.PK_BYTE_LEN]u8 = undefined;
        var sec_key: [ffi.SK_BYTE_LEN]u8 = undefined;

        if (ffi.crypto_sign_keypair(&pub_key, &sec_key) != 0) {
            return CryptoError.KeyGenerationFailed;
        }

        return SignerPair{
            .verifier = Verifier{ .pub_key = pub_key },
            .sec_key = sec_key,
        };
    }

    pub fn sign(self: *const SignerPair, message: []const u8) CryptoError!struct {
        sig: [ffi.SIG_BYTE_LEN]u8,
        len: usize,
    } {
        var buffer: [ffi.SIG_BYTE_LEN]u8 = undefined;
        var buffer_len: usize = 0;

        const result = ffi.crypto_sign_signature(
            &buffer,
            &buffer_len,
            message.ptr,
            message.len,
            &self.sec_key,
        );

        if (result != 0) {
            return CryptoError.SignatureGenerationFailed;
        }

        return .{ .sig = buffer, .len = buffer_len };
    }

    pub fn verify(self: *const SignerPair, message: []const u8, sig: *const [ffi.SIG_BYTE_LEN]u8, len: *const usize) bool {
        return self.verifier.verify(message, sig, len);
    }
};

test "Key Generation applies keys correctly" {
    const pair = try SignerPair.create();

    // Check that keys are non-zero (simple sanity check)
    var pub_nonzero = false;
    for (pair.verifier.pub_key) |b| {
        if (b != 0) {
            pub_nonzero = true;
            break;
        }
    }
    try std.testing.expect(pub_nonzero);

    var sec_nonzero = false;
    for (pair.sec_key) |b| {
        if (b != 0) {
            sec_nonzero = true;
            break;
        }
    }
    try std.testing.expect(sec_nonzero);
}

test "Signature Generation and Verification" {
    const pair = try SignerPair.create();
    const message = "Hello, world!";

    const sign_result = try pair.sign(message);
    try std.testing.expect(sign_result.len > 0);
    try std.testing.expect(sign_result.len <= ffi.SIG_BYTE_LEN);

    const verify_result = pair.verify(message, &sign_result.sig, &sign_result.len);
    try std.testing.expect(verify_result);
}
