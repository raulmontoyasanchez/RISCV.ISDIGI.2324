module CONTROL #(parameter TAM_INS=7, TAM_ALUOP=3, TAM_AUIPCLUI=2) (INSTRUCTION, BRANCH, MEMREAD, MEMTOREG, ALUOP, MEMWRITE, ALUSRC, REGWRITE, AUIPCLUI); 

input [TAM_INS-1:0] INSTRUCTION;

output reg BRANCH, MEMREAD, MEMTOREG, MEMWRITE,  ALUSRC, REGWRITE;
output reg [TAM_ALUOP-1:0] ALUOP;
output reg [TAM_AUIPCLUI-1:0] AUIPCLUI;


//CASOS PARA CADA OPCODE (INSTRUCCTION): LOGICA DE SALIDA

always_comb
begin

	case(INSTRUCTION) 
	
	//R-FORMAT (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)
	
	7'b0110011:
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b0;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b000;
	AUIPCLUI	= 	2'b10;
	end
	
	//I-FORMAT INMEDIATA (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
	
	7'b0010011: 
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b001;
	AUIPCLUI	= 	2'b10;
	end
	
	//I-FORMAT CARGA (LW)
	
	7'b0000011: 
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b1;
	MEMTOREG	= 	1'b1;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b010;
	AUIPCLUI	= 	2'b10;
	end
	
	//S-FORMAT (SW)
	
	7'b0100011: 
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b1;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b0;
	ALUOP		= 	3'b011;
	AUIPCLUI	= 	2'b10;
	end
	
	//B-FORMAT (BEQ, BNE)
	
	7'b1100011: 
	begin
	BRANCH	= 	1'b1;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b0;
	ALUOP		= 	3'b100;
	AUIPCLUI	= 	2'b10;
	end
	
	//U-FORMAT (LUI)
	
	7'b0110111: 
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b101;
	AUIPCLUI	= 	2'b10;
	end
	
	//U-FORMAT (AUIPC)
	
	7'b0010111: 
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b110;
	AUIPCLUI	= 	2'b01;
	end
	
	//J-FORMAT (JAL)
	
	7'b1101111: 
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b1;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b111;
	AUIPCLUI	= 	2'b10;
	end
	
	//J-FORMAT (JALR) 
	
	7'b1100111: 
	begin
	BRANCH		= 	1'b0;
	MEMREAD		= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC		= 	1'b1;
	REGWRITE	= 	1'b1;
	ALUOP		= 	3'b111;
	AUIPCLUI	= 	2'b10;
	end
	
	//DEFAULT
	
	default:
	begin
	BRANCH	= 	1'b0;
	MEMREAD	= 	1'b0;
	MEMTOREG	= 	1'b0;
	MEMWRITE	= 	1'b0;
	ALUSRC	= 	1'b0;
	REGWRITE	= 	1'b0;
	ALUOP		= 	3'b000;
	AUIPCLUI	= 	2'b10;
	end

	endcase
	
end
	
endmodule

