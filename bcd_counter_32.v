module bcd_counter_32(CLK, EN, RESET, DOUT);
	input CLK, EN, RESET;
	output [31:0] DOUT;
	
	reg [3:0] cnt1;
	reg [3:0] cnt2;
	reg [3:0] cnt3;
	reg [3:0] cnt4;
	reg [3:0] cnt5;
	reg [3:0] cnt6;
	reg [3:0] cnt7;
	reg [3:0] cnt8;
	
	assign DOUT = {cnt8, cnt7, cnt6, cnt5, cnt4, cnt3, cnt2, cnt1};
	
	always @(posedge CLK or posedge RESET)
	begin
		if(RESET == 1) begin
			cnt1 = 0; cnt2 = 0; cnt3 = 0; cnt4 = 0; cnt5 = 0; cnt6 = 0; cnt7 = 0; cnt8 = 0;
		end
		else
			if(EN && CLK == 1)
				if(cnt1 < 4'd9) cnt1 = cnt1 + 1'd1;
				else begin
					cnt1 = 0;
					if(cnt2 < 4'd9) cnt2 = cnt2 + 1'd1;
					else begin
						cnt2 = 0;
						if(cnt3 < 4'd9) cnt3 = cnt3 + 1'd1;
						else begin
							cnt3 = 0;
							if(cnt4 < 4'd9) cnt4 = cnt4 + 1'd1;
							else begin
								cnt4 = 0;
								if(cnt5 < 4'd9) cnt5 = cnt5 + 1'd1;
								else begin
									cnt5 = 0;
									if(cnt6 < 4'd9) cnt6 = cnt6 + 1'd1;
									else begin
										cnt6 = 0;
										if(cnt7 < 4'd9) cnt7 = cnt7 + 1'd1;
										else begin
											cnt7 = 0;
											if(cnt8 < 4'd9) cnt8 = cnt8 + 1'd1;
											else begin
												cnt8 = 0;
											end
										end
									end
								end
							end
						end
					end
				end
	end
endmodule
