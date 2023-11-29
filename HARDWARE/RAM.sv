module RAM (CLK, RSTa, WR, OE, DATA_IN, ADDRESS, DATA_OUT);

//PARAMETROS

parameter TAM_POSICIONES=1024, TAM_PALABRA=32;	
//TAM_POSICIONES = N POSICIONES DE LA MEMORIA ; TAM_PALABRA = TAMANYO DE CADA POSICION DE MEMORIA
//DECLARACION DE VARIABLES

//WR= Write enable/Read enable
//OE = Output Enable

input CLK, RSTa, WR, OE;
input [TAM_PALABRA-1:0] DATA_IN;
input [$clog2(TAM_POSICIONES)-1:0] ADDRESS;
output [TAM_PALABRA-1:0] DATA_OUT;

//MEMORIA RAM


reg [TAM_PALABRA-1:0] MRAM [$clog2(TAM_POSICIONES)-1:0];
reg [TAM_PALABRA-1:0] DATA_OUT_AUX;
//CODIGO:
//

assign DATA_OUT = (OE &&  !WR) ? DATA_OUT_AUX : 8'bz;

// ESCRITURA 
// ESCRIBIR : CUANDO WR = 1
 
 always @(posedge CLK)
 begin : MEM_WRITE
    if (WR) 
	 begin
        MRAM[ADDRESS] = DATA_IN;
    end
 end
 
 // LECTURA
 // LEER  : CUANDO WR = 0, OE = 1
 
 always @(ADDRESS or WR or OE)
  begin : MEM_READ
      if (!WR && OE) 
	begin
          DATA_OUT_AUX = MRAM[ADDRESS];
      	end
		else
			DATA_OUT_AUX = 32'd0;
  end
  
endmodule