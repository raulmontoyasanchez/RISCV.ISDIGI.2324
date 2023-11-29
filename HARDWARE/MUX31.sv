module MUX31 (IN1, IN2, SELECT, OUT);
	input logic [31:0] IN1, IN2;
	input logic [1:0] SELECT;
	output logic [31:0] OUT;
	
always_comb
	if (SELECT == 2'b00)
		OUT = IN1;
	else if (SELECT == 2'b01)
		OUT = 32'd0;
	else if (SELECT == 2'b10)
		OUT = IN2;
	else if (SELECT == 2'b11)
		OUT = 32'd0;
	
endmodule 