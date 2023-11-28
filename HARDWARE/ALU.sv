module ALU (A, B, RESULT, OPERATION, ZERO);
	input logic [31:0] A, B;
	input logic [3:0] OPERATION;
	output logic ZERO;
	output logic [31:0] RESULT;
	
always_comb

		if (OPERATION==4'b0000)
			RESULT = A+B;		//SUMA
			
		else if (OPERATION==4'b0001)
			RESULT = A&B;		//AND
			
		else if (OPERATION==4'b0010)
			RESULT = A | B;	//OR
			
		else if (OPERATION==4'b0011)
			RESULT = A << B;		//Desplazamiento izquierda (A tantos desplazamientos como indique B)
			
		else if (OPERATION==4'b0100)
			RESULT = (A<B)?1:0;	//A menor que B = 1
			
		else if (OPERATION==4'b0101)
			RESULT = A >> B;		//Desplazamiento derecha lógico (A tantos desplazamientos como indique B)
			
		else if (OPERATION==4'b0110)
			RESULT = A-B;			//RESTA
			
		else if (OPERATION==4'b0111)
			RESULT = A^B;			//XOR
			
		else 
			RESULT=0;
		
assign ZERO = (RESULT==0) ? 1:0;

endmodule
