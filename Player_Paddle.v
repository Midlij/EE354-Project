module Gamestate (
	input pixel_Clk,
	input VSyncStart,
	input [7:0] buttons,
	input Paddle_Collides_left,
	input Paddle_Collides_right,
	output reg [7:0] state = IDLE,
	output reg [7:0] player_catched = 0,
	output reg [7:0] player_missed = 0,
);

// state machine enumerations

parameter IDLE = 2'b00;
parameter Searching = 2'b01;
parameter NOT_FOUND = 2'b10;
parameter Time_ended = 2'b11;

reg StrB_Pressed = 0;
reg [15:0] count = 0;

always @(posedge pixel_Clk)
begin
	if(VSyncStart)
	begin
		case(state)
			IDLE
				begin
					if(~Buttons[NesController.buttonStart])
						StrB_Pressed <= 1;
					if(StrB_Pressed & Buttons[NesController.buttonStart])
					begin
						player_catched <= 0;
						player_missed <= 0;
						state <= Searching;
					end
				end
			Searching	
				begin
					if(player_missed == 9)
						state <= IDLE;
					else
						begin
							if(count == 0)
								begin	
									player_missed <= player_missed + 1'b1;
									if(player_missed == 9)	
										state <= IDLE;
									count <= count + 1'b1;
								end
						end
				end
			
						











// Bird_Ctrl #(.Player(Bird_Col))
// 	(.i_Clk(i_Clk),
// 	 .i_Col_Count_Div(w_Col_Count_Div),
// 	 .i_Row_Count_Div(w_Row_Count_Div),
// 	 .i_Bird_Up(i_Bird_Up),
// 	 .i_Bird_Down(i_Bird_Down),
// 	 .o_Draw_Bird(w_Draw_Bird),
// 	 o_Bird_Y(w_Bird_Y);
// 	 );