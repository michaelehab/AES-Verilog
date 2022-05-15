module AES_tb;
reg clk;
wire led;
reg reset;
reg enable;
AES a(clk, reset, enable, led);
initial begin
	$monitor("Led = %b", led);
	// Setting the initial values
	enable = 1;
	reset = 1;
	clk = 0;
	#10;
	// Turning off reset to check if the led turns on
	reset = 0;
	#10;
	// Turning on reset to check if the led turns off
	reset = 1;
	#10;
	reset = 0;
end

always begin
	#(10/2) clk = ~clk;
end

endmodule
