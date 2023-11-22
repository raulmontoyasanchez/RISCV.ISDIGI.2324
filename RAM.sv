module RAM (CLK, RSTa, WR, CS, OE, DATA_IN, ADDRESS, DATA_OUT);

//PARAMETROS

parameter TAM_POSICIONES=1024, TAM_PALABRA=32;	
//TAM_POSICIONES = N POSICIONES DE LA MEMORIA ; TAM_PALABRA = TAMANYO DE CADA POSICION DE MEMORIA
//DECLARACION DE VARIABLES

//WR= Write enable/Read enable
//CS = Chip Select
//OE = Output Enable

input CLK, RSTa, WR, CS, OE;
input [TAM_PALABRA-1:0] DATA_IN;
input [$clog2(TAM_POSICIONES)-1:0] ADDRESS;
output [TAM_PALABRA-1:0] DATA_OUT;

//MEMORIA RAM


reg [TAM_PALABRA-1:0] MRAM [$clog2(TAM_POSICIONES)-1:0];
reg [TAM_PALABRA-1:0] DATA_OUT_AUX;
//CODIGO:
//

assign DATA_OUT = (CS && OE &&  !WR) ? DATA_OUT_AUX : 8'bz;

// ESCRITURA 
// ESCRIBIR : CUANDO WR = 1, CS = 1
 
 always @(posedge CLK)
 begin : MEM_WRITE
    if (CS && WR) 
	 begin
        MRAM[ADDRESS] = DATA_IN;
    end
 end
 
 // LECTURA
 // LEER  : CUANDO WR = 0, OE = 1, CS = 1
 
 always @(ADDRESS or CS or WR or OE)
  begin : MEM_READ
      if (CS &&  !WR && OE) 
	begin
          DATA_OUT_AUX = MRAM[ADDRESS];
      	end
  end
  
endmodule
