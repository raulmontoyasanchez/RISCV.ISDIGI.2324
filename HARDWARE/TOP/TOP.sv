module TOP #(parameter ROM_INS=32, RAM_DATA=32, ROM_ADD=10, RAM_ADD=10) (CLK, RESET_N, RAM_DATAOUT, RAM_DATAIN,RAM_ADDRESS, RAM_OUTPUT_ENABLE,RAM_ENABLE_WR );

//VARIABLES GENERALES
input CLK, RESET_N;

//CABLES ROM
wire [ROM_ADD-1:0] ROM_ADDRESS;
wire [ROM_INS-1:0] ROM_INSTRUCTION;
wire READ_AUX;
//wire ROM_ENABLE;

//CABLES RAM 
output wire [RAM_DATA-1:0] RAM_DATAOUT;
output wire [RAM_DATA-1:0] RAM_DATAIN;
output wire [ROM_ADD-1:0] RAM_ADDRESS;
output wire RAM_OUTPUT_ENABLE;
output wire RAM_ENABLE_WR;


assign READ_AUX = !RAM_ENABLE_WR;
//RAM INSTANCIA
RAM RAM_INST(
.CLK(CLK),
.RSTa(RESET_N),
.WR(RAM_ENABLE_WR), 
.OE(1'b1), 
.DATA_IN(RAM_DATAIN), 
.ADDRESS(RAM_ADDRESS), 
.DATA_OUT(RAM_DATAOUT)
);

//ROM INSTANCIA
ROM ROM_INST(
.INS_ADDRESS(ROM_ADDRESS),
.INSTRUCTION_OUT(ROM_INSTRUCTION),
.READ_EN(1'b1)
);

//CORE INSTANCIA
CORE CORE_INST(
.CLK(CLK),
.RESET_N(RESET_N),
.DATA_IMEM(ROM_INSTRUCTION),
.DATA_READ_DMEM(RAM_DATAOUT),
.DIR_IMEM(ROM_ADDRESS),
.DIR_DMEM(RAM_ADDRESS),
.DATA_WRITE_DMEM(RAM_DATAIN),
.READ(READ_AUX),
.WRITE(RAM_ENABLE_WR)
);

endmodule 