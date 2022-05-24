module keyExpansion #(parameter nk=4,parameter nr=10)(key,w);
// The first [(nk*32)-1 ]-bit key that we use to generate the rest of the keys of the other rounds.
// [(nk*32)-1 ] is the key length (128-bit key, 192-bit key or 256-bit key for nK=4,6 or 8 respectively).
input [0 : (nk * 32) - 1] key;  
// w represents the array that will store all the generated keys of all rounds.
/* [(128 * (nr + 1)) - 1] this formula is meant to calculate the length of W ; so that it can store all the
generated keys of all rounds.*/ 
output reg [0 : (128 * (nr + 1)) - 1] w;
reg [0:31] temp;
reg [0:31] r;
reg [0:31] rot; // It stores the returned value from the function rotword().
reg [0:31] x;	//It stores the returned value from the function subwordx().
reg [0:31] rconv; //It stores the returned value from the function rconx().
reg [0:31]new;

integer i;
/*
	We generate all the keys needed in the encryption and decryption at the beginning of the encryption or decryption
 and store them, then we use them in the AES_Encrypt and AES_Decrypt modules as needed according to the current 
 round.
*/
/*
 The functions:
 1) subwordx() applies a table lookup to all to all four bytes of the sent word. subwordx() calls the function
	 c() four times, each time it sends to c() 1-byte to perform the table lookup on it.
 2) rconx() contains the values given by [x^(i-1),{00},{00},{00}], with x^(i-1) being powers 
	 of x (x is denoted as {02}) in the field GF(28).
 3) rotword() applies a cyclic shift of the bytes in a word. For example,{09cf4f3c} is changed into {cf4f3c09}
	 after applying this function.
*/

/*
		The pseudo-code of the this algorithm is found in the NIST.pdf attached to the repository with some modification
	in the code to fit with verilog.
*/
/*
		For simplicity, We are going to explain the storing mechanism of the generated keys on an example of
	128-bit key.It would be easy to apply the same concept on 192-bit and 256-bit keys. We would explain it in one 
	round only. The next rounds would perform the same operations.
	
	-The example:
		-Note that in case of 128-bit key w[0:1407].
		
		1) when w=key then w= {1279*{0}:key} where 1279*{0} means that the first 1279 bits are all zero valued
			and the end of the w array contains the current 128-bit key.
		2) when temp = w[(128 * (nr + 1) - 32) +: 32] then temp=w[1376 +:32] so temp in the first round would contain
			the last 32-bit word of the the current key. 
		3) After performing (temp = SubWord(RotWord(temp)) xor Rcon[i/Nk]) or (temp = SubWord(temp)), We would perform
			(new = w[(128*(nr+1)-(nk*32))+:32] ^ temp) which is (new=w[1280+:32] ^ temp) in the first round,
			where w[(128*(nr+1)-(nk*32))+:32] here is equivelent to w[i-Nk] in the pseudo-code. Now we have the new
			generated key word (new) and we need to add it at the end of (W) array.
		4) We would shift W by 32-bit to the left to empty space to the new generated key word.
		5) w = {w[0 : (128 * (nr + 1) - 32) - 1], new} is w={w[0:1375],new} where w now contains w={1247*{0}:key:new} 
			where 1247*{0} means that the first 1247 bits are all zero valued and they are followed by the original 
			128-bit key, which are followed by the new generated 32-bit key.
		6) Repeat this process for the rest of the rounds.At the end of all the rounds we would have all the W array
			filled with all the keys.
	
*/
always@* begin
//The first [(nk*32)-1 ]-bit key is stored in W.
	w = key;    
	for(i = nk; i < 4*(nr + 1); i = i + 1) begin
	temp = w[(128 * (nr + 1) - 32) +: 32];
	if(i % nk == 0) begin
		rot = rotword(temp); // A call to the function rotword() is done and the returned value is stored in rot.
		x = subwordx (rot);	//A call to the function subwordx() is done and the returned value is stored in x.
		rconv = rconx (i/nk); //A call to the function rconx() is done and the returned value is stored in rconv.
		temp = x ^ rconv;   
	end
	else if(nk >6 && i % nk == 4) begin
		temp = subwordx(temp);
	end
	new = (w[(128*(nr+1)-(nk*32))+:32] ^ temp);
	// We would shift W by 32 bit to the left to add the new generated key word (new) at its end.
	w = w << 32;
	w = {w[0 : (128 * (nr + 1) - 32) - 1], new};
