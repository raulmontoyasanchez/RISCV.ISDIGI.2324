`timescale 1ns/100ps



module tb_RAM();

logic CLK;
logic RESET_N;
logic [31:0] DATA_IN;

logic [31:0] DATA_OUT;
logic [9:0] ADDRESS;

logic WRITE;
logic READ;





RAM DUV(
		.CLK(CLK),
		.RESET_N(RESET_N),
		.WRITE(WRITE), 
		.READ(READ),
		.DATA_IN(DATA_IN),
		.DATA_OUT(DATA_OUT),
		.ADDRESS(ADDRESS)

);

initial                                                
begin   
CLK=1'b0;                                               
forever # 10 CLK=!CLK;                    
end 



initial
begin
RESET_N = 1'b0;
CLK = 1'b0;

RESET();

$display("Escribo en la posicion 3");
WRITE_TASK(10'd3,32'd20);

$display("leo de la posicion 3");
READ_TASK(10'd3);

if (DATA_OUT==32'd20)
	$display("Funciona bien");
	
$display("Escribo en la posicion 4");
WRITE_TASK(10'd4,32'd25);

$display("leo de la posicion 4");
READ_TASK(10'd4);

if (DATA_OUT==32'd25)
	$display("Funciona bien");
	
$display("Escribo en la posicion 5");	
WRITE_TASK(10'd5,30);	

$display("leo de la posicion 5");
READ_TASK(10'd5);

if (DATA_OUT==30)
	$display("Funciona bien");	
$stop;	
end


task RESET();
begin
RESET_N= 1'b0; 
repeat(2) @(negedge CLK)
RESET_N = 1'b1;
end
endtask

task WRITE_TASK(input [9:0] ADD, input [31:0] IN);
begin
begin
READ=1'b0;
WRITE=1'b0;
end
@(posedge CLK) 
begin
READ=1'b0;
WRITE=1'b1;
ADDRESS = ADD;
DATA_IN = IN;
end
@(posedge CLK)
begin
READ=1'b0;
WRITE=1'b0;
end
@(posedge CLK);
end
endtask 

task READ_TASK(input [9:0] ADD);
begin
READ=1'b0;
WRITE=1'b0;
@(posedge CLK) 
READ=1'b1;
WRITE=1'b0;
ADDRESS = ADD;
@(posedge CLK);
end
endtask

endmodule 