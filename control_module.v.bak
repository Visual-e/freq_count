module control_module(CLK, ENABLE, RESET, STROBE);
	input CLK;
	output ENABLE, RESET, STROBE;
	reg ENABLE, RESET, STROBE;
	
	reg [25:0] cnt;
	
	always @(posedge CLK)
	begin
		if(cnt == 26'd50000005) cnt = 26'd0;
		else cnt = cnt + 26'd1;
	end
	
	always @(posedge CLK)
	begin
		case(cnt)
			26'd0: RESET = 1'd1;
			26'd1: RESET = 1'd0;
			26'd2: ENABLE = 1'd1;
			26'd50000002: ENABLE = 1'd0;
			26'd50000003: STROBE = 1'd1;
			26'd50000004: STROBE = 1'd0;
		endcase
	end
endmodule