end

end



function [0:31] rotword;
input [0:31] x;
begin
		rotword={x[8:31],x[0:7]};
end
endfunction

function [0:31] subwordx;
input [0:31] a;
begin
subwordx[0:7]=c(a[0:7]);
subwordx[8:15]=c(a[8:15]);
subwordx[16:23]=c(a[16:23]);
subwordx[24:31]=c(a[24:31]);
end
endfunction

function [7:0] c(input [7:0] a);  
begin
    case (a)
      8'h00: c=8'h63;
	   8'h01: c=8'h7c;
	   8'h02: c=8'h77;
	   8'h03: c=8'h7b;
	   8'h04: c=8'hf2;
	   8'h05: c=8'h6b;
	   8'h06: c=8'h6f;
	   8'h07: c=8'hc5;
	   8'h08: c=8'h30;
	   8'h09: c=8'h01;
	   8'h0a: c=8'h67;
	   8'h0b: c=8'h2b;
	   8'h0c: c=8'hfe;
	   8'h0d: c=8'hd7;
	   8'h0e: c=8'hab;
	   8'h0f: c=8'h76;
	   8'h10: c=8'hca;
	   8'h11: c=8'h82;
	   8'h12: c=8'hc9;
	   8'h13: c=8'h7d;
	   8'h14: c=8'hfa;
	   8'h15: c=8'h59;
	   8'h16: c=8'h47;
	   8'h17: c=8'hf0;
	   8'h18: c=8'had;
	   8'h19: c=8'hd4;
	   8'h1a: c=8'ha2;
	   8'h1b: c=8'haf;
	   8'h1c: c=8'h9c;
	   8'h1d: c=8'ha4;
	   8'h1e: c=8'h72;
	   8'h1f: c=8'hc0;
	   8'h20: c=8'hb7;
	   8'h21: c=8'hfd;
	   8'h22: c=8'h93;
	   8'h23: c=8'h26;
	   8'h24: c=8'h36;
	   8'h25: c=8'h3f;
	   8'h26: c=8'hf7;
	   8'h27: c=8'hcc;
	   8'h28: c=8'h34;
	   8'h29: c=8'ha5;
	   8'h2a: c=8'he5;
	   8'h2b: c=8'hf1;
	   8'h2c: c=8'h71;
	   8'h2d: c=8'hd8;
	   8'h2e: c=8'h31;
	   8'h2f: c=8'h15;
	   8'h30: c=8'h04;
	   8'h31: c=8'hc7;
	   8'h32: c=8'h23;
	   8'h33: c=8'hc3;
	   8'h34: c=8'h18;
	   8'h35: c=8'h96;
	   8'h36: c=8'h05;
	   8'h37: c=8'h9a;
	   8'h38: c=8'h07;
	   8'h39: c=8'h12;
	   8'h3a: c=8'h80;
	   8'h3b: c=8'he2;
	   8'h3c: c=8'heb;
	   8'h3d: c=8'h27;
	   8'h3e: c=8'hb2;
	   8'h3f: c=8'h75;
	   8'h40: c=8'h09;
	   8'h41: c=8'h83;
	   8'h42: c=8'h2c;
	   8'h43: c=8'h1a;
	   8'h44: c=8'h1b;
	   8'h45: c=8'h6e;
	   8'h46: c=8'h5a;
	   8'h47: c=8'ha0;
	   8'h48: c=8'h52;
	   8'h49: c=8'h3b;
	   8'h4a: c=8'hd6;
	   8'h4b: c=8'hb3;
	   8'h4c: c=8'h29;
	   8'h4d: c=8'he3;
	   8'h4e: c=8'h2f;
	   8'h4f: c=8'h84;
	   8'h50: c=8'h53;
	   8'h51: c=8'hd1;
	   8'h52: c=8'h00;
	   8'h53: c=8'hed;
	   8'h54: c=8'h20;
	   8'h55: c=8'hfc;
	   8'h56: c=8'hb1;
	   8'h57: c=8'h5b;
	   8'h58: c=8'h6a;
	   8'h59: c=8'hcb;
	   8'h5a: c=8'hbe;
	   8'h5b: c=8'h39;
	   8'h5c: c=8'h4a;
	   8'h5d: c=8'h4c;
	   8'h5e: c=8'h58;
	   8'h5f: c=8'hcf;
	   8'h60: c=8'hd0;
	   8'h61: c=8'hef;
	   8'h62: c=8'haa;
	   8'h63: c=8'hfb;
	   8'h64: c=8'h43;
	   8'h65: c=8'h4d;
	   8'h66: c=8'h33;
	   8'h67: c=8'h85;
	   8'h68: c=8'h45;
	   8'h69: c=8'hf9;
	   8'h6a: c=8'h02;
	   8'h6b: c=8'h7f;
	   8'h6c: c=8'h50;
	   8'h6d: c=8'h3c;
	   8'h6e: c=8'h9f;
	   8'h6f: c=8'ha8;
	   8'h70: c=8'h51;
	   8'h71: c=8'ha3;
	   8'h72: c=8'h40;
	   8'h73: c=8'h8f;
	   8'h74: c=8'h92;
	   8'h75: c=8'h9d;
	   8'h76: c=8'h38;
	   8'h77: c=8'hf5;
	   8'h78: c=8'hbc;
	   8'h79: c=8'hb6;
	   8'h7a: c=8'hda;
	   8'h7b: c=8'h21;
	   8'h7c: c=8'h10;
	   8'h7d: c=8'hff;
	   8'h7e: c=8'hf3;
	   8'h7f: c=8'hd2;
	   8'h80: c=8'hcd;
	   8'h81: c=8'h0c;
	   8'h82: c=8'h13;
	   8'h83: c=8'hec;
	   8'h84: c=8'h5f;
	   8'h85: c=8'h97;
	   8'h86: c=8'h44;
	   8'h87: c=8'h17;
	   8'h88: c=8'hc4;
	   8'h89: c=8'ha7;
	   8'h8a: c=8'h7e;
	   8'h8b: c=8'h3d;
	   8'h8c: c=8'h64;
	   8'h8d: c=8'h5d;
	   8'h8e: c=8'h19;
	   8'h8f: c=8'h73;
	   8'h90: c=8'h60;
	   8'h91: c=8'h81;
	   8'h92: c=8'h4f;
	   8'h93: c=8'hdc;
	   8'h94: c=8'h22;
	   8'h95: c=8'h2a;
	   8'h96: c=8'h90;
	   8'h97: c=8'h88;
	   8'h98: c=8'h46;
	   8'h99: c=8'hee;
	   8'h9a: c=8'hb8;
	   8'h9b: c=8'h14;
	   8'h9c: c=8'hde;
	   8'h9d: c=8'h5e;
	   8'h9e: c=8'h0b;
	   8'h9f: c=8'hdb;
	   8'ha0: c=8'he0;
	   8'ha1: c=8'h32;
	   8'ha2: c=8'h3a;
	   8'ha3: c=8'h0a;
	   8'ha4: c=8'h49;
	   8'ha5: c=8'h06;
	   8'ha6: c=8'h24;
	   8'ha7: c=8'h5c;
	   8'ha8: c=8'hc2;
	   8'ha9: c=8'hd3;
	   8'haa: c=8'hac;
	   8'hab: c=8'h62;
	   8'hac: c=8'h91;
	   8'had: c=8'h95;
	   8'hae: c=8'he4;
	   8'haf: c=8'h79;
	   8'hb0: c=8'he7;
	   8'hb1: c=8'hc8;
	   8'hb2: c=8'h37;
	   8'hb3: c=8'h6d;
	   8'hb4: c=8'h8d;
	   8'hb5: c=8'hd5;
	   8'hb6: c=8'h4e;
	   8'hb7: c=8'ha9;
	   8'hb8: c=8'h6c;
	   8'hb9: c=8'h56;
	   8'hba: c=8'hf4;
	   8'hbb: c=8'hea;
	   8'hbc: c=8'h65;
	   8'hbd: c=8'h7a;
	   8'hbe: c=8'hae;
	   8'hbf: c=8'h08;
	   8'hc0: c=8'hba;
	   8'hc1: c=8'h78;
	   8'hc2: c=8'h25;
	   8'hc3: c=8'h2e;
	   8'hc4: c=8'h1c;
	   8'hc5: c=8'ha6;
	   8'hc6: c=8'hb4;
	   8'hc7: c=8'hc6;
	   8'hc8: c=8'he8;
	   8'hc9: c=8'hdd;
	   8'hca: c=8'h74;
	   8'hcb: c=8'h1f;
	   8'hcc: c=8'h4b;
	   8'hcd: c=8'hbd;
	   8'hce: c=8'h8b;
	   8'hcf: c=8'h8a;
	   8'hd0: c=8'h70;
	   8'hd1: c=8'h3e;
	   8'hd2: c=8'hb5;
	   8'hd3: c=8'h66;
	   8'hd4: c=8'h48;
	   8'hd5: c=8'h03;
	   8'hd6: c=8'hf6;
	   8'hd7: c=8'h0e;
	   8'hd8: c=8'h61;
	   8'hd9: c=8'h35;
	   8'hda: c=8'h57;
	   8'hdb: c=8'hb9;
	   8'hdc: c=8'h86;
	   8'hdd: c=8'hc1;
	   8'hde: c=8'h1d;
	   8'hdf: c=8'h9e;
	   8'he0: c=8'he1;
	   8'he1: c=8'hf8;
	   8'he2: c=8'h98;
	   8'he3: c=8'h11;
	   8'he4: c=8'h69;
	   8'he5: c=8'hd9;
	   8'he6: c=8'h8e;
	   8'he7: c=8'h94;
	   8'he8: c=8'h9b;
	   8'he9: c=8'h1e;
	   8'hea: c=8'h87;
	   8'heb: c=8'he9;
	   8'hec: c=8'hce;
	   8'hed: c=8'h55;
	   8'hee: c=8'h28;
	   8'hef: c=8'hdf;
	   8'hf0: c=8'h8c;
	   8'hf1: c=8'ha1;
	   8'hf2: c=8'h89;
	   8'hf3: c=8'h0d;
	   8'hf4: c=8'hbf;
	   8'hf5: c=8'he6;
	   8'hf6: c=8'h42;
	   8'hf7: c=8'h68;
	   8'hf8: c=8'h41;
	   8'hf9: c=8'h99;
	   8'hfa: c=8'h2d;
	   8'hfb: c=8'h0f;
	   8'hfc: c=8'hb0;
	   8'hfd: c=8'h54;
	   8'hfe: c=8'hbb;
	   8'hff: c=8'h16;
	endcase
end
endfunction


function[0:31] rconx;
input [0:31] r; 
begin
 case(r)
    4'h1: rconx=32'h01000000;
    4'h2: rconx=32'h02000000;
    4'h3: rconx=32'h04000000;
    4'h4: rconx=32'h08000000;
    4'h5: rconx=32'h10000000;
    4'h6: rconx=32'h20000000;
    4'h7: rconx=32'h40000000;
    4'h8: rconx=32'h80000000;
    4'h9: rconx=32'h1b000000;
    4'ha: rconx=32'h36000000;
    default: rconx=32'h00000000;
  endcase
  end
endfunction

endmodule