module BANCO_REGISTROS (CLK, RSTa, READ_REG1, READ_REG2, WRITE_REG, DATA_IN, WRITE_ENABLE, READ_DATA1, READ_DATA2);	

input CLK, RSTa;
input [4:0] READ_REG1, READ_REG2;
input [31:0] DATA_IN;
input WRITE_ENABLE;
input [4:0] WRITE_REG;


output [31:0] READ_DATA1, READ_DATA2;

reg [31:0] [31:0]BANCO_REG_AUX;


assign READ_DATA1 = (WRITE_REG == 5'd0) ? 0:BANCO_REG_AUX[READ_REG1];
assign READ_DATA2 = (WRITE_REG == 5'd0) ? 0:BANCO_REG_AUX[READ_REG2];

	
always @(posedge CLK or negedge RSTa)
begin
	if (!RSTa)
		begin
		BANCO_REG_AUX <= '0;
		end
	else
		begin
		if (WRITE_ENABLE)
			begin
				BANCO_REG_AUX[WRITE_REG] <= DATA_IN;
			end
		end
end

endmodule
			
		
		