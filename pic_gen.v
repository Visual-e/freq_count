module pic_gen(
	//vga
	input [11:0]char_count,
	input [11:0]line_count,
	input wire blank,
	input wire char_clock,

	output reg [3:0]red_out,
	output reg [3:0]green_out,
	output reg [3:0]blue_out,

	//built-in memory
	input [23:0]bmp_data,
	output reg[13:0]bmp_adress,

	//counter input
	input [31:0]bcd_cnt,
	input wire strobe
);


reg [31:0]loc_cnt;
reg [11:0]dx;
reg [11:0]dy;

//по стробу защелкиваем счетчик
always @(posedge strobe)
	begin
		loc_cnt = bcd_cnt;
	end

//Вывод изображения
always @(posedge char_clock)
begin
//Ширина изображения одной цифры не превышает 32 пикселей
dx<=char_count & 5'b11111;

//Выбор чифры в знакоместе, в зависимости от значения счетчика
if(char_count<32)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[31:28];
	end
else if(char_count>=32 && char_count<64)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[27:24];
	end
else if(char_count>=64 && char_count<96)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[23:20];
	end
else if(char_count>=96 && char_count<128)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[19:16];
	end
else if(char_count>=128 && char_count<160)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[15:12];
	end
else if(char_count>=160 && char_count<192)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[11:8];
	end
else if(char_count>=192 && char_count<224)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[7:4];
	end
else if(char_count>=224 && char_count<256)
	begin
	bmp_adress <= dx+line_count*320+32*loc_cnt[3:0];
	end

//Формирование изображения
//Изображение за кадром, выводим черный цвет	
if(blank==0)
	begin
	blue_out <= 0;
	green_out <= 0;
	red_out <= 0;
	end
//В окне 0,256,0,32 выводим нашу частоту
else
	begin
	if(char_count<256 && line_count<32)
		begin
		blue_out <= (bmp_data >> 20) & 8'b00001111;
		green_out <= (bmp_data >> 12) & 8'b00001111;
		red_out <= (bmp_data >> 4) & 8'b00001111;
		end
//Остальное закрашиваем белым
	else
		begin
		blue_out <= 4'b1111;
		green_out <= 4'b1111;
		red_out <= 4'b1111;
		end
	end
end

endmodule