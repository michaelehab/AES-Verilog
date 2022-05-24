module inverseMixColumns(state_in,state_out);
input [127:0] state_in;
output [127:0] state_out;

/*
Multiplication by 2 can be implemented at the byte level as a left shift and a subsequent
conditional bitwise XOR with {1b},where bitwise xor with {1b} is done if x[7]= 1.
Multiplication by higher powers of x can be implemented by repeated application of multiplication by 2.
*/

//This function multiply by {02} n-times
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


/* 
	Multiply by {0e} is done by :
	(multiplying by {02} 3 times which is equivalent to multiplication by {08}) xor
	(multiplying by {02} 2 times which is equivalent to multiplication by {04}) xor
	(multiplying by {02})
	so that 8+4+2= e. where xor is the addition of elements in finite fields
*/
function [7:0] mb0e; //multiply by {0e}
input [7:0] x;
begin
	mb0e=multiply(x,3) ^ multiply(x,2)^ multiply(x,1);
end
endfunction

/* 
	Multiply by {0d} is done by :
	(multiplying by {02} 3 times which is equivalent to multiplication by {08}) xor
	(multiplying by {02} 2 times which is equivalent to multiplication by {04}) xor
	(the original x)
	so that 8+4+1= d. where xor is the addition of elements in finite fields
*/
function [7:0] mb0d; //multiply by {0d}
input [7:0] x;
begin
	mb0d=multiply(x,3) ^ multiply(x,2)^ x;
end
endfunction


/* 
	Multiply by {0b} is done by :
	(multiplying by {02} 3 times which is equivalent to multiplication by {08}) xor
	(multiplying by {02}) xor (the original x)
	so that 8+2+1= b. where xor is the addition of elements in finite fields
*/

function [7:0] mb0b;  //multiply by {0b}
input [7:0] x;
begin
	mb0b=multiply(x,3) ^ multiply(x,1)^ x;
end
endfunction
/* 
	Multiply by {09} is done by :
	(multiplying by {02} 3 times which is equivalent to multiplication by {08}) xor (the original x)
	so that 8+1= 9. where xor is the addition of elements in finite fields
*/

function [7:0] mb09; //multiply by {09}
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