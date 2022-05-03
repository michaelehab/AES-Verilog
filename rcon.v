module rcon(
input [3:0] r,
output reg [31:0] rcon // output reg [3:0]  rcon [7:0] // can't do that ._. 
);

always @(*)
 case(r)
    4'h1: rcon=32'h01000000;
    4'h2: rcon=32'h02000000;
    4'h3: rcon=32'h04000000;
    4'h4: rcon=32'h08000000;
    4'h5: rcon=32'h10000000;
    4'h6: rcon=32'h20000000;
    4'h7: rcon=32'h40000000;
    4'h8: rcon=32'h80000000;
    4'h9: rcon=32'h1b000000;
    4'ha: rcon=32'h36000000;
    default: rcon=32'h00000000;
  endcase
endmodule