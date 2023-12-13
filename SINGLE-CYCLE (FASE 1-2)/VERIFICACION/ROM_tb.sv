`timescale 1 ns/ 1 ps
module ROM_tb();
logic READ_EN;
logic [9:0]ADDRESS_INSTR; 
logic [31:0]INSTR;
reg [31:0]  MROM [1023:0];

ROM ROM_ins(	
		.INS_ADDRESS(ADDRESS_INSTR), 
		.INSTRUCTION_OUT(INSTR),
		.READ_EN(READ_EN)
);



initial
begin
READ_EN=1'b1;                                               
$readmemh("W:\\A ISDIGT FINAL\\PRUEB-POLILABS\\codigo_fibonacci.txt",MROM);
ADDRESS_INSTR=10'b0;
$stop();
end
endmodule