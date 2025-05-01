const std = @import("std");
const ffi = @import("ffi.zig");

const CryptoError = error{ KeyGenerationFailed, SignatureGenerationFailed, BufferTooSmall, CouldNotUnfold };

const Verifier = struct {
    pub_key: [ffi.PK_BYTE_LEN]u8,

    pub fn from_pub(pub_key_bytes: [ffi.PK_BYTE_LEN]u8) Verifier {
        return Verifier{
            .pub_key = pub_key_bytes,
        };
    }

    pub fn verify(self: *const Verifier, message: []const u8, sig: *const []u8, len: usize) bool {
        // No need to even call the C function if the signature is too long
        if (sig.len > ffi.SIG_BYTE_LEN) {
            return false;
        }

        return ffi.crypto_sign_verify(
            sig.ptr,
            len,
            message.ptr,
            message.len,
            &self.pub_key,
        ) == 0;
    }

    pub fn unfold(self: *const Verifier, sm: *const []u8, sm_len: usize, buffer: []u8) CryptoError!usize {
        // We don't really know the size of the unfolded message, s is somewhat variable,
        // so we can't use the length of the signature to determine the size of the unfolded message.
        // Therefore ensuring buffer size becomes unfeasible at this point and we cannot give a descriptive
        // error message. Instead it will hard fail in the C code.

        var buffer_len: usize = 0;
        if (ffi.crypto_sign_open(
            buffer.ptr,
            &buffer_len,
            sm.ptr,
            sm_len,
            &self.pub_key,
        ) != 0) {
            return CryptoError.CouldNotUnfold;
        }

        return buffer_len;
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

    pub fn sign(
        self: *const SignerPair,
        message: []const u8,
        out_buffer: []u8,
    ) CryptoError!usize {
        if (out_buffer.len < ffi.SIG_BYTE_LEN) {
            return CryptoError.BufferTooSmall;
        }

        var sig_len: usize = 0;
        const result = ffi.crypto_sign_signature(
            out_buffer.ptr,
            &sig_len,
            message.ptr,
            message.len,
            &self.sec_key,
        );

        if (result != 0) {
            return CryptoError.SignatureGenerationFailed;
        }

        return sig_len;
    }

    pub fn sign_and_fold(
        self: *const SignerPair,
        message: []const u8,
        out_buffer: []u8,
    ) CryptoError!usize {
        if (out_buffer.len < ffi.SIG_BYTE_LEN + message.len) {
            return CryptoError.BufferTooSmall;
        }

        var out_len: usize = 0;
        const result = ffi.crypto_sign(out_buffer.ptr, &out_len, message.ptr, message.len, &self.sec_key);
        if (result != 0) {
            return CryptoError.SignatureGenerationFailed;
        }

        return out_len;
    }

    pub fn verify(self: *const SignerPair, message: []const u8, sig: *const []u8, len: usize) bool {
        return self.verifier.verify(message, sig, len);
    }
};

test "Key generation applies keys correctly" {
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

test "Signature generation and verificaiton" {
    const pair = try SignerPair.create();
    const message = "Hello, world!";

    var buffer: [ffi.SIG_BYTE_LEN]u8 = undefined;
    const buffer_length = try pair.sign(message, &buffer);

    const buffer_slice = buffer[0..buffer_length];
    const verify_result = pair.verify(message, &buffer_slice, buffer_length);
    try std.testing.expect(verify_result);
}

test "Signature fold and unfold" {
    const pair = try SignerPair.create();
    const message = "Hello, world!";

    var allocator = std.heap.page_allocator;

    // Buffer for the signature
    var signature = try allocator.alloc(u8, ffi.SIG_BYTE_LEN + message.len);
    defer allocator.free(signature);

    const signature_len = try pair.sign_and_fold(message, signature);

    // Buffer for the unfolded message
    const unfolded_buffer = try allocator.alloc(u8, message.len);
    defer allocator.free(unfolded_buffer);

    const unfolded_length = try pair.verifier.unfold(&signature, signature_len, unfolded_buffer);
    try std.testing.expectEqual(unfolded_length, message.len);

    try std.testing.expect(std.mem.eql(u8, message, unfolded_buffer));
}
