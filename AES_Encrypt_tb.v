module AES_Encrypt_tb;
reg [127:0] in;
wire [127:0] out;
reg [127:0] key;

AES_Encrypt a(in,key,out);

initial begin
$monitor("in= %h, key= %h ,out= %h",in,key,out);
in=128'h_3243f6a8_885a308d_313198a2_e0370734;
key=128'h_2b7e1516_28aed2a6_abf71588_09cf4f3c;
#10;
end

endmodule