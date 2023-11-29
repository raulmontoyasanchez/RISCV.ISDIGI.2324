module ALU (A, B, RESULT, OPERATION, ZERO);

	input logic [31:0] A, B;
	input logic [3:0] OPERATION;
	output logic ZERO;
	output logic [31:0] RESULT;

	//EL FLAG ZERO SE ACTIVA A NIVEL ALTO

always_comb
		case(OPERATION)

		4'b0000: RESULT = A+B;			//SUMA
		4'b0001: RESULT = A&B;			//AND
		4'b0010: RESULT = A | B;		//OR
		4'b0011: RESULT = A << B;		//Desplazamiento izquierda (A tantos desplazamientos como indique B)
		4'b0100: RESULT = (A<B) ? 1:0;//A menor que B = 1
		4'b0101: RESULT = A >> B;		//Desplazamiento derecha lógico (A tantos desplazamientos como indique B)
		4'b0110: RESULT = A-B;			//RESTA
		4'b0111: RESULT = A^B;			//XOR

		//INSTRUCCIONES DE SALTO CONDICIONAL (B-FORMAT)
		//FORZAMOS QUE RESULT SEA IGUAL A CERO PARA ACTIVAR EL FLAG 
		4'b1000: RESULT = (A==B) ? 0:1;	//BEQ
		4'b1001: RESULT = (A!=B) ? 0:1;	//BNE
		4'b1010: RESULT = (A<B) ? 0:1;	//BLT
		4'b1011: RESULT = (A>=B) ? 0:1;	//BGE

		default: RESULT = 0;
		endcase 
		
assign ZERO = (RESULT==0) ? 1:0;

endmodule
