`timescale 1ns/100ps

module tb_ALU ();
	localparam T = 20;
	
	//DUV instance
	
	logic CLK;
	logic [31:0] A, B;
	logic [31:0] RESULT;
	logic [3:0] OPERATION;
	logic ZERO;
	
	ALU duv (
		.A(A),
		.B(B),
		.RESULT(RESULT),
		.OPERATION(OPERATION),
		.ZERO(ZERO)
		);
		
	//Clock generation
	
	always 
	begin
		#(T/2) CLK = ~CLK;
	end
	
	// test procedure
	
	initial
	begin 
		CLK = 0;
		A = 0;
		B = 0;
		OPERATION = 0;
		
		#(T*10)
		A = 32'b11101100;
		B = 32'b001001011000;
		#(T*10)
		OPERATION = 4'b0000;
		#(T*10)
		OPERATION = 4'b0001;
		#(T*10)
		OPERATION = 4'b0100;
		#(T*10)
		OPERATION = 4'b0011;
		#(T*10)
		OPERATION = 4'b1111;
		#(T*10)
		A = 32'b000111000100;
		B = 32'b00010101101101000001;
		OPERATION = 4'b0010;
		#(T*10)
		OPERATION = 4'b0110;
		#(T*10)
		A = 32'b01100100;
		B = 32'b00011010;
		OPERATION = 4'b0111;
		#(T*10)
		
		$display("test finished");
		$stop;
	end
	
endmodule