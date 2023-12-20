`timescale 1ns/100ps
class INSTRUCCIONES;

	randc logic [31:0] INSTRUCCION;
	randc logic [2:0] ALUOP;

	constraint tipoR {INSTRUCCION[6:0]==7'b0110011} // TIPO R
	constraint rs1 {INSTRUCCION[19:15]==5'd10}
	constraint rs2 {INSTRUCCION[24:20]==5'd11}
	constraint rd {INSTRUCCION[11:7]==5'd12}

	constraint tipoI {INSTRUCCION[6:0]==7'b0010011} // TIPO I
	//constraint tipoICarga {INSTRUCCION[6:0]==7'b0000011} // TIPO L (I CON CARGA)
	constraint tipoS {INSTRUCCION[6:0]==7'b0100011} // TIPO S
	constraint tipoB {INSTRUCCION[6:0] ==7'b1100011} // TIPO B
endclass

module SINGLECYCLE_tb_AVANZADO();

localparam T = 20;
logic CLK,RESET_N;
logic [31:0] RAM_DATAOUT;
logic [31:0] RAM_DATAIN;
logic [31:0] RAM_ADDRESS;
wire READ, WRITE;

CORE CORE_INST(
.CLK(CLK),
.RESET_N(RESET_N),
.DATA_IMEM(INSTRUCCION), //CONECTAMOS LA ENTRADA DE LA ROM A LA QUE HEMOS GENERADO
.DATA_READ_DMEM(RAM_DATAOUT),
.DIR_IMEM(ROM_ADDRESS),
.DIR_DMEM(RAM_ADDRESS),
.DATA_WRITE_DMEM(RAM_DATAIN),
.READ(READ),
.WRITE(WRITE)
);


RAM RAM_INST(
		.CLK(CLK),
		.RESET_N(RESET_N),
		.WRITE(WRITE), 
		.READ(READ),
		.DATA_IN(RAM_DATAIN),
		.DATA_OUT(RAM_DATAOUT),
		.ADDRESS(RAM_ADDRESS[11:2])

);

covergroup Rcover;
	fun7: coverpoint INSTRUCCION[30] {bins binsFUN7[2]={0:1} ;} 
	fun3: coverpoint INSTRUCCION[14:12] {bins binsFUN3[8]={ [0:7]} ;}
endgroup;

INSTRUCCIONES instr_rcsg; 
Rcover rcov_rcsg;


//EJECUCION DEL TEST

initial 
begin
	instr_rcsg = new; 
	rcov_rcsg = new;


RSTa = 1'b1;
CLK = 1'b0;
			
RESET();
TIPO_R();
TIPO_I();
TIPO_S();
TIPO_B();


initial 
begin
CLK=0;
RESET();
 
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.RAM_INST.MRAM);
//$readmemh("W:\\ISDIGITAREAFINAL\\codigo_fibonacci.txt",TOP_inst.ROM_INST.MROM);  
 
$stop;
end 
endmodule


// TASK BASICAS Y GENERACION RELOJ


task RESET ();
begin
RESET_N= 1'b0;
repeat(2) @(negedge CLK)
RESET_N = 1'b1;
end
endtask


always 
begin
   #(T/2) CLK <= ~CLK;
end


//TASK TIPO INSTRUCCIONES

task TIPO_R();
begin
$display ("empiezo la verificación TIPO R");
instr_rcsg.tipoR.constraint_mode(1);
instr_rcsg.rs1.constraint_mode(1);
instr_rcsg.rs2.constraint_mode(1);
instr_rcsg.rd.constraint_mode(1);


while (rcov_rcsg.fun3.get_coverage()<100 && rcov_rcsg.fun7.get_coverage()<100)
begin

		assert (instr_rcsg.randomize()) else $fatal("randomization failed");
		rcov_rcsg.sample();
		$display(rcov_rcsg.fun3.get_coverage());
		assert()

end

task GENINM (input logic  [31:0] INSTRUCCION, output logic [31:0] INMEDIATO)

	logic [6:0] OPCODE;

	assign OPCODE = INSTRUCCION [6:0];	

	always_comb		
			case(OPCODE)
			7'b0010011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[31:20]}};															//I-FORMAT
			7'b0000011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[31:20]}};															//I-FORMAT (INSTRUCCIONES DE CARGA)
			7'b0100011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[31:25]},{INSTRUCCION[11:7]}};										//S-FORMAT
			7'b1100011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[7]},{INSTRUCCION[30:25]},{INSTRUCCION[11:8]},1'b0};					//B-FORMAT
			7'b0110111: INMEDIATO = {{12{INSTRUCCION[31]}},{INSTRUCCION[31:12]}};															//U-FORMAT(LUI)
			7'b0010111: INMEDIATO = {{12{INSTRUCCION[31]}},{INSTRUCCION[31:12]}};															//U-FORMAT(AUIPC)
			7'b1101111:	INMEDIATO = {{13{INSTRUCCION[20]}},{INSTRUCCION[10:1]}, {INSTRUCCION[11]}, {INSTRUCCION[19:12]}};					//J-FORMAT(JAL)
			7'b1100111:	INMEDIATO = {{20{INSTRUCCION[11]}},{INSTRUCCION[11:0]}}; 															//J-FORMAT(JALR)
			default: INMEDIATO = INSTRUCCION;
			
			endcase
		


endtask

endmodule



