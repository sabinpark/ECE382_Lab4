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
| 8-bit | unsigned | unsigned char | 0 | 255 |
| 8-bit | signed | signed char | -128 | 127 |
| 16-bit | unsigned | unsigned short | 0 | 65,535 | 
| 16-bit | signed | signed short | -32,768  | 32,767 |
| 32-bit | unsigned | unsigned long  | 0 | 4,294,967,295 |   
| 32-bit | signed | signed long | -2,147,483,648 | 2,147,483,647 |  
| 64-bit | unsigned | unsigned long long | 0 | 18,446,744,073,709,551,615 |
| 64-bit | signed | signed long long | -9,223,372,036,854,775,808 | 9,223,372,036,854,775,807 |

###### Table 2
| Type | Meaning | C typedef Declaration |
|:-:|:-:|:-:|
| int8 | unsigned 8-bit value | `typedef` unsigned char int8 |
| sint8 | signed 8-bit value | `typedef` signed char sint8 |
| int16 | unsigned 16-bit value | `typedef` unsigned short int16; |
| sint16 | signed 16-bit value | `typedef` signed short sint16 |
| int32 | unsigned 32-bit value | `typedef` unsigned long int32  |
| sint32 | signed 32-bit value | `typedef` signed long sint32 |
| int64 | unsigned 64-bit value | `typedef` unsigned long long int64 |
| sint64 | signed 64-bit value | `typedef` signed long long int64 |

###### Table 3: Calling/Return Convention
| Iteration | a | b | c | d | e |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 1st | 10 | 9 | 8 | 7 | 2 |
| 2nd | 16 | 15 | 14  | 13 | 8 |
| 3rd | 22 | 21 | 20 | 19 | 14 |
| 4th | 28 | 27 | 26 | 25 | 20 |
| 5th | 34 | 33 | 32 | 31 | 26 |

###### Table 4
| Parameter | Value Sought |
|:-:|:-:|
| Starting address of `func` | 0xC2CC  |
| Ending address of `func` | 0xC2D8 |
| Register holding w | r12  |
| Register holding x | r13  |
| Register holding y | r14  |
| Register holding z | r15  |
| Register holding return value | r12 |

### Cross Language Build Constructs
* *What is the role of the `extern` directive in a .c file?*
  * The `extern` directive is used to call variables outside of its function block. These variables are *declared* instead of being *defined*, and thus must be called somewhere other than from within the function. Furthermore, when these variables change, they retain their value. Basically, it allows the .c file to call functions from the .asm files.
* *What is the role of the `.global` directive in an .asm file (used in lines 28-32)?*
  * the `.global` directive is used to make memory labels globally accessible, which means that the memory values can be accessed/referenced from different parts of the build path.

## Lab

### Functionality Update
| Item | Status | Date |
|-------|-------|-------|
| Required Functionality | Complete | 20 October 14 |
| B Functionality | Complete | 21 October 14 |
| A Functionality | Complete | 22 October 14 |
| Bonus Functionality | Complete | 21/22 October 14 |

*The functionality part of Lab 4 was checked and signed off by Dr. Coulston during class on 22 October 2014*

*BONUS*: I received full points for *circle* and *inverted* bonus functionalities. I received half points for the *fine movement* aspect of the bonus functionality.


## Documentation
### Prelab
None
### Lab
None
