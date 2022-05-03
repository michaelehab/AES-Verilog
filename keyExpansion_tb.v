module keyExpansion_tb;
reg [0:127] k;
wire[1408:0] out;

keyExpansion ks(k,out);
initial begin
$monitor("k= %h , out= %h",k,out);
k=128'h_2b7e1516_28aed2a6_abf71588_09cf4f3c;
end
endmodule