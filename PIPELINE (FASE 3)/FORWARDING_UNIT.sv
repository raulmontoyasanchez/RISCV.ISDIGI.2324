//MODULO DEL FORWARDING UNIT PARA EL CONTROL DE RIESGOS DEL DISEÑO PIPELINE DEL CORE (RIESGO DE DATOS)

module FORWARDING_UNIT(RS1_FU, RS2_FU, RD_MEM, RD_WB, MEMTOREG_MEM, REGWRITE_MEM, MEMTOREG_WB, REGWRITE_WB, FORWARD_A, FORWARD_B);

//DECLARACION DE VARIABLES

//MEM == PERTENECIENTE A ETAPA DE MEMORIA
//WB == PETENECIENTE A ETAPA WRITE BACK
//FU == FORWARDING UNIT

input [4:0] RS1_FU, RS2_FU, RD_MEM, RD_WB;
input MEMTOREG_MEM, REGWRITE_MEM, MEMTOREG_WB, REGWRITE_WB;

output reg [1:0] FORWARD_A, FORWARD_B;

//CODIGO:

//FORWARD_A:

if (REGWRITE_MEM && (RD_MEM != 0) && (RD_MEM == RS1_FU))
begin 
	FORWARD_A <= 2'b10;
else if((REGWRITE_WB && (RD_WB != 0) && (RD_WB == RS1_FU)) 
	FORWARD_A <= 2'b01;
else 
	FORWARD_A <= 2'b00;
end 

//FORWARD_B:

if (REGWRITE_MEM && (RD_MEM != 0) && (RD_MEM == RS2_FU))
begin 
	FORWARD_B <= 2'b10;
else if((REGWRITE_WB && (RD_WB != 0) && (RD_WB == RS2_FU)) 
	FORWARD_B <= 2'b01;
else 
	FORWARD_B <= 2'b00;
end 

endmodule 