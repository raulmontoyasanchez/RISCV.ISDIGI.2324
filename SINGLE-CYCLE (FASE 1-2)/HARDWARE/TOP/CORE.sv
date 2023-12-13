//CORE

module CORE(CLK, RESET_N, DATA_IMEM, DATA_READ_DMEM, DIR_IMEM, DIR_DMEM, DATA_WRITE_DMEM, READ, WRITE);

//DECLARACION DE ENTRADAS Y SALIDAS

input CLK, RESET_N;
input [31:0] DATA_IMEM;
input [31:0] DATA_READ_DMEM;

output [31:0] DIR_IMEM;
output [31:0] DIR_DMEM;
output [31:0] DATA_WRITE_DMEM;
output READ, WRITE;

//DECLARACION DE CONEXIONES AUXILIARES ENTRE MODULOS

wire [31:0] READ_DATA1_AUX, READ_DATA2_AUX, INMEDIATO_AUX, ALURESULT_AUX, MUX_OUT1, MUX_OUT2, MUX_OUT3, SUMA_PC;
wire BRANCH_AUX, ZERO_AUX, MEMREAD_AUX, MEMTOREG_AUX, MEMWRITE_AUX, ALUSRC_AUX, REGWRITE_AUX;
wire [1:0] AUIPCLUI_AUX;
wire [2:0] ALUOP_AUX;
wire [3:0] ALUSELECT_AUX;



wire [6:0]INSTRUCTION60;
wire [4:0]INSTRUCTION1915;
wire [4:0]INSTRUCTION2420;
wire [4:0]INSTRUCTION117;
wire [3:0]INSTRUCTION301412;
wire [31:0]INSTRUCTION;

reg [31:0] PC;


//ASIGACIONES CONTINUAS 


assign  DIR_IMEM = PC;
assign  DIR_DMEM = ALURESULT_AUX;
assign  DATA_WRITE_DMEM = READ_DATA2_AUX;
assign  WRITE = (MEMWRITE_AUX) ? 1'b1:1'b0;
assign  READ = (MEMREAD_AUX) ? 1'b1:1'b0;

assign INSTRUCTION60 = DATA_IMEM[6:0] ;
assign INSTRUCTION1915 = DATA_IMEM[19:15];
assign INSTRUCTION2420 = DATA_IMEM[24:20];
assign INSTRUCTION117 = DATA_IMEM[11:7] ;
assign INSTRUCTION301412 = {DATA_IMEM[30], DATA_IMEM[14:12]};
assign INSTRUCTION = DATA_IMEM;
//PROGRAM COUNTER


always @(posedge CLK or negedge RESET_N) 
begin
    if (!RESET_N)
        PC <= 32'b0;
    else   
        PC <= PC + SUMA_PC;
end

assign SUMA_PC = (BRANCH_AUX && ZERO_AUX) ? INMEDIATO_AUX:4;


//INSTANCIAS

//DATA_IMEM ES LA INSTRUCCION SALIDA DE LA ROM

CONTROL CONTROL_inst (.INSTRUCTION(INSTRUCTION60), .BRANCH(BRANCH_AUX), .MEMREAD(MEMREAD_AUX), .MEMTOREG(MEMTOREG_AUX), .ALUOP(ALUOP_AUX), .MEMWRITE(MEMWRITE_AUX), .ALUSRC(ALUSRC_AUX), .REGWRITE(REGWRITE_AUX), .AUIPCLUI(AUIPCLUI_AUX));


GENINM GENINM_inst (.INSTRUCCION(INSTRUCTION), .INMEDIATO(INMEDIATO_AUX));


MUX MUX_inst1 (.IN2(READ_DATA2_AUX), .IN1(INMEDIATO_AUX), .SELECT(ALUSRC_AUX), .OUT(MUX_OUT1)); //MUX SELECCIONA REGISTRO O INMEDIATO
MUX MUX_inst2 (.IN1(DATA_READ_DMEM), .IN2(ALURESULT_AUX), .SELECT(MEMTOREG_AUX), .OUT(MUX_OUT2)); // MUX SELECCIONA SI MEMTOREG O NO DESPUES RAM
MUX31 MUX31_inst3 (.IN1(PC), .IN2(READ_DATA1_AUX), .SELECT(AUIPCLUI_AUX), .OUT(MUX_OUT3)); //MUX 3 A 1
//FALTAN LOS DOS SUMADORES

BANCO_REGISTROS BANCO_REGISTRO_inst (.CLK(CLK), .RESET_N(RESET_N), .READ_REG1(INSTRUCTION1915), .READ_REG2(INSTRUCTION2420), .WRITE_REG(INSTRUCTION117), .DATA_IN(MUX_OUT2), .WRITE_ENABLE(MEMTOREG_AUX), .READ_DATA1(READ_DATA1_AUX), .READ_DATA2(READ_DATA2_AUX));	


ALU ALU_inst(.A(MUX_OUT3), .B(MUX_OUT1), .RESULT(ALURESULT_AUX), .OPERATION(ALUSELECT_AUX), .ZERO(ZERO_AUX));


ALU_CONTROL ALU_CONTROL_inst(.ALUOP(ALUOP_AUX), .INSTRUCCION(INSTRUCTION301412), .ALUSELECT(ALUSELECT_AUX));


endmodule 