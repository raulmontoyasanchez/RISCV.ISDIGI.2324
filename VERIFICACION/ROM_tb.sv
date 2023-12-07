`timescale 1 ns/ 1 ps
module ROM_tb();
reg CLK;
reg [31:0]address_instr; 
reg [31:0]instr;
ROM ROM_ins(	
		.INS_ADDRESS(address), 
		.INSTRUCTION_OUT(instr)
);
//RELOJ
initial                                                
begin   
CLK=1'b0;                                               
forever # 10 CLK=!CLK;                    
end 

initial
begin
$readmemh("codigo_fibonacci.txt")
end
$stop

endmodule