module encryptRound(in,key,out);
input [127:0] in;
output [127:0] out;
input [127:0] key;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] afterMixColumns;
wire [127:0] afterAddroundKey;

subBytes s(in,afterSubBytes);
shiftRows r(afterSubBytes,afterShiftRows);
mixColumns m(afterShiftRows,afterMixColumns);
addRoundKey b(afterMixColumns,out,key);
		
endmodule