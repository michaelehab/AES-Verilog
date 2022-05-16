module AES(enable, led);
output wire led;
input enable;

// The plain text used as input
wire[127:0] in = 128'h_00112233445566778899aabbccddeeff;

// The different keys used for testing (one of each type)
wire[127:0] key128 = 128'h_000102030405060708090a0b0c0d0e0f;
wire[191:0] key192 = 192'h_000102030405060708090a0b0c0d0e0f1011121314151617;
wire[255:0] key256 = 256'h_000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;

// The result of the encryption module for every type
wire[127:0] encrypted128;
wire[127:0] encrypted192;
wire[127:0] encrypted256;

// The result of the decryption module for every type
wire[127:0] decrypted128;
wire[127:0] decrypted192;
wire[127:0] decrypted256;

AES_Encrypt a(in,key128,encrypted128);
AES_Encrypt #(192,12,6) b(in,key192,encrypted192);
AES_Encrypt #(256,14,8) c(in,key256,encrypted256);

AES_Decrypt a2(encrypted128,key128,decrypted128);
AES_Decrypt #(192,12,6) b2(encrypted192,key192,decrypted192);
AES_Decrypt #(256,14,8) c2(encrypted256,key256,decrypted256);

// The led will be on only if the decryption result is the same as the plain text
assign led = (decrypted128 == in && decrypted192 == in && decrypted256 == in && enable) ? 1'b1 : 1'b0;

endmodule