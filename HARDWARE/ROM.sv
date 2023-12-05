//ROM ASINCRONA (SOLO LECTURA, SIN RELOJ)

module ROM (READ_EN, INS_ADDRESS, INSTRUCTION_OUT);

//PARAMETROS

parameter TAM_POSICIONES=1024, TAM_PALABRA=32;										//TAM_POSICIONES = N POSICIONES DE LA MEMORIA ; TAM_PALABRA = TAMAÑO DE CADA POSICION DE MEMORIA


//DECLARACION DE VARIABLES

input READ_EN; 										//READ_EN = ENABLE PARA LECTURA

input  [$clog2(TAM_POSICIONES)-1:0] INS_ADDRESS;
output [TAM_PALABRA-1:0] INSTRUCTION_OUT;

//MEMORIA ROM

reg [$clog2(TAM_POSICIONES)-1:0] MROM [TAM_PALABRA-1:0];

//ASIGNACION DE INSTRUCCION

assign INSTRUCTION = (READ_EN) ? MROM[INS_ADDRESS] : 8'b0;

//INICIALIZACION MEMORIA

initial 
begin
 $readmemb("ROM.LIST", MROM); 				//"ROM.LIST" ES NUESTRO ARCHIVO DE MEMORIA ROM
end
hola
endmodule 