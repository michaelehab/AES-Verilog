module subword_tb;

reg [31:0] in;
wire [31:0] out;

subword s(in,out);

initial begin
$monitor("input= %h ,output= %h",in,out);
in=32'h_193de3be;
#10;
in=32'h_a0f4e22b;
#10;
in=32'h_9ac68d2a;
#10;
$finish;
end
endmodule
