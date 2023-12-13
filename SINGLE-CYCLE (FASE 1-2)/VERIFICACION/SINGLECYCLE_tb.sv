`timescale 1 ns/ 1 ps
module SINGLECYCLE_tb();

localparam T = 20;
logic CLK,RESET_N;

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
#10
CLK = 1; 
RESET_N=1;
 
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.RAM_INST.MRAM);
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.ROM_INST.MROM);  
 
$stop;
end 
endmodule