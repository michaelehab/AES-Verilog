module addRoundKey_tb;

reg [127:0] in;
reg [127:0] key;
wire [127:0] out;	


addRoundKey m (in, out, key);


initial begin
	$monitor("input= %H, output= %h, key = %h", in, out, key);
	in = 128'h_046681e5_e0cb199a_48f8d37a_2806264c;
	key = 128'h_a0fafe17_88542cb1_23a33939_2a6c7605;
end
endmodule