A Game Inspired By “FunBrain”


Abstract

The purpose of this project was to design a game on an FPGA board to be displayed on a screen using a VGA monitor. 
This game that we developed is inspired by the “FunBrain” game, in which a bird catches apples falling from the top 
of the screen, and deposits them in a tray that is located at the lower vertical end of the screen. Our design of this
game consisted of less graphical orientation and focused on the conceptual side of Verilog and its functionalities, in 
which we applied our knowledge based on the experience we gained from the lab assignments of the course EE-354.


Introduction and Background

Due to the Verilog experience that we gained from the extensive lab assignments; we were to sufficiently apply in our code
what we had hoped to achieve in our project demo. This work wouldn’t have been completed if it weren’t for the references that
we received throughout the semester from homework assignments to lab assignments, to the VGA demo files that were introduced by 
the lab Teaching Assistants, right before we started implementing our ideas for the project.


The Design

The outcome of the design, which we built in this project, was to generate in a random fashion a series of green squares (i.e., apples in FunBrain)
that fall from the top of the screen and keep falling until the player playing the gaming catches that square using a paddle (i.e., the bird in Funbrain). 
Else, if the player was not able to catch an apple, then one life is deducted from the player out of a total of 5 lives, which is initially the total number 
of lives each player gets at the beginning of each level of the game.
Now, to display such a game on the screen using a VGA monitor, we used a series of registers to display background colors and wires to display counters.
Regarding the state machine (SM), there are five states involved in our design of the game. The first state is INI, which is the initial state, and in this
state, the variables pts, bag, and goal are initialized to zero. Pts counts the number of points achieved by the player at each level individually. 
For example, pts in level 1 is incremented by 1 when the player catches an apple, but since level 2’s game speed increases, the player will receive two
points for each apple that is caught. The same applies for level 3’s speed, but now, one apple is worth 5 points. However, bag sums all the apples caught 
across all levels of the game. Using bag variable, we were able to make state transitions smoother, since we put a threshold on the number of apples a
player needs to catch to progress to the next level. The second state is LVL1, in which the speed of the apples falling from the top of the screen is normal.
However, in LVL2, the third state in SM, the speed of the apples falling from the top of the screen increases slightly, but the paddle’s speed remains 
unchanged, which makes the game now less easy. In LVL3, apples’ speed increases dramatically, preventing the player from catching the apples at the same
rate as in LVL1 or LVL2. However, if at any level of the 3 levels of the game, LVL1, LVL2, and LVL3, the player misses more than 4 apples, then the player
will go to the END state, and a dark screen is displayed showing only the paddle and a green apple, indicating that the player has lost the game. 
