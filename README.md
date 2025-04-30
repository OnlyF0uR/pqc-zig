# pqc-zig
Zig bindings to the [PQClean](https://github.com/PQClean/PQClean) C implementations of cryptographic algorithms proposed during the [NIST Post-Quantum Cryptography Competition](https://csrc.nist.gov/projects/post-quantum-cryptography).

### Requirements
- Make
- GCC
- Zig 0.15+

### Support (KEM, and signature schemes)
- [ ] hqc-128
- [ ] hqc-192
- [ ] hqc-256
- [ ] ml-kem-1024
- [ ] ml-kem-512
- [ ] ml-kem-768
- [x] falcon-1024
- [x] falcon-512
- [x] falcon-padded-1024
- [x] falcon-padded-512
- [ ] ml-dsa-44
- [ ] ml-dsa-65
- [ ] ml-dsa-87
- [ ] sphincs-sha2-128s-simple
- [ ] sphincs-sha2-192f-simple
- [ ] sphincs-sha2-192s-simple
- [ ] sphincs-sha2-256f-simple
- [ ] sphincs-sha2-256s-simple
- [ ] sphincs-shake-128f-simple
- [ ] sphincs-shake-128s-simple
- [ ] sphincs-shake-192f-simple
- [ ] sphincs-shake-192s-simple
- [ ] sphincs-shake-256f-simple
- [ ] sphincs-shake-256s-simple

### Tests
Tests can be run individually per module by executing the following command within that module:
```bash
zig build test
```