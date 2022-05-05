module keyExpansion_tb;
reg [0:127] k1;
wire[1407:0] out1;

reg [0:191] k2;
wire[1663:0] out2;

keyExpansion ks(k1,out1);
keyExpansion #(6,12) ks2(k2,out2);

initial begin
//$monitor("k= %h , out= %h",k,out);
//k=128'h_2b7e1516_28aed2a6_abf71588_09cf4f3c;
$monitor("k192= %h , out192= %h",k2,out2);
k2=192'h_00010203_04050607_08090a0b_0c0d0e0f_10111213_14151617;


end
endmodule