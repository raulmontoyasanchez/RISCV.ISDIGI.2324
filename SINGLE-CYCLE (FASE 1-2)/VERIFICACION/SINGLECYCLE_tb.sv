`timescale 1 ns/ 1 ps
module SINGLECYCLE_tb();

localparam T = 20;
logic CLK,RESET_N;
logic [31:0] RAM_DATAOUT;
logic [31:0] RAM_DATAIN;
logic [9:0] RAM_ADDRESS;
TOP TOP_inst( 
                .CLK(CLK), 
                .RESET_N(RESET_N),
		.RAM_DATAOUT(RAM_DATAOUT), 
		.RAM_DATAIN(RAM_DATAIN),
		.RAM_ADDRESS(RAM_ADDRESS)
);


//Clock generation
always 
    begin 
		#(T/2) CLK = ~CLK;
	end

initial 
begin
CLK=0;
RESET_N=0;
@(negedge CLK);
RESET_N=1;
 
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.RAM_INST.MRAM);
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.ROM_INST.MROM);  
 
$stop;
end 
endmodule