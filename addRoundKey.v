module addRoundKey(input [127 : 0] data, output [127:0] out, input [127:0] key, input clk);

generate
genvar i;
for(i = 0; i < 128; i = i + 1)
begin: h
assign out[i] = data[i]^key[i];
end
endgenerate
endmodule