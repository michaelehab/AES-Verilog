module AES_Encrypt#(parameter N=128,parameter Nr=10,parameter Nk=4)(in,key,out);
input [127:0] in;
input [N-1:0] key;
output [127:0] out;
reg [127:0] state;
wire [(128*(Nr+1))-1 :0] fullkeys;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;
wire [127:0] afterMixColumns;
wire [127:0] afterAddroundKey;
wire [127:0] intermediate;


keyExpansion #(Nk,Nr) k (key,fullkeys);
addRoundKey a (in,intermediate,fullkeys[((128*(Nr+1))-1)-:128]);
initial begin
	state=intermediate;
end

genvar i;
generate
	for(i=1; i<Nr ;i=i+1)begin : loop
		subBytes s(state,afterSubBytes);
		shiftRows r(afterSubBytes,afterShiftRows);
		mixColumns m(afterShiftRows,afterMixColumns);
		addRoundKey b(afterMixColumns,afterAddroundKey,fullkeys[(((128*(Nr+1))-1)-128*i)-:128]);
		always@* begin
			state=afterAddroundKey;
		end
	end

endgenerate

subBytes sr(afterAddroundKey,afterSubBytes);
shiftRows rm(afterSubBytes,afterShiftRows);
addRoundKey bk(afterMixColumns,afterAddroundKey,fullkeys[127:0]);

//assign out=afterAddroundKey;

endmodule