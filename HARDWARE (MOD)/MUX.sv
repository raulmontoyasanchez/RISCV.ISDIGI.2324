module MUX(IN1, IN2, SELECT, OUT);
	input logic [31:0] IN1, IN2;
	input logic SELECT;
	output logic [31:0] OUT;
	
always_comb
	if (SELECT == 1'b1)
		OUT = IN1;
	else if (SELECT == 1'b0)
		OUT = IN2;
	
endmodule 