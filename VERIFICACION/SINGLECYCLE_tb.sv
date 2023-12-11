`timescale 1 ns/ 1 ps
module SINGLECYCLE_tb();

localparam T = 20;
logic CLK,RST;

TOP TOP_inst( 
                .CLK(CLK), 
                .RST(RST)
);


//Clock generation
always 
    begin 
		#(T/2) CLK = ~CLK;
	end

initial 
begin
CLK=0;
RST=0;
#10
CLK = 1; 
#1000000; 
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.RAM_INST.MRAM);
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.ROM_INST.MROM);  
 
$stop;
end 
endmodule