module AES_Encrypt#(parameter N=128,parameter Nr=10,parameter Nk=4)(in,key,out);
input [127:0] in;
input [N-1:0] key;
output [127:0] out;
wire [(128*(Nr+1))-1 :0] fullkeys;
wire [127:0] intermediate  [Nr+1:0] ;
wire [127:0] temp;
wire [127:0] afterSubBytes;
wire [127:0] afterShiftRows;

keyExpansion #(Nk,Nr) k (key,fullkeys);

addRoundKey a (in,intermediate[0],fullkeys[((128*(Nr+1))-1)-:128]);

genvar i;
generate
	
	for(i=1; i<Nr ;i=i+1)begin : loop
		encryptRound r(intermediate[i-1],fullkeys[(((128*(Nr+1))-1)-128*i)-:128],intermediate[i]);
		
		end
		subBytes sr(intermediate[Nr-1],afterSubBytes);
		shiftRows rm(afterSubBytes,afterShiftRows);
		addRoundKey bk(afterShiftRows,intermediate[Nr],fullkeys[127:0]);
			assign out=intermediate[Nr];

endgenerate

//wire [127:0] afterMixColumns1;
//wire [127:0] afterAddroundKey;
//reg [127 :0] currentKey;
//wire flag;
//reg [127:0] afterSubBytes2;
//reg [127:0] afterShiftRows2;
//reg [127:0] afterMixColumns2;
//integer i;
//subBytes s(state,afterSubBytes1);
//shiftRows r(afterSubBytes2,afterShiftRows1);
//mixColumns m(afterShiftRows2,afterMixColumns1);
//always@*begin
////$monitor("state=%h",state);
//
//	state=temp;
//end
//	encryptRound r(state,currentKey,intermediate);
	
//assign out=intermediate;
//
//always@*begin
//		flag=1'b0;
//		 state=(flag==1'b0)? temp: intermediate;
//	for(i=1; i<Nr ;i=i+1)begin
//		currentKey=fullkeys[(((128*(Nr+1))-1)-128*i)-:128];
//		flag=1'b1;
//		state=intermediate;
//		
//	end
//	out=intermediate;
//end




//always@(*) begin
//	$monitor("in=%h,key=%h,i=%d ,state=%h, subbytes=%h, shiftrows=%h, mixcolumns=%h, roundkey=%h",in,currentKey,i,state,afterSubBytes1,afterShiftRows1,
//	afterMixColumns1,afterAddroundKey);
//	currentKey=fullkeys[((128*(Nr+1))-1)-:128];
//	afterMixColumns2=in;
////	for(i=1; i<Nr ;i=i+1)begin
//		state=afterAddroundKey;
//		afterSubBytes2=afterSubBytes1;
//		afterShiftRows2=afterShiftRows1;
//		afterMixColumns2=afterMixColumns1;
//		currentKey=fullkeys[(((128*(Nr+1))-1)-128*i)-:128];
//	end
//		state=afterAddroundKey;
//		afterSubBytes2=afterSubBytes1;
//		afterMixColumns2=afterMixColumns1;
//		currentKey=fullkeys[127:0];
//		out=afterAddroundKey;
//end


//
//addRoundKey a (in,intermediate,fullkeys[((128*(Nr+1))-1)-:128]);
//initial begin
//	state=intermediate;
//end
//
//genvar i;
//generate
//	for(i=1; i<Nr ;i=i+1)begin : loop
//		subBytes s(state,afterSubBytes);
//		shiftRows r(afterSubBytes,afterShiftRows);
//		mixColumns m(afterShiftRows,afterMixColumns);
//		addRoundKey b(afterMixColumns,afterAddroundKey,fullkeys[(((128*(Nr+1))-1)-128*i)-:128]);
//		always@* begin
//			state=afterAddroundKey;
//		end
//	end
//
//endgenerate
//
//subBytes sr(afterAddroundKey,afterSubBytes);
//shiftRows rm(afterSubBytes,afterShiftRows);
//addRoundKey bk(afterMixColumns,afterAddroundKey,fullkeys[127:0]);

//assign out=afterAddroundKey;

endmodule