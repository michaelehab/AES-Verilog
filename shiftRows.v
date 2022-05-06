module shiftRows (in, shifted);
	input [0:127] in;
	output [0:127] shifted;
	
	// First row (r = 0) is not shifted
	assign shifted[0+:8] = in[0+:8];
	assign shifted[32+:8] = in[32+:8];
	assign shifted[64+:8] = in[64+:8];
   assign shifted[96+:8] = in[96+:8];
	
	// Second row (r = 1) is cyclically left shifted by 1 offset
   assign shifted[8+:8] = in[40+:8];
   assign shifted[40+:8] = in[72+:8];
   assign shifted[72+:8] = in[104+:8];
   assign shifted[104+:8] = in[8+:8];
	
	// Third row (r = 2) is cyclically left shifted by 2 offsets
   assign shifted[16+:8] = in[80+:8];
   assign shifted[48+:8] = in[112+:8];
   assign shifted[80+:8] = in[16+:8];
   assign shifted[112+:8] = in[48+:8];
	
	// Fourth row (r = 3) is cyclically left shifted by 3 offsets
   assign shifted[24+:8] = in[120+:8];
   assign shifted[56+:8] = in[24+:8];
   assign shifted[88+:8] = in[56+:8];
   assign shifted[120+:8] = in[88+:8];

endmodule
