`timescale 1ns/100ps

class INSTRUCCIONES;
    randc logic [31:0] INSTRUCCION;
    randc logic [2:0] ALUOP;

    constraint tipoR {INSTRUCCION[6:0] == 7'b0110011;}
    constraint rs1 {INSTRUCCION[19:15] == 5'd10;}
    constraint rs2 {INSTRUCCION[24:20] == 5'd11;}
    constraint rd {INSTRUCCION[11:7] == 5'd12;}

    //constraint tipoI {INSTRUCCION[6:0] == 7'b0010011;}
    //constraint tipoS {INSTRUCCION[6:0] == 7'b0100011;}
    //constraint tipoB {INSTRUCCION[6:0] == 7'b1100011;}
endclass

module SINGLECYCLE_tb_AVANZADO();
    localparam T = 20;
    logic CLK, RESET_N;
    logic [31:0] RAM_DATAOUT;
    logic [31:0] RAM_DATAIN;
    logic [31:0] RAM_ADDRESS;
    wire READ, WRITE;

    CORE CORE_INST(
        .CLK(CLK),
        .RESET_N(RESET_N),
        .DATA_IMEM(INSTRUCCION),
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

    covergroup Rcover with function sample(INSTRUCCIONES inst);
        option.per_instance = 1;
        cp_fun7: coverpoint inst.INSTRUCCION[30] {
            bins binsFUN7[2] = {[0:1]};
        }
        cp_fun3_R: coverpoint inst.INSTRUCCION[14:12] {
            bins binsFUN3[8] = {[0:7]};
        }
    endgroup;

    covergroup Icover with function sample(INSTRUCCIONES inst);
        option.per_instance = 1;
        cp_fun3_I: coverpoint inst.INSTRUCCION[14:12] {
            bins binsFUN3[8] = {[0:7]};
        }
    endgroup;

    covergroup Scover with function sample(INSTRUCCIONES inst);
        option.per_instance = 1;
        cp_fun3_S: coverpoint inst.INSTRUCCION[14:12] {
            bins binsFUN3[8] = {[0:7]};
        }
    endgroup;

    covergroup Bcover with function sample(INSTRUCCIONES inst);
        option.per_instance = 1;
        cp_fun3_B: coverpoint inst.INSTRUCCION[14:12] {
            bins binsFUN3[8] = {[0:7]};
        }
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

RESET_N = 1'b1;
CLK = 1'b0;
			
RESET();
TIPO_R();
//TIPO_I();
//TIPO_S();
//TIPO_B();

 
$stop;
end 


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

task GENINM (input logic  [31:0] INSTRUCCION, output logic [31:0] INMEDIATO);

	logic [6:0] OPCODE;

	assign OPCODE = INSTRUCCION [6:0];	


	case(OPCODE)
	7'b0010011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[31:20]}};															//I-FORMAT
	7'b0000011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[31:20]}};															//I-FORMAT (INSTRUCCIONES DE CARGA)
	7'b0100011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[31:25]},{INSTRUCCION[11:7]}};										//S-FORMAT
	7'b1100011: INMEDIATO = {{20{INSTRUCCION[31]}},{INSTRUCCION[7]},{INSTRUCCION[30:25]},{INSTRUCCION[11:8]},1'b0};					//B-FORMAT
	7'b0110111: INMEDIATO = {{12{INSTRUCCION[31]}},{INSTRUCCION[31:12]}};															//U-FORMAT(LUI)
	7'b0010111: INMEDIATO = {{12{INSTRUCCION[31]}},{INSTRUCCION[31:12]}};															//U-FORMAT(AUIPC)
	7'b1101111: INMEDIATO = {{13{INSTRUCCION[20]}},{INSTRUCCION[10:1]}, {INSTRUCCION[11]}, {INSTRUCCION[19:12]}};					//J-FORMAT(JAL)
	7'b1100111: INMEDIATO = {{20{INSTRUCCION[11]}},{INSTRUCCION[11:0]}}; 															//J-FORMAT(JALR)
	default: INMEDIATO = INSTRUCCION;
			
	endcase
		


endtask

//VERIFICACION TIPO R

task TIPO_R();
$display ("empiezo la verificacion TIPO R");
begin
instr_rcsg.tipoR.constraint_mode(1);
instr_rcsg.rs1.constraint_mode(1);
instr_rcsg.rs2.constraint_mode(1);
instr_rcsg.rd.constraint_mode(1);

while (rcov_rcsg.cp_fun3_R.get_coverage() < 10) begin
    // Generar instrucción aleatoria
    if (!instr_rcsg.randomize()) begin
        $display("Error al generar instrucción aleatoria, TIPO R");
        break;
    end

    // Verificar la instrucción y SEL ALU
    $display("Instrucción generada: %h", instr_rcsg.INSTRUCCION);

    assert(CORE_INST.ALU_CONTROL_inst.INSTRUCCION == {instr_rcsg.INSTRUCCION[30], instr_rcsg.INSTRUCCION[14:12]})
        $display("INSTRUCCION Y SEL ALU VERIFICADAS CON EXITO, TIPO R");
    else
        $display("INSTRUCCION Y SEL ALU NO COINCIDEN, ERROR TIPO R");
end
end
endtask

endmodule


