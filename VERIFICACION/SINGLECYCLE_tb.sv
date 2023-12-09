`timescale 1 ns/ 1 ps
module SINGLECYCLE();
logic CLK,RST;


TOP TOP_inst( 
                .ROM_INS(ROM_INS),     
                .RAM_DATA(RAM_DATA), 
                .ROM_ADD(ROM_ADD), 
                .RAM_ADD(RAM_ADD) 
                .CLK(CLK), 
                .RST(RST)
);


//Clock generation
always 
    begin 
		#(T/2) CLK = ~CLK;
	end

initial begin
$readmemh("W:\\A ISDIGT FINAL\\PRUEB-POLILABS\\codigo_fibonacci.txt",MRAM);
$readmemh("W:\\A ISDIGT FINAL\\PRUEB-POLILABS\\codigo_fibonacci.txt",MROM);    
end
endmodule