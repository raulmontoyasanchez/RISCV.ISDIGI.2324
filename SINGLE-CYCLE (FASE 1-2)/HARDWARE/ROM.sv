//ROM ASINCRONA (SOLO LECTURA, SIN RELOJ)

module ROM (INS_ADDRESS, INSTRUCTION_OUT,READ_EN);

//PARAMETROS

parameter TAM_POSICIONES=1024, TAM_PALABRA=32;										//TAM_POSICIONES = N POSICIONES DE LA MEMORIA ; TAM_PALABRA = TAMAÃO DE CADA POSICION DE MEMORIA


//DECLARACION DE VARIABLES

input  [$clog2(TAM_POSICIONES)-1:0] INS_ADDRESS;
output [TAM_PALABRA-1:0] INSTRUCTION_OUT;
input READ_EN;
//MEMORIA ROM

reg [TAM_PALABRA-1:0] MROM [TAM_POSICIONES-1:0] ;

//ASIGNACION DE INSTRUCCION

assign INSTRUCTION_OUT =(READ_EN)? MROM[INS_ADDRESS] :32'b0;

//INICIALIZACION MEMORIA

initial 
begin
 $readmemh("D:\\Escritorio\\ASIGANTURAS UPV\\TELECO TERCERO\\ISDIG\\FASE2\\RISCV.ISDIGI.2324-1\\SINGLE-CYCLE (FASE 1-2)\\codigo_ordenamiento", MROM); 				//"ROM.LIST" ES NUESTRO ARCHIVO DE MEMORIA ROM
end
endmodule 