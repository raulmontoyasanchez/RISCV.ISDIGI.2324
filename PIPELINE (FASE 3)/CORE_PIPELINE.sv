//CORE PIPELINE 

//PENDIENTE:
//COMPROBAR EL ASSIGN DEL PC (CREO QUE ESTA BIEN YA)

module CORE(CLK, RESET_N, DATA_IMEM, DATA_READ_DMEM, DIR_IMEM, DIR_DMEM, DATA_WRITE_DMEM, READ, WRITE);

//DECLARACION DE ENTRADAS Y SALIDAS

input CLK, RESET_N;
input [31:0] DATA_IMEM;
input [31:0] DATA_READ_DMEM;

output [9:0] DIR_IMEM;
output [9:0] DIR_DMEM;
output [31:0] DATA_WRITE_DMEM;
output READ, WRITE;

//DECLARACION DE CONEXIONES AUXILIARES ENTRE MODULOS

wire [31:0] READ_DATA1_AUX, READ_DATA2_AUX, INMEDIATO_AUX, ALURESULT_AUX, MUX_OUT1, MUX_OUT2, MUX_OUT3;
wire BRANCH_AUX, ZERO_AUX, MEMREAD_AUX, MEMTOREG_AUX, MEMWRITE_AUX, ALUSRC_AUX, REGWRITE_AUX;
wire [1:0] AUIPCLUI_AUX;
wire [2:0] ALUOP_AUX;
wire [3:0] ALUSELECT_AUX;
wire MUX_SELECT2;

reg [31:0] PC;

//LA INSTRUCCION SEGMENTADA SE USA DIRECTAMENTE LAS DEL SEGMENTADO (CREO)

//wire [6:0]INSTRUCTION60;
//wire [4:0]INSTRUCTION1915;
//wire [4:0]INSTRUCTION2420;
//wire [4:0]INSTRUCTION117;
//wire [3:0]INSTRUCTION301412;

wire [31:0]INSTRUCTION;

//assign INSTRUCTION60 = DATA_IMEM[6:0] ;
//assign INSTRUCTION1915 = DATA_IMEM[19:15];
//assign INSTRUCTION2420 = DATA_IMEM[24:20];
//assign INSTRUCTION117 = DATA_IMEM[11:7] ;
//assign INSTRUCTION301412 = {DATA_IMEM[30], DATA_IMEM[14:12]};

assign INSTRUCTION = DATA_IMEM;

//ASIGACIONES CONTINUAS 

assign  PCSRC = (BRANCH_OUT_EX && ZERO_OUT_EX) ? 1'b1:1'b0; 
assign  DIR_IMEM = PC; //DUDA*
assign  DIR_DMEM = ALURESULT_OUT_EX;
assign  DATA_WRITE_DMEM = READ_DATA_2_OUT_EX; 
assign  WRITE = (MEMWRITE_OUT_EX) ? 1'b1:1'b0; 
assign  READ = (MEMREAD_OUT_EX) ? 1'b1:1'b0; 

// MULTIPLEXOR DEL PROGRAM COUNTER:

always @(posedge CLK or negedge RESET_N)
begin 
   if (!RESET_N)
       PC <= 32'b0;
   else  
		begin
      case (PCSRC) // 		MUX QUE SELECCIONA SI SUMAMOS 1 O 4 AL PC
          1'b0 : PC <= PC + 1'b4;
          1'b1 : PC <= PC_OUT_EX; 
      endcase
      end 
end

//INSTANCIAS

//DATA_IMEM ES LA INSTRUCCION SALIDA DE LA ROM

CONTROL CONTROL_inst (.INSTRUCTION(INSTRUCTION60_OUT_DI), .BRANCH(BRANCH_AUX), .MEMREAD(MEMREAD_AUX), .MEMTOREG(MEMTOREG_AUX), .ALUOP(ALUOP_AUX), .MEMWRITE(MEMWRITE_AUX), .ALUSRC(ALUSRC_AUX), .REGWRITE(REGWRITE_AUX), .AUIPCLUI(AUIPCLUI_AUX));


GENINM GENINM_inst (.INSTRUCCION(INST_OUT_IF), .INMEDIATO(INMEDIATO_AUX));


MUX MUX_inst1 (.IN1(READ_DATA_2_OUT_DI), .IN2(INMEDIATO_OUT_DI), .SELECT(ALUSRC_OUT_DI), .OUT(MUX_OUT1)); //MUX SELECCIONA REGISTRO O INMEDIATO
MUX MUX_inst2 (.IN1(DATA_READ_DMEM_ME), .IN2(ALURESULT_OUT_ME), .SELECT(MEMTOREG_OUT_ME), .OUT(MUX_OUT2)); // MUX SELECCIONA SI MEMTOREG O NO
MUX31 MUX31_inst3 (.IN1(PC_OUT_DI), .IN2(READ_DATA_1_OUT_DI), .SELECT(AUIPCLUI_OUT_DI), .OUT(MUX_OUT3)); //MUX 3 A 1 

BANCO_REGISTROS BANCO_REGISTRO_inst (.CLK(CLK), .RSTa(RSTa), .READ_REG1(INSTRUCTION1915_OUT_DI), .READ_REG2(INSTRUCTION2420_OUT_DI), .WRITE_REG(INSTRUCTION117_OUT_ME), .DATA_IN(MUX_OUT2), .WRITE_ENABLE(REGWRITE_OUT_ME), .READ_DATA1(READ_DATA1_AUX), .READ_DATA2(READ_DATA2_AUX));	

ALU ALU_inst(.A(MUX_OUT3), .B(MUX_OUT1), .RESULT(ALURESULT_AUX), .OPERATION(ALUSELECT_AUX), .ZERO(ZERO_AUX));


ALU_CONTROL ALU_CONTROL_inst(.ALUOP(ALUOP_OUT_DI), .INSTRUCCION(INSTRUCTION301412_OUT_DI), .ALUSELECT(ALUSELECT_AUX));



//				---------------						---------------				---------------					---------------					---------------					---------------						---------------



//SEGMENTADO: DISEÑO PIPELINE (FASE 3)

//1: ETAPA IF (PROGRAM COUNTER - LECTURA DE LA INSTRUCCION E INCREMENTO DEL PC) ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

reg [31:0] PC_OUT_IF;
reg [31:0] INST_OUT_IF;

always @(posedge CLK or negedge RESET_N)
begin 
   if (!RESET_N)
       PC_OUT_IF <= 32'b0;
		 INST_OUT_IF <= 32'b0; 
   else  
		 PC_OUT_IF <= PC;
		 INST_OUT_IF <= INSTRUCTION; 
end


//2: ETAPA DI (DECODIFICACION DE INSTRUCCION Y LECTURA DE REGISTROS) -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

reg [31:0] READ_DATA_1_OUT_DI;
reg [31:0] READ_DATA_2_OUT_DI;
reg [31:0] INMEDIATO_OUT_DI;

reg [6:0] INSTRUCTION60_OUT_DI;
reg [4:0] INSTRUCTION1915_OUT_DI;
reg [4:0] INSTRUCTION2420_OUT_DI;
reg [4:0] INSTRUCTION117_OUT_DI;     //COMPROBAR, RECORRE TODAS LAS ETAPAS HASTA LLEGAR A WRITE_REG DEL BANCO DE REGISTROS.
reg [3:0] INSTRUCTION301412_OUT_DI;

reg [31:0] PC_OUT_DI; 

//DECODIFICACION DE LA INSTRUCCION:

assign INSTRUCTION60_OUT_DI = INST_OUT_IF[6:0];
assign INSTRUCTION1915_OUT_DI = INST_OUT_IF[19:15];
assign INSTRUCTION2420_OUT_DI = INST_OUT_IF[24:20];
assign INSTRUCTION117_OUT_DI = INST_OUT_IF[11:7] ;
assign INSTRUCTION301412_OUT_DI = {INST_OUT_IF[30], INST_OUT_IF[14:12]};

//SEÑALES DE CONTROL QUE USAREMOS EN CADA ETAPA:
//ETAPA WRITE BACK (ESCRITURA DE REGISTRO) - MEMTOREG Y REGWRITE
//ETAPA MEMORY (MEMORIA) - BRANCH, MEMWRITE Y MEMREAD
//ETAPA EXECUTION (EJECUCION) - ALUOP, ALUSRC Y AUIPCLUI

// WB: MEMTOREG Y REGWRITE
// M: BRANCH, MEMWRITE Y MEMREAD
// EX: ALUOP, ALUSRC Y AUIPCLUI

//VARIABLES DEL REGISTRO ETAPA DI/EX DE CONTROL:

reg BRANCH_OUT_DI;
reg MEMREAD_OUT_DI;
reg MEMTOREG_OUT_DI;
reg MEMWRITE_OUT_DI;
reg ALUSRC_OUT_DI; //USADO EN EX
reg REGWRITE_OUT_DI;
reg [2:0]ALUOP_OUT_DI; //USADO EN EX
reg [1:0] AUIPCLUI_OUT_DI; //USADO EN EX

always @(posedge CLK or negedge RESET_N)
begin
	if (!RESET_N)
	begin
		BRANCH_OUT_DI <= 1'b0; 
		MEMREAD_OUT_DI <= 1'b0;
		MEMTOREG_OUT_DI <= 1'b0;
		MEMWRITE_OUT_DI <= 1'b0;
		ALUSRC_OUT_DI <= 1'b0;
	    REGWRITE_OUT_DI <= 1'b0;
		ALUOP_OUT_DI <= 3'b0;
		AUIPCLUI_OUT_DI <= 2'b0;
		READ_DATA_1_OUT_DI <= 32'b0;
		READ_DATA_2_OUT_DI <= 32'b0;
		INMEDIATO_OUT_DI <= 32'b0;	
		PC_OUT_DI <= 32'b0;
	end
	else
	begin
		BRANCH_OUT_DI <= BRANCH_AUX;
		MEMREAD_OUT_DI <= MEMREAD_AUX;
		MEMTOREG_OUT_DI <= MEMTOREG_AUX;
		MEMWRITE_OUT_DI <= MEMWRITE_AUX;
		ALUSRC_OUT_DI <= ALUSRC_AUX;
	   REGWRITE_OUT_DI <= REGWRITE_AUX;
		ALUOP_OUT_DI <= ALUOP_AUX;
		AUIPCLUI_OUT_DI <= AUIPCLUI_AUX;
		READ_DATA_1_OUT_DI <= READ_DATA1_AUX;
		READ_DATA_2_OUT_DI <= READ_DATA2_AUX;
		INMEDIATO_OUT_DI <= INMEDIATO_AUX;
		PC_OUT_DI <= PC_OUT_IF;
	end
end		
	
//3: ETAPA EX (EJECUCION) ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

reg [31:0] ALURESULT_OUT_EX;
reg ZERO_OUT_EX;

reg [31:0] PC_OUT_EX;

reg [31:0] SUM_AUX_EX; //VARIABLE LOCAL DE LA ETAPA EX
assign SUM_AUX_EX = PC_OUT_DI + INMEDIATO_OUT_DI; 

reg [31:0] READ_DATA_2_OUT_EX;

reg [4:0] INSTRUCTION117_OUT_EX;

//VARIABLES DEL REGISTRO ETAPA EX/ME DE CONTROL:

reg BRANCH_OUT_EX; //USADO EN ME
reg MEMREAD_OUT_EX; //USADO EN ME
reg MEMTOREG_OUT_EX;
reg MEMWRITE_OUT_EX; //USADO EN ME
reg REGWRITE_OUT_EX;

always @(posedge CLK or negedge RESET_N)
begin
	if (!RESET_N)
	begin
		BRANCH_OUT_EX <= 1'b0; 
		MEMREAD_OUT_EX <= 1'b0; 
		MEMTOREG_OUT_EX <= 1'b0;
		MEMWRITE_OUT_EX <= 1'b0; 
	    REGWRITE_OUT_EX <= 1'b0;
		ALURESULT_OUT_EX <= 32'b0;
		ZERO_OUT_EX <= 1'b0;
		READ_DATA_2_OUT_EX <= 32'b0;
		INSTRUCTION117_OUT_EX <= 32'b0;
		PC_OUT_EX <= 32'b0;
	end
	else
	begin
		BRANCH_OUT_EX <= BRANCH_OUT_DI; 
		MEMREAD_OUT_EX <= MEMREAD_OUT_DI;
		MEMTOREG_OUT_EX <= MEMTOREG_OUT_DI;
		MEMWRITE_OUT_EX <= MEMWRITE_OUT_DI;
	   REGWRITE_OUT_EX <= REGWRITE_OUT_DI;
		ALURESULT_OUT_EX <= ALURESULT_AUX;	
		ZERO_OUT_EX <= ZERO_AUX;
		READ_DATA_2_OUT_EX <= READ_DATA_2_OUT_DI;
		INSTRUCTION117_OUT_EX <= INSTRUCTION117_OUT_DI;
		PC_OUT_EX <= SUM_AUX_EX;
	end
end		
		
		
//4 Y 5: ETAPA ME y WB (MEMORIA Y ESCRITURA EN REGISTRO) ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

reg [4:0] INSTRUCTION117_OUT_ME;
reg [31:0] ALURESULT_OUT_ME;
reg [31:0] DATA_READ_DMEM_ME;

//VARIABLES DEL REGISTRO ETAPA MEM/WB DE CONTROL:

reg MEMTOREG_OUT_ME; //USADO EN WB
reg REGWRITE_OUT_ME; //USADO EN WB

always @(posedge CLK or negedge RESET_N)
begin
	if (!RESET_N)
	begin
		MEMTOREG_OUT_ME <= 1'b0;
		REGWRITE_OUT_ME <= 1'b0;
		ALURESULT_OUT_ME <= 32'b0;
		INSTRUCTION117_OUT_ME <= 32'b0;
		DATA_READ_DMEM_ME <= 32'b0;
	end
	else
	begin
		MEMTOREG_OUT_ME <= MEMTOREG_OUT_EX;
		REGWRITE_OUT_ME <= REGWRITE_OUT_EX;
		INSTRUCTION117_OUT_ME <= INSTRUCTION117_OUT_EX;
		ALURESULT_OUT_ME <= ALURESULT_OUT_EX;
		DATA_READ_DMEM_ME <= DATA_READ_DMEM; 
	end
end


//FIN

endmodule 