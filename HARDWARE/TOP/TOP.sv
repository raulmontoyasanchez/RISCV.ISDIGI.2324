module TOP #(parameter ROM_INS=32, RAM_DATA=32, ROM_ADD=10, RAM_ADD=10) (CLK, RST, ROM_ADDRESS, RAM_ADDRESS, RAM_DATAIN, ROM_INTRUCTION, RAM_DATAOUT);

input CLK, RST;
input [ROM_ADD-1:0] ROM_ADDRESS;
input [ROM_ADD-1:0] RAM_ADDRESS;
input [RAM_DATA-1:0] RAM_DATAIN;

output [ROM_INS-1:0] ROM_INSTRUCTION;
output [RAM_DATA-1:0] RAM_DATAOUT;

//RAM INSTANCIA
RAM RAM_INST(
.CLK(CLK),
.RSTa(RST),
.WR(), 
.CS(), 
.OE(), 
.DATA_IN(RAM_DATAIN), 
.ADDRESS(RAM_ADDRESS), 
.DATA_OUT(RAM_DATAOUT)
);

//ROM INSTANCIA
ROM ROM_INST(
.READ_EN(),
.CE(),
.INS_ADDRESS(ROM_ADDRESS),
.INSTRUCTION_OUT(ROM_INTRUCTION)
);

//CORE INSTANCIA
CORE CORE_INST(
.CLK(CLK),
.RST_n(RST),
.DATA_IMEM(ROM_INTRUCTION),
.DATA_READ_DMEM(RAM_DATAOUT),
.DIR_IMEM(ROM_ADDRESS),
.DIR_DMEM(RAM_ADDRESS),
.DATA_WRITE_DMEM(RAM_DATAIN),
.READ(),
.WRITE()
);

endmodule 