module decryptRound(in,key,out);
input [127:0] in;
output [127:0] out;
input [127:0] key;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] afterMixColumns;
wire [127:0] afterAddroundKey;

inverseShiftRows r(in,afterShiftRows);
inverseSubBytes s(afterShiftRows,afterSubBytes);
addRoundKey b(afterSubBytes,afterAddroundKey,key);
inverseMixColumns m(afterAddroundKey,out);
		
endmodule