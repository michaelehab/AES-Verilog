module inverseMixColumns_tb;
reg [0:127] in;

wire [0:127] out;	


inverseMixColumns m (in,out);


initial begin
$monitor("input= %H , output= %h",in,out);
in= 128'hbaa03de7a1f9b56ed5512cba5f414d23;
#10;
//in=128'h_84e1dd69_1a41d76f_792d3897_83fbac70 ;
//#10;
//in=128'h_6353e08c_0960e104_cd70b751_bacad0e7;
//#10;
end
endmodule