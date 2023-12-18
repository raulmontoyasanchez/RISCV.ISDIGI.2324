`timescale 1ns/100ps
class INSTRUCCIONES;

	randc logic [31:0] INSTRUCCION;
	randc logic [2:0] ALUOP;

	constraint tipoR {INSTRUCCION[6:0]==7'b0110011} // TIPO R
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
logic [9:0] RAM_ADDRESS;
TOP TOP_inst( 
                .CLK(CLK), 
                .RESET_N(RESET_N),
		        .RAM_DATAOUT(RAM_DATAOUT), 
		        .RAM_DATAIN(RAM_DATAIN),
		        .RAM_ADDRESS(RAM_ADDRESS)
);


covergroup Rcover;
	AluOP: coverpoint ALUOP {bins binsALUOP[1]={3'b000} ;}
	fun7: coverpoint INSTRUCCION[31:25] {bins binsFUN7[2]={7'b0000000, 7'b0100000} ;} // coverpoint INSTRUCCION[30] {bins binsFUN7[2]={0:1} ;}
	fun3: coverpoint INSTRUCCION[14:12] {bins binsFUN3[8]={ [0:7]} ;}
	fuente1: coverpoint INSTRUCCION[19:15] {bins binsFUENTE1[32]={ [0:31]} ;}
	fuente2: coverpoint INSTRUCCION[24:20] {bins binsFUENTE2[32]={ [0:31]} ;}
	destino: coverpoint INSTRUCCION[11:7] {bins binsDESTINO[32]={ [0:31]} ;}
endgroup;

covergroup Icover;
	AluOP: coverpoint ALUOP {bins binsALUOP[1]={3'b001} ;}
	//inmediato: coverpoint INSTRUCCION[31:20] {bins binsINMEDIATO[4096]={[0:4095]} ;} // revisar POS NEG
	fuente1: coverpoint INSTRUCCION[19:15] {bins binsFUENTE1[32]={ [0:31]} ;}
	destino: coverpoint INSTRUCCION[11:7] {bins binsDESTINO[32]={ [0:31]} ;}
endgroup;


covergroup Scover;
	AluOP: coverpoint ALUOP {bins binsALUOP[1]={3'b011} ;}
	//inmediato: coverpoint INSTRUCCION[31:25] {bins binsINMEDIATO[128]={[0:127]} ;} 
	//inmediato2: coverpoint INSTRUCCION[11:7] {bins binsINMEDIATO2[32]={[0:31]} ;} 
	fuente1: coverpoint INSTRUCCION[19:15] {bins binsFUENTE1[32]={ [0:31]} ;}
	fuente2: coverpoint INSTRUCCION[24:20] {bins binsFUENTE2[32]={ [0:31]} ;}
	fun3: coverpoint INSTRUCCION[14:12] {bins binsFUN3[8]={ [0:7]} ;}
endgroup;

covergroup Bcover;
	AluOP: coverpoint ALUOP {bins binsALUOP[1]={3'b000} ;}
	//inmediato: coverpoint INSTRUCCION[31] {bins binsINMEDIATO[2]={[0:1]} ;} 
	//inmediato2: coverpoint INSTRUCCION[30:25] {bins binsINMEDIATO2[64]={[0:63]} ;} 
	//inmediato3: coverpoint INSTRUCCION[11:8] {bins binsINMEDIATO[16]={[0:15]} ;} 
	//inmediato4: coverpoint INSTRUCCION[7] {bins binsINMEDIATO2[2]={[0:1]} ;} 
	fun3: coverpoint INSTRUCCION[14:12] {bins binsFUN3[8]={ [0:7]} ;}
	fuente1: coverpoint INSTRUCCION[19:15] {bins binsFUENTE1[32]={ [0:31]} ;}
	fuente2: coverpoint INSTRUCCION[24:20] {bins binsFUENTE2[32]={ [0:31]} ;}
endgroup;

INSTRUCCIONES instr_rcsg; 
Rcover rcov_rcsg;
Icover icov_rcsg;
Scover scov_rcsg;
Bcover bcov_rcsg;

//EJECUCION DEL TEST

initial 
begin
	instr_rcsg = new; 
	rcov_rcsg = new;
	icov_rcsg = new;
	scov_rcsg = new;
	bcov_rcsg = new;


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
instr_rcsg.tipoI.constraint_mode(0);
instr_rcsg.tipoS.constraint_mode(0);
instr_rcsg.tipoB.constraint_mode(0);

while (rcov_rcsg.fun3.get_coverage()<100)
begin

		assert (instr_rcsg.randomize()) else $fatal("randomization failed");
		GENINM (instr_rcsg.INSTRUCCION);
		rcov_rcsg.sample();
		$display(rcov_rcsg.fun3.get_coverage());
end

task TIPO_I();
begin
$display ("empiezo la verificación TIPO I");
instr_rcsg.tipoR.constraint_mode(0);
instr_rcsg.tipoI.constraint_mode(1);
instr_rcsg.tipoS.constraint_mode(0);
instr_rcsg.tipoB.constraint_mode(0);

while (rcov_rcsg.fun3.get_coverage()<100)
begin

		assert (instr_rcsg.randomize()) else $fatal("randomization failed");
		GENINM (instr_rcsg.INSTRUCCION);
		rcov_rcsg.sample();
		$display(rcov_rcsg.fun3.get_coverage());
end

task TIPO_S();
begin
$display ("empiezo la verificación TIPO S");
instr_rcsg.tipoR.constraint_mode(0);
instr_rcsg.tipoI.constraint_mode(0);
instr_rcsg.tipoS.constraint_mode(1);
instr_rcsg.tipoB.constraint_mode(0);

while (rcov_rcsg.fun3.get_coverage()<100)
begin

		assert (instr_rcsg.randomize()) else $fatal("randomization failed");
		GENINM (instr_rcsg.INSTRUCCION);
		rcov_rcsg.sample();
		$display(rcov_rcsg.fun3.get_coverage());
end

task TIPO_B();
begin
$display ("empiezo la verificación TIPO B");
instr_rcsg.tipoR.constraint_mode(0);
instr_rcsg.tipoI.constraint_mode(0);
instr_rcsg.tipoS.constraint_mode(0);
instr_rcsg.tipoB.constraint_mode(1);

while (rcov_rcsg.fun3.get_coverage()<100)
begin

		assert (instr_rcsg.randomize()) else $fatal("randomization failed");
		GENINM (instr_rcsg.INSTRUCCION);
		rcov_rcsg.sample();
		$display(rcov_rcsg.fun3.get_coverage());
end

end

endmodule



