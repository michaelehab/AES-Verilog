module subword(in,out);
input [31:0] in;
output [31:0]out;

/* cannot instantiate instances inisde initial block. */

genvar i;

generate
		for (i = 0 ; i < 32; i = i+8) begin : sub_word
					sbox s (in[i +:8] , out[i +:8]);
		end
endgenerate

endmodule