# Advanced encryption standard (AES128, AES192, AES256) in Verilog
![aes from Kekayan, Medium](https://user-images.githubusercontent.com/29122581/169694136-ca48f098-d5f5-448f-8016-4cb9a9b0e300.png)
<div align="center">
  
  ![GitHub stars](https://img.shields.io/github/stars/michaelehab/AES-Verilog?style=plastic)
  ![GitHub forks](https://img.shields.io/github/forks/michaelehab/AES-Verilog?style=plastic)
  ![GitHub repo size](https://img.shields.io/github/repo-size/michaelehab/AES-Verilog?style=plastic)
  ![GitHub top language](https://img.shields.io/github/languages/top/michaelehab/AES-Verilog?style=plastic)
  
</div>

# Explanation:
The Advanced Encryption Standard (AES) specifies a FIPS-approved
cryptographic algorithm that can be used to protect electronic data. The AES algorithm is a
symmetric block cipher that can encrypt (encipher) and decrypt (decipher) information.
Encryption converts data to an unintelligible form called ciphertext; decrypting the ciphertext
converts the data back into its original form, called plaintext.
The AES algorithm is capable of using cryptographic keys of 128, 192, and 256 bits to encrypt
and decrypt data in blocks of 128 bits

# Links
* [Wikipedia](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
* [NIST](./NIST.FIPS.197.pdf)

# Usage

**🔐Encryption: (AES_Encrypt module)**
```verilog
...
wire[127:0] in = 128'h_00112233445566778899aabbccddeeff; // Plain Text example

wire[127:0] key128 = 128'h_000102030405060708090a0b0c0d0e0f; // 128bit key
wire[191:0] key192 = 192'h_000102030405060708090a0b0c0d0e0f1011121314151617; // 192bit key
wire[255:0] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; // 256bit key

wire[127:0] encrypted128; // This wire will contain the encrypted text using the 128bit key
wire[127:0] encrypted192; // This wire will contain the encrypted text using the 192bit key
wire[127:0] encrypted256; // This wire will contain the encrypted text using the 256bit key

// The encryption module uses AES128 by default
AES_Encrypt a(in,key128,encrypted128);
// You can pass the key length, Nr and Nk as parameters to use AES192 and AES256
AES_Encrypt #(192,12,6) b(in,key192,encrypted192);
AES_Encrypt #(256,14,8) c(in,key256,encrypted256);
...
```

**🔓Decryption: (AES_Decrypt module)**
```verilog
...
// This wire contains the encrypted text using the 128bit key
wire[127:0] encrypted128 = 128'h_69c4e0d86a7b0430d8cdb78070b4c55a;
// This wire contains the encrypted text using the 192bit key
wire[127:0] encrypted192 = 128'h_dda97ca4864cdfe06eaf70a0ec0d7191;
// This wire contains the encrypted text using the 256bit key
wire[127:0] encrypted256 = 128'h_8ea2b7ca516745bfeafc49904b496089;

wire[127:0] key128 = 128'h_000102030405060708090a0b0c0d0e0f; // 128bit key
wire[191:0] key192 = 192'h_000102030405060708090a0b0c0d0e0f1011121314151617; // 192bit key
wire[255:0] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f; // 256bit key

wire[127:0] decrypted128; // This wire will contain the decrypted text using the 128bit key
wire[127:0] decrypted192; // This wire will contain the decrypted text using the 192bit key
wire[127:0] decrypted256; // This wire will contain the decrypted text using the 256bit key

// The decryption module uses AES128 by default
AES_Decrypt a2(encrypted128,key128,decrypted128);
// You can pass the key length, Nr and Nk as parameters to use AES192 and AES256
AES_Decrypt #(192,12,6) b2(encrypted192,key192,decrypted192);
AES_Decrypt #(256,14,8) c2(encrypted256,key256,decrypted256);
...
```

**Testing: (AES wrapper module)**
```verilog
...
// All these wires are connected to leds
wire e128; // This led will be turned on when AES128 Encryption test succeeds
wire d128; // This led will be turned on when AES128 Decryption test succeeds
wire e192; // This led will be turned on when AES192 Encryption test succeeds
wire d192; // This led will be turned on when AES192 Decryption test succeeds
wire e256; // This led will be turned on when AES256 Encryption test succeeds
wire d256; // This led will be turned on when AES256 Decryption test succeeds
reg enable; // This switch enables the wrapper module

AES a(enable, e128, d128, e192, d192, e256, d256);
...
```

# 📷 Working Images
Testing was done on DE1-SOC kit by implementing the wrapper module which generates the required inputs to the system and if tests passed it turns on the LEDs.
## Enable turned off
![disabled](https://user-images.githubusercontent.com/29122581/170337017-2246f4cf-f74e-4cbb-b4d8-f79b7436e2bd.jpg)
## Enable turned on
![enabled](https://user-images.githubusercontent.com/29122581/170337046-f8e7831a-081f-4685-b5aa-f520870f6d48.jpg)

<div align="center">
  
  ![GitHub Repo Visitors](https://api.visitorbadge.io/api/VisitorHit?user=michaelehab&repo=AES-Verilog&countColor=%237B1E7A)
  
</div>
