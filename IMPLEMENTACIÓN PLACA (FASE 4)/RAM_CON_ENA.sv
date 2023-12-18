module RAM (CLK, RESET_N, ENABLE, WRITE, READ, DATA_IN, ADDRESS, DATA_OUT);

//PARAMETROS
	
//TAM_POSICIONES = N POSICIONES DE LA MEMORIA ; TAM_PALABRA = TAMANYO DE CADA POSICION DE MEMORIA
//DECLARACION DE VARIABLES


input CLK, RESET_N, ENABLE, WRITE, READ;
input [31:0] DATA_IN;
input [9:0] ADDRESS;
output [31:0] DATA_OUT;

//MEMORIA RAM


reg  [31:0] MRAM [1023:0];


//CODIGO:

//LECTURA
assign DATA_OUT = (READ == 1'b1 && ENABLE == 1'b1) ? MRAM[ADDRESS]  : 32'b0;

// ESCRITURA 
// ESCRIBIR : CUANDO WR = 1
 
always @(posedge CLK or negedge RESET_N)
 begin
	if (!RESET_N)
		begin
		for (int i = 0; i < 1024; i = i + 1) 
        		MRAM[i] <= 32'd0;
      		end

	else if (ENABLE)	
			 if (WRITE) 
			begin
			MRAM[ADDRESS] <= DATA_IN;
			end
 end
 
endmodule 