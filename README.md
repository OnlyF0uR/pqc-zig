# pqc-zig
Zig bindings to the [PQClean](https://github.com/PQClean/PQClean) C implementations of cryptographic algorithms proposed during the [NIST Post-Quantum Cryptography Competition](https://csrc.nist.gov/projects/post-quantum-cryptography). Additionally, there are light abstractions for convenient use present in the crypto.zig files.

### Requirements
- Make
- GCC
- Zig 0.15+

### Supported schemes (KEM, and signature)
- [ ] hqc-128 (Clean)
- [ ] hqc-192 (Clean)
- [ ] hqc-256 (Clean)
- [ ] ml-kem-1024 (Clean, AVX2, AARCH64)
- [ ] ml-kem-512 (Clean, AVX2, AARCH64)
- [ ] ml-kem-768 (Clean, AVX2, AARCH64)
- [x] falcon-1024 (Clean, AVX2, AARCH64)
- [x] falcon-512 (Clean, AVX2, AARCH64)
- [x] falcon-padded-1024 (Clean, AVX2, AARCH64)
- [x] falcon-padded-512 (Clean, AVX2, AARCH64)
- [x] ml-dsa-44 (Clean, AVX2, AARCH64)
- [x] ml-dsa-65 (Clean, AVX2, AARCH64)
- [x] ml-dsa-87 (Clean, AVX2, AARCH64)
- [ ] sphincs-sha2-128s-simple (Clean, AVX2)
- [ ] sphincs-sha2-192f-simple (Clean, AVX2)
- [ ] sphincs-sha2-192s-simple (Clean, AVX2)
- [ ] sphincs-sha2-256f-simple (Clean, AVX2)
- [ ] sphincs-sha2-256s-simple (Clean, AVX2)
- [ ] sphincs-shake-128f-simple (Clean, AVX2, AARCH64)
- [ ] sphincs-shake-128s-simple (Clean, AVX2, AARCH64)
- [ ] sphincs-shake-192f-simple (Clean, AVX2, AARCH64)
- [ ] sphincs-shake-192s-simple (Clean, AVX2, AARCH64)
- [ ] sphincs-shake-256f-simple (Clean, AVX2, AARCH64)
- [ ] sphincs-shake-256s-simple (Clean, AVX2, AARCH64)

### Tests
While more rigorous testing is to be implemented, you can run tests by navigating to the desired module and using:
```bash
zig build test
```