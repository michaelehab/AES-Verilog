module inverseMixColumns(state_in,state_out);
input [127:0] state_in;
output [127:0] state_out;

function[7:0] multiply(input [7:0]x,input integer n);
integer i;
begin
	for(i=0;i<n;i=i+1)begin
		if(x[7] == 1) x = ((x << 1) ^ 8'h1b);
		else x = x << 1; 
	end
	multiply=x;
end

endfunction

function [7:0] mb0e; 
input [7:0] x;
begin
	mb0e=multiply(x,3) ^ multiply(x,2)^ multiply(x,1);
end
endfunction


function [7:0] mb0d; 
input [7:0] x;
begin
	mb0d=multiply(x,3) ^ multiply(x,2)^ x;
end
endfunction


function [7:0] mb0b; 
input [7:0] x;
begin
	mb0b=multiply(x,3) ^ multiply(x,1)^ x;
end
endfunction

function [7:0] mb09; 
input [7:0] x;
begin
	mb09=multiply(x,3) ^  x;
end
endfunction

genvar i;

generate 
for(i=0;i< 4;i=i+1) begin : m_col

	assign state_out[(i*32 + 24)+:8]= mb0e(state_in[(i*32 + 24)+:8]) ^ mb0b(state_in[(i*32 + 16)+:8]) ^ mb0d(state_in[(i*32 + 8)+:8]) ^ mb09(state_in[i*32+:8]);
	assign state_out[(i*32 + 16)+:8]= mb09(state_in[(i*32 + 24)+:8]) ^ mb0e(state_in[(i*32 + 16)+:8]) ^ mb0b(state_in[(i*32 + 8)+:8]) ^ mb0d(state_in[i*32+:8]);
	assign state_out[(i*32 + 8)+:8]= mb0d(state_in[(i*32 + 24)+:8]) ^ mb09(state_in[(i*32 + 16)+:8]) ^ mb0e(state_in[(i*32 + 8)+:8]) ^ mb0b(state_in[i*32+:8]);
   assign state_out[i*32+:8]= mb0b(state_in[(i*32 + 24)+:8]) ^ mb0d(state_in[(i*32 + 16)+:8]) ^ mb09(state_in[(i*32 + 8)+:8]) ^ mb0e(state_in[i*32+:8]);

end

endgenerate


endmodule