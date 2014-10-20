ECE382_Lab4
===========
## Objectives
* Use C to create an etch-a-sketch-type program that utilizes some subroutines from Lab 3
* Write clean, maintainable, modular code

## Functionality Details
#### Required Functionality
* modify the assembly drawBlock function to take in 3 values: x coord, y coord, and color
* create an etch-a-sketch program using the LCD booster pack directional buttons
* paint brush will draw an 8x8 block of pixels
* each button press will move the block 8 pixels in the input direction
* auxiliary button (SW3) will toggle the paint brush mode between drawing or clearing squares
* must be written in C and call many of the subroutines from Lab 3 (drawBlock and changePosition)

#### B Functionality
* create a bouncing block
* block moves across screen with no more than 8 pixels per jump
* similar to assignment 6
* add an adequate delay movement between each block movement
* starting position and velocites should be initicialized in the header or randonly generated

#### A Functionality
* create Pong on the LCD
* create a single paddle that moves up and down on one side of the LCD
* control the paddle via up and down buttons
* the block will bounce off the paddle like it bounces off the wall
* game ends when the paddle misses the block

#### Bonus Functionality (5 pts each)
* must be written in assembly and called by C
* *CIRCLE*: instead of a bouncing block, create a bouncing circular ball
* *FINE MOVEMENT*: instead of having the ball/paddle move in 8-pixel jumps, have it move in 1-pixel jumps
* *INVERTED DISPLAY*: with a push of the SW3 button, invert the display; dark -> light, light -> dark

*NOTE*: maximum lab grade cannot exceed 105 pts :(

## Prelab
### Data Types
###### Table 1
| Size | Signed/Unsigned | Type | Min Value | Max Value |
|:-: | :-: | :-: | :-: | :-: |
| 8-bit | unsigned |  |  |  |
| 8-bit | signed |  |  |  |
| 16-bit | unsigned | unsigned short |  |  | 
| 16-bit | signed |  |  |  |
| 32-bit | unsigned |  |  |  |   
| 32-bit | signed |  | -2, 147, 483, 648 |  |  
| 64-bit | unsigned |  |  |  |
| 64-bit | signed |  |  |  |

###### Table 2
| Type | Meaning | C typedef Declaration |
|:-:|:-:|:-:|
| int8 | unsigned 8-bit value |  |
| sint8 | signed 8-bit value |  |
| int16 | unsigned 16-bit value | typedef unsigned short int16; |
| sint16 | signed 16-bit value |  |
| int32 | unsigned 32-bit value |  |
| sint32 | signed 32-bit value |  |
| int64 | unsigned 64-bit value |  |
| sint64 | signed 64-bit value |  |

###### Table 3: Calling/Return Convention
| Iteration | a | b | c | d | e |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 1st |  |  |  |  |  |
| 2nd |  |  |  |  |  |
| 3rd |  |  |  |  |  |
| 4th |  |  |  |  |  |
| 5th |  |  |  |  |  |

###### Table 4
| Parameter | Value Sought |
|||
| Starting address of ```func``` |  |
| Ending address of `func` |  |
| Register holding w |  |
| Register holding x |  |
| Register holding y |  |
| Register holding z |  |
| Register holding return value |  |


## Lab

## Documentation
### Prelab
None
### Lab
None
