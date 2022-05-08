`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input Start,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
   );
	wire block_fill;
	wire apples;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	reg [15:0] xrand, yrand;
	reg [2:0] state;
	reg [3:0] bag;
	reg [2:0] lives;
	reg [7:0] pts;
	reg [3:0] rand_counter;

	//live register color
	reg [11:0] side1;
	reg [11:0] side2;
	reg [11:0] side3;
	reg [11:0] side4;
	reg [11:0] side5;
	
	// Score registers for coloring
	reg [11:0] goal1;
	reg [11:0] goal2;
	reg [11:0] goal3;
	reg [11:0] goal4;
	reg [11:0] goal5;
	reg [11:0] goal6;
	reg [11:0] goal7;
	reg [11:0] goal8;
	reg [11:0] goal9;

	// Create an array of random numbers for the apples
	
	reg [9:0] xlocations [0:15];
	reg [9:0] ylocations [0:15];

	// Demonstrates the lives of player on screen
	wire block_fill_side1;
	wire block_fill_side2;
	wire block_fill_side3;
	wire block_fill_side4;
	wire block_fill_side5;

	// Wiring score assignments
	wire goal_1;
	wire goal_2;
	wire goal_3;
	wire goal_4;
	wire goal_5;
	wire goal_6;
	wire goal_7;
	wire goal_8;
	wire goal_9;

	//Color declarations
	parameter RED   = 12'b1111_0000_0000;
	parameter GREY = 12'b1100_1100_1100;
	//parameter potCLR;

	//State machine states
	localparam
	INI  = 3'b000,
	LVL1 = 3'b001,
	LVL2 = 3'b010,
	LVL3 = 3'b100,
	END  = 3'b101,
	UNK  = 3'bxxx;
	

	//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign block_fill=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	// Pot to deposit the apples
	assign apples = vCount>=(yrand-10) && vCount<=(yrand+10) && hCount>=(xrand-10) && hCount<=(xrand+10);

	// Live declarations
	assign block_fill_side1 =(hCount > 720) && (hCount < 730) && (vCount >= 50) && (vCount <= 100);
	assign block_fill_side2 =(hCount > 731) && (hCount < 740) && (vCount >= 50) && (vCount <= 100);
	assign block_fill_side3 =(hCount > 741) && (hCount < 750) && (vCount >= 50) && (vCount <= 100);
	assign block_fill_side4 =(hCount > 751) && (hCount < 760) && (vCount >= 50) && (vCount <= 100);
	assign block_fill_side5 =(hCount > 761) && (hCount < 770) && (vCount >= 50) && (vCount <= 100);

	// Score Display Positions
	assign goal_1 =(hCount > 154) && (hCount < 180) && (vCount >= 50) && (vCount <= 60);
	assign goal_2 =(hCount > 154) && (hCount < 180) && (vCount >= 62) && (vCount <= 72);
	assign goal_3 =(hCount > 154) && (hCount < 180) && (vCount >= 74) && (vCount <= 84);
	assign goal_4 =(hCount > 154) && (hCount < 180) && (vCount >= 86) && (vCount <= 96);
	assign goal_5 =(hCount > 154) && (hCount < 180) && (vCount >= 98) && (vCount <= 108);
	assign goal_6 =(hCount > 154) && (hCount < 180) && (vCount >= 110) && (vCount <= 120);
	assign goal_7 =(hCount > 154) && (hCount < 180) && (vCount >= 122) && (vCount <= 132);
	assign goal_8 =(hCount > 154) && (hCount < 180) && (vCount >= 134) && (vCount <= 144);
	assign goal_9 =(hCount > 154) && (hCount < 180) && (vCount >= 146) && (vCount <= 156);

	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright )	//force black if not inside the display area
			rgb = 12'b0000_0000_0000;
		else if (block_fill) 
			rgb = RED; 
		else if (apples)
			rgb = 12'b0000_1111_0000;
		else if(block_fill_side1)
            	rgb = side1;
        else if(block_fill_side2)
            	rgb = side2;
        else if(block_fill_side3)
            	rgb = side3;
        else if(block_fill_side4)
            	rgb = side4;
        else if(block_fill_side5)
            	rgb = side5;
		else if(goal_1)
				rgb = goal1;
		else if(goal_2)
				rgb = goal2;
		else if(goal_3)
				rgb = goal3;
		else if(goal_4)
				rgb = goal4;
		else if(goal_5)
				rgb = goal5;
		else if(goal_6)
				rgb = goal6;
		else if(goal_7)
				rgb = goal7;
		else if(goal_8)
				rgb = goal8;
		else if(goal_9)
				rgb = goal9;
		else	
			rgb=background;
	end
	
	// Making the state and state transitions
	always @ (posedge clk, posedge rst)begin
		if(rst)
			begin
				//resetting the background color
				background <= 12'b1111_1111_1111;

				// initializing the lives color
				side1 <= GREY;
				side2 <= GREY;
				side3 <= GREY;
				side4 <= GREY;
				side5 <= GREY;

				// Initializing score variables
				goal1 <= background;
				goal2 <= background;
				goal3 <= background;
				goal4 <= background;
				goal5 <= background;
				goal6 <= background;
				goal7 <= background;
				goal8 <= background;
				goal9 <= background;

				//rough values for center of screen
				xpos<=450;
				ypos<=250;
				
				xlocations[0] = 300;
	            ylocations[0] = 255;

	            xlocations[1] = 450;
	            ylocations[1] = 50;
	            
	            xlocations[2] = 770;
                ylocations[2] = 100;
            
                xlocations[3] = 470;
                ylocations[3] = 190;
            
                xlocations[4] = 150;
                ylocations[4] = 200;
            
                xlocations[5] = 665;
                ylocations[5] = 215;
            
                xlocations[6] = 540;
                ylocations[6] = 90;
            
                xlocations[7] = 590;
                ylocations[7] = 222;
            
                xlocations[8] = 400;
                ylocations[8] = 255;
            
                xlocations[9] = 200;
                ylocations[9] = 200;
            
                xlocations[10] = 250;
                ylocations[10] = 70;
                
                xlocations[11] = 665;
                ylocations[11] = 300;
            
                xlocations[12] = 200;
                ylocations[12] = 90;
            
                xlocations[13] = 750;
                ylocations[13] = 222;
            
                xlocations[14] = 400;
                ylocations[14] = 40;
            
                xlocations[15] = 450;
                ylocations[15] = 200;

				//resetting the variables
				bag <= 0;
				pts <= 8'bxxxxxxxx;
				lives <= 3'b101;
				state <= INI;
			end
		else if(clk)
			begin
				case (state)
					INI:
						begin
							//state transitions
							if(left && right)
								state <= LVL1;
							//RTL

							//random value for first apple
							xrand <= 400;
							yrand <= 200;

							// Initializing the colors
							background <= 12'b1111_1111_1111;
							side1 <= GREY;
							side2 <= GREY;
							side3 <= GREY;
							side4 <= GREY;
							side5 <= GREY;

							// Initializing score variables
							goal1 <= background;
							goal2 <= background;
							goal3 <= background;
							goal4 <= background;
							goal5 <= background;
							goal6 <= background;
							goal7 <= background;
							goal8 <= background;
							goal9 <= background;

							// Initializing lives, points, number of items caught and randomizer count
							rand_counter = 0;
							pts <= 0;
							lives <= 5;
							bag <= 0;
						end
					LVL1:
						begin
							//State transitions
							if(bag > 6 && lives != 0)
								begin
									state <= LVL2;
								end
							else if (lives == 0)
									state <= END;

							// RTL
							if(right) 
								begin
									xpos<=xpos+2; //change the amount you increment to make the speed faster 
									if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
										xpos<=150;
								end
							else if(left) 
								begin
									xpos<=xpos-2;
									if(xpos==150)
										xpos<=800;
								end
							else if(up) 
								begin
									ypos<=ypos-2;
									if(ypos==34)
										ypos<=514;
								end
							else if(down) 
								begin
									ypos<=ypos+2;
									if(ypos==514)
										ypos<=34;
								end
							
							//making the apples move down
							yrand <= yrand + 1;
							
							//randomize apple spawn location
							if (xpos >=xrand-10 && xpos <= xrand+10 && ypos >=yrand-10 && ypos <= yrand+10)
								begin
									bag <= bag + 1;
									pts <= pts + 1;
									xrand <= xlocations[rand_counter];
									yrand <= ylocations[rand_counter];
									if (rand_counter >= 15)
									   rand_counter <= 0;
								    else 
								        rand_counter <= rand_counter + 1;
									   
								end
							if (yrand > 520)
							     begin
							         lives <= lives - 1;
							         xrand <= xlocations[rand_counter];
							         yrand <= ylocations[rand_counter];
							         if (rand_counter >= 15)
									       rand_counter <= 0;
						              else 
								            rand_counter <= rand_counter + 1;
							     end
							if(pts == 0)
								begin
									goal1 <= background;
									goal2 <= background;
									goal3 <= background;
									goal4 <= background;
									goal5 <= background;
									goal6 <= background;
									goal7 <= background;
									goal8 <= background;
									goal9 <= background;
								end
							else if(pts == 1)
									goal1 <= RED;
							else if(pts == 2)	
									goal2 <= RED;
							else if (pts == 3)	
									goal3 <= RED;
							else if (pts == 4)	
									goal4 <= RED;
							else if (pts == 5)	
									goal5 <= RED;
							else if (pts == 6)	
									goal6 <= RED;

							if (lives == 5)
								begin
									side5 <= GREY;
									side4 <= GREY;
									side3 <= GREY;
									side2 <= GREY;
									side1 <= GREY;
								end
							else if (lives == 4)
								side5 <= background;
							else if (lives == 3)
								side4 <= background;
							else if (lives ==2)
								side3 <= background;
							else if (lives == 1)
								side2 <= background;
							
							if(bag >6) 
								begin
									lives <= 5;
									goal1 <= 12'b1100_1100_0000;
									goal2 <= 12'b1100_1100_0000;
									goal3 <= 12'b1100_1100_0000;
									goal4 <= 12'b1100_1100_0000;
									goal5 <= 12'b1100_1100_0000;
									goal6 <= 12'b1100_1100_0000;
								end
							//making the LVL background a specific color
							background <= 12'b0011_0000_1100;
							
								
						end
					LVL2:
						begin
							if (bag > 14 && lives != 0)
									state <= LVL3;	
							else if(lives == 0)
									state <= END;
								
							// RTL
							if(right) 
								begin
									xpos<=xpos+2; //change the amount you increment to make the speed faster 
									if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
										xpos<=150;
								end
							else if(left) 
								begin
									xpos<=xpos-2;
									if(xpos==150)
										xpos<=800;
								end
							else if(up) 
								begin
									ypos<=ypos-2;
									if(ypos==34)
										ypos<=514;
								end
							else if(down) 
								begin
									ypos<=ypos+2;
									if(ypos==514)
										ypos<=34;
								end
								
							
							
							//block speend
							yrand <= yrand + 2;
							
							//randomize apple spawn location
							if (xpos >=xrand-10 && xpos <= xrand+10 && ypos >=yrand-10 && ypos <= yrand+10)
								begin
									bag <= bag + 1;
									pts <= pts + 2;
									xrand <= xlocations[rand_counter];
									yrand <= ylocations[rand_counter];
									rand_counter <= rand_counter + 1;
								end
							if (yrand > 520)
							     begin
							         lives <= lives - 1;
							         xrand <= xlocations[rand_counter];
							         yrand <= ylocations[rand_counter];
							         rand_counter <= rand_counter + 1;
							     end
								
							//making the LVL background a specific color
							background <= 12'b1100_1100_0000;

							if(pts == 7)
								begin
									goal1 <= background;
									goal2 <= background;
									goal3 <= background;
									goal4 <= background;
									goal5 <= background;
									goal6 <= background;
									goal7 <= background;
									goal8 <= background;
									goal9 <= background;
								end
							else if(pts == 9)
									goal1 <= RED;
							else if(pts == 11)
									goal2 <= RED;
							else if (pts == 13)
									goal3 <= RED;
							else if (pts == 15)	
									goal4 <= RED;
							else if (pts == 17)	
									goal5 <= RED;
							else if (pts == 19)	
									goal6 <= RED;
							else if (pts == 21)	
									goal7 <= RED;
							else if (pts == 23)	
									goal8 <= RED;
							else if (pts == 25)
									goal9 <= RED;
							//changing lives color appropriately 
							if (lives == 5)
								begin
									side5 <= GREY;
									side4 <= GREY;
									side3 <= GREY;
									side2 <= GREY;
									side1 <= GREY;
								end
							else if (lives == 4)
								side5 <= background;
							else if (lives == 3)
								side4 <= background;
							else if (lives ==2)
								side3 <= background;
							else if (lives == 1)
								side2 <= background;

							if(bag > 14) 
								begin
									lives <= 5;
									goal1 <= 12'b0000_0000_1111;
									goal2 <= 12'b0000_0000_1111;
									goal3 <= 12'b0000_0000_1111;
									goal4 <= 12'b0000_0000_1111;
									goal5 <= 12'b0000_0000_1111;
									goal6 <= 12'b0000_0000_1111;
									goal7 <= 12'b0000_0000_1111;
									goal8 <= 12'b0000_0000_1111;
									goal9 <= 12'b0000_0000_1111;
								end
							
						end
					LVL3:
						begin
							//State transitions
							if (lives == 0)
									state <= END;
							
							//RTL
							if(right) 
								begin
									xpos<=xpos + 2; //change the amount you increment to make the speed faster 
									if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
										xpos<=150;
								end
							else if(left) 
								begin
									xpos<=xpos-2;
									if(xpos==150)
										xpos<=800;
								end
							else if(up) 
								begin
									ypos<=ypos-2;
									if(ypos==34)
										ypos<=514;
								end
							else if(down) 
								begin
									lives <= 0;
									ypos<=ypos+2;
									if(ypos==514)
										ypos<=34;
								end
							
							
							//block speend
							yrand <= yrand + 3;
							
							//randomize apple spawn location
							if (xpos >=xrand-10 && xpos <= xrand+10 && ypos >=yrand-10 && ypos <= yrand+10)
								begin
									bag <= bag + 1;
									pts <= pts + 5;
									xrand <= xlocations[rand_counter];
									yrand <= ylocations[rand_counter];
									rand_counter <= rand_counter + 1;
								end
							if (yrand > 520)
							     begin
							         lives <= lives - 1;
							         xrand <= xlocations[rand_counter];
							         yrand <= ylocations[rand_counter];
							         rand_counter <= rand_counter + 1;
							     end

							background <= 12'b0000_0000_1111;

							if(pts == 23)
								begin
									goal1 <= background;
									goal2 <= background;
									goal3 <= background;
									goal4 <= background;
									goal5 <= background;
									goal6 <= background;
									goal7 <= background;
									goal8 <= background;
									goal9 <= background;
								end
							else if(pts == 28)
									goal1 <= RED;
							else if(pts == 32)
									goal2 <= RED;
							else if (pts == 37)
									goal3 <= RED;
							else if (pts == 42)	
									goal4 <= RED;
							else if (pts == 47)	
									goal5 <= RED;
							else if (pts == 52)	
									goal6 <= RED;
							else if (pts == 57)	
									goal7 <= RED;
							else if (pts == 62)	
									goal8 <= RED;
							else if (pts == 67)
									goal9 <= RED;

							

							//changing lives color appropriately 
							if (lives == 5)
								begin
									side5 <= GREY;
									side4 <= GREY;
									side3 <= GREY;
									side2 <= GREY;
									side1 <= GREY;
								end
							else if (lives == 4)
								side5 <= background;
							else if (lives == 3)
								side4 <= background;
							else if (lives ==2)
								side3 <= background;
							else if (lives == 1)
								side2 <= background;
							

						end
					END: 
						begin
							//State transition
							if(left && right)
								state <= INI;

							side5 <= background;
							side4 <= background;
							side3 <= background;
							side2 <= background;
							side1 <= background;
							
							background <= 12'b0000_0000_0000;

							goal1 <= 12'b0000_0000_0000;
							goal2 <= 12'b0000_0000_0000;
							goal3 <= 12'b0000_0000_0000;
							goal4 <= 12'b0000_0000_0000;
							goal5 <= 12'b0000_0000_0000;
							goal6 <= 12'b0000_0000_0000;
							goal7 <= 12'b0000_0000_0000;
							goal8 <= 12'b0000_0000_0000;
							goal9 <= 12'b0000_0000_0000;
						end
					default:
						begin
							state <= UNK;
						end
				endcase
				
			end
	end
endmodule

