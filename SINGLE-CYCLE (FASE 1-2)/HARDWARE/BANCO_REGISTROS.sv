module BANCO_REGISTROS (CLK, RESET_N, READ_REG1, READ_REG2, WRITE_REG, DATA_IN, WRITE_ENABLE, READ_DATA1, READ_DATA2);	

input CLK, RESET_N;
input [4:0] READ_REG1, READ_REG2;
input [31:0] DATA_IN;
input WRITE_ENABLE;
input [4:0] WRITE_REG;


output [31:0] READ_DATA1, READ_DATA2;

reg [31:0] BANCO_REG_AUX [31:0];


assign READ_DATA1 = (READ_REG1 == 5'd0) ? 0:BANCO_REG_AUX[READ_REG1];
assign READ_DATA2 = (READ_REG2 == 5'd0) ? 0:BANCO_REG_AUX[READ_REG2];

	
always @(posedge CLK or negedge RESET_N)
begin
	if (!RESET_N)
		begin
		for (int i = 0; i < 32; i = i + 1) 
        		BANCO_REG_AUX[i] <= 32'd0;
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
			
		
		