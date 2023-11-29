module ALU_CONTROL();
input [1:0]ALUOP;
input [3:0] INSTRUCCION;
output reg [3:0]ALUSELECT;

always @(ALUOP or INSTRUCCION)
if (ALUOP=2'b00)//RFORMAT
	case(INSTRUCCION)
	4'b0000: ALUSELECT=	4'b0000;//ADD
	4'b0001: ALU_SELECT= 4'b0011; //DESPLAZAMIENTO IZQD
	4'b0010: ALU_SELECT= 4'b0100; // MENOR QUE
	4'b0011: ALU_SELECT= 4'b????; // MENOR QUE UNSIGNED
	4'b0100: ALU_SELECT= 4'b0111; // XOR
	4'b0101: ALU_SELECT= 4'b0101; // DESPLAZAMIENTO DRCH
	4'b0110: ALU_SELECT= 4'b0010; // OR
	4'b0111: ALU_SELECT= 4'b0001; // AND
	4'b1000: ALU_SELECT= 4'b0110; // SUB
else if (ALUOP==2'b01)//IFORMAT
	ALUSELECT = 
else
	ALUSELECT =
endmodule 