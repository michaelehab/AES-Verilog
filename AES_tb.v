module AES_tb;

wire led;
reg enable;

AES a(enable, led);

initial begin
	$monitor("Led = %b", led);
	// Setting the initial values
	enable = 1;
	#10;
	
	// Turning off reset to check if the led turns on
	enable = 0;
	#10;
	
	// Turning on reset to check if the led turns off
	enable = 1;
	#10;
end

endmodule
