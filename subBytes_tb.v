module subBytes_tb;
reg [127:0] in;
wire [127:0]out;

subBytes sb(in,out);

initial begin
$monitor("input= %h ,output= %h",in,out);
in=128'h_193de3be_a0f4e22b_9ac68d2a_e9f84808;
#10;
end
endmodule