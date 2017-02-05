module hvsync_ex(
	// inputs:
	input wire char_clock,

	input wire [3:0]red_in,
	input wire [3:0]green_in,
	input wire [3:0]blue_in,
		 
	// outputs:
	output reg [11:0]char_count_, //post reg
	output reg [11:0]line_count_, //post reg
		
	output wire [3:0]red,
	output wire [3:0]green,
	output wire [3:0]blue,
		
	output reg hsync,
	output reg vsync,
	output reg blank
	);
 
//VGA Standart
`define h_visible_area  1024
`define h_front_porch   24
`define h_sync_pulse    136
`define h_back_porch    160
 
`define v_visible_area  768
`define v_front_porch   3
`define v_sync_pulse    6
`define v_back_porch    29
 
//variables
reg [11:0]char_count;
reg [1:0]pixel_state;
reg [11:0]line_count;
reg [1:0]line_state;
 
reg end_of_line;
reg end_of_frame;
 
//permanent comb computations:
always @*
begin
    //horizontal processing
    if(char_count < `h_visible_area)
        pixel_state = 0; //active video
    else
    if(char_count < `h_visible_area + `h_front_porch)
        pixel_state = 1; //front porch
    else
    if(char_count < `h_visible_area + `h_front_porch + `h_sync_pulse)
        pixel_state = 2; //hsync impuls
    else
        pixel_state = 3; //back porch
 
    if(char_count < `h_visible_area + `h_front_porch + `h_sync_pulse + `h_back_porch)
        end_of_line = 0;
    else
        end_of_line = 1;
 
    //vert processing
    if(line_count < `v_visible_area)
        line_state = 0; //active video lines
    else
    if(line_count < `v_visible_area + `v_front_porch)
        line_state = 1; //front porch
    else
    if(line_count < `v_visible_area + `v_front_porch + `v_sync_pulse)
        line_state = 2; //vsync impuls
    else
        line_state = 3; //front porch
 
    if(line_count < `v_visible_area + `v_front_porch + `v_sync_pulse + `v_back_porch)
        end_of_frame = 0;
    else
        end_of_frame = 1;            
end
 
//synchronous process
always @(posedge char_clock)
begin
    hsync <= (pixel_state!=2'b10);
    vsync <= (line_state!=2'b10);
    blank <= (pixel_state==2'b0 && line_state==2'b0);
 
    //char_count_ <= char_count;
    line_count_ <= line_count;
 
    if(end_of_line)
    begin
        char_count <= 0;
        char_count_ <= 0;
 
        if(end_of_frame)
            line_count <= 0;
        else
            line_count <= line_count + 1'b1;
    end
    else
    begin
        char_count <= char_count + 1'b1;
        if (pixel_state==2'b0)
			char_count_ <= char_count_ + 1'b1;
    end
end

assign red = red_in;
assign green = green_in;
assign blue = blue_in;
 
endmodule