module ALU_CONTROL(ALUOP, INSTRUCCION, ALUSELECT);
input [2:0]ALUOP;
input [3:0] INSTRUCCION;
output reg [3:0]ALUSELECT;

always_comb
case (ALUOP)
3'b000: begin //RFORMAT
	case(INSTRUCCION)
	4'b0000: ALUSELECT=	4'b0000;//ADD
	4'b0001: ALUSELECT= 4'b0011; //DESPLAZAMIENTO IZQD
	4'b0010: ALUSELECT= 4'b0100; // MENOR QUE
	4'b0100: ALUSELECT= 4'b0111; // XOR
	4'b0101: ALUSELECT= 4'b0101; // DESPLAZAMIENTO DRCH
	4'b0110: ALUSELECT= 4'b0010; // OR
	4'b0111: ALUSELECT= 4'b0001; // AND
	4'b1000: ALUSELECT= 4'b0110; // RESTA
	default: ALUSELECT = 4'b0000;
	endcase
	end
3'b001: begin// I FORMAT
	case(INSTRUCCION)
	4'bx000: ALUSELECT=	4'b0000;//ADDI
	4'bx001: ALUSELECT= 4'b0011; // SLLI
	4'bx010: ALUSELECT= 4'b0100; // SLTI
	4'bx100: ALUSELECT= 4'b0111; // XORI
	4'bx101: ALUSELECT= 4'b0101; // SRLI
	4'bx110: ALUSELECT= 4'b0010; // ORI
	4'bx111: ALUSELECT= 4'b0001; // ANDI
	default: ALUSELECT = 4'b0000;
	endcase
	end
3'b010: // INSTRUCCIONES DE CARGA (LOAD WORD)
	 ALUSELECT= 4'b0000; 
3'b011: // S-FORMAT
	 ALUSELECT= 4'b0000; 
3'b100: // B-FORMAT
	begin 
	case (INSTRUCCION)
	4'bx000: ALUSELECT= 4'b1000; //BEQ
	4'bx001: ALUSELECT=4'b1001;	//BNE
	4'bx100: ALUSELECT=4'b1010;	//BLT
	4'bx101: ALUSELECT=4'b1011;	//BGE
	default: ALUSELECT = 4'b0000;
	endcase 
	end 
3'b101: // U-FORMAT (LUI)
	 ALUSELECT= 4'b0000; 
3'b110: // U_FORMAT (LUIPC)
	 ALUSELECT= 4'b0000; 
3'b111: // J FORMAT
	 ALUSELECT= 4'b0000; 
default:ALUSELECT= 4'b0000; 
endcase
endmodule  

