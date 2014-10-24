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

### Functionality Update
| Item | Status | Date |
|-------|-------|-------|
| Required Functionality | Complete | 20 October 14 |
| B Functionality | Complete | 21 October 14 |
| A Functionality | Complete | 22 October 14 |
| Bonus Functionality | Complete | 21/22 October 14 |

*All of the functionality of Lab 4 was checked and signed off by Dr. Coulston during class on 22 October 2014*

*BONUS*: I received full points for *circle* and *inverted* bonus functionalities. I received half points for the *fine movement* aspect of the bonus functionality.

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

I was provided with these files for Lab 4:
* lab4.c
* nokia.asm
* simpleLab.c

*simpleLab.c* was used for the prelab and can be disregarded for the remainder of the lab.

### Required Functionality
For the required functionality, I used nokia.asm and lab4.c (I renamed these files slightly). To run the required functionality please include these files in the build:
* 08lab4_R.c
* 08_nokia_R.asm

The required funcitonality required me to create an etch-a-sketch-esque program that drew an 8x8 pixel block on the LCD screen. With the push of the AUX button, the block would be clear, and thus act like an eraser.

I made very minimal changes to the programs provided for me to achieve the required funcitonality.

In *drawBlock* (from the assembly code), I noticed that the program would move the value of 0xFF into R13, which would allow the block to have all 8 bits *filled* instead of *cleared*. And so, I created a simple if-else structure which would check for a flag (set by the AUX button). The flag was initially set to a value of 1 (to symbolize FILL). When the AUX button is pressed, the flag would equal 0 (symbolizing CLEAR). Depending on the flag, the value moved into R13 would be either 0xFF (flag = 1) or 0x00 (flag = 0).

Here is the modified *drawBlock* subroutine:
```
drawBlock:
	push	R5
	push	R12
	push	R13
	push	R14

	rla.w	R13					; the column address needs multiplied
	rla.w	R13					; by 8in order to convert it into a
	rla.w	R13					; pixel address.
	call	#setAddress			; move cursor to upper left corner of block

	mov		#1, R12

	tst		R14
	jz		invert
	; if @R14 = 1, keep it the same
	mov		#0xFF, R13
	jmp		continue
invert:
	; else if @R14 = 0, invert
	mov		#0x00, R13
continue:
	mov.w	#0x08, R5			; loop all 8 pixel columns
loopdB:
	call	#writeNokiaByte		; draw the pixels
	dec.w	R5
	jnz		loopdB
	
	pop		R14
	pop		R13
	pop		R12
	pop		R5

	ret							; return whence you came
```

As we see from *drawBlock*, there is an if-else statement that fills or clears pixels depending on the flag.

You may notice that R14 seemed to come out of nowhere. From the main.c file, we may see that I added another parameter in the *drawBlock* method. Instead of `drawBlock(y, x)`, it is now `drawBlock(y, x, c)`. The *c* parameter is short for *color*. As we see below, `c = 1` means *fill* and `c = 0` means *clear*. The R14 parameter takes in the value of *c* into the subroutine. Since y is R12 and x is R13, the next parameter is automatically stored into R14.

```
 //... added at the end of the button-checking if-else structure
 else if (AUX_BUTTON == 0) {
	while(AUX_BUTTON == 0);
	if(c == 1) c = 0;
	else if(c == 0) c = 1;
	button_press = TRUE;
}
```
After building and debugging my program, I found that the required functionality worked as expected.

### B Functionality
For the rest of the lab (including A and Bonus functionality), please include the following files in the build:
* 09_lab4_AB.c
* 09_nokie_AB.asm
* 09_pong_implementation.c
* pong_lab4.h

For B Functionality, I had to make the box move throughout the LCD screen and bounce off the walls appropriately. Since the provided code was pre-designed to move in each direction by 8 pixels, I did not have to worry about changing any values concerning the movement of the block.

Fortunately, I was able to utilize most of Assignment 6. In Assignment 6, I had created a program that takes in a ball and moves it within the boundaries of the LCD screen. Please reference the header file and the implementation file. 

Using the two files mentioned above, I created an instance of the *ball* inside of *09_lab4_AB.c*:
```
ball_t pong = createBall(START_X_POS, START_Y_POS, START_X_VEL, START_Y_VEL, 4, 1);
```

Also, instead of drawing the block with the parameters passed from the main.c file, I altered the *drawBox* subroutine to take in the ball instance's dynamic x and y positions. Therefore, the ball drawn on the LCD screen will match the constantly updating movements of the ball instantiation.

To account for the boundary collisions, I created several methods in the implementation file. These methods return TRUE or FALSE depending on if the ball moved out of the top, bottom, left, and right boundaries. A method called *moveBall* utilized these methods and changed the ball's x and y velocity components when the ball touches a wall. Inside of the main.c file, I used a while loop and called *moveBall* so that the ball would continue to move around the screen as long as the program was running.

##### Ground/Floor
Currently, the ball seems does not touch the bottom of the screen before bouncing back up. This is because there are 9 rows, but the 9th row is cut-off. Therefore, I wanted to draw the lower boundary and make it seem like the ball was actually bouncing off of the "ground" or "floor".

I used the code from *drawBox* and adjusted it a little bit to draw a 96 pixel wide x 4 pixel high block of filled-in pixels to act as the "ground". I created a new subroutine called *drawGround*. Everything else is pretty self-explanatory. 

After running the code, I confirmed that the ball properly bounces off the screen.

### A Functionality

### Bonus Functionality
I actually completed the bonus functionality before attempting the A functionality.

##### Inverted Display
The first bonus functionality I attempted was the *Inverted Display*. This was relatively easy since I pretty much had a simple version of this functionality from the required part. I adjusted the subroutine, *clearDisplay*, from the assembly file. I used the same if-else structure from the required functionality, and instead of just "clearing" the box color, I also "uncleared" (filled) the background pixels. I also inverted the ground color as well. 

Just like from the required functionality, these inversions were flagged using R14. With the press of the AUX button, the flag was set on and off.

##### Circle
Changing the shape of the box was relatively simple as well. I saw that the original code for drawing the box used a for-loop that counted down from 8 to 0. This was used to draw 8 columns of the 1x8 pixel section. Instead of drawing the same 0xFF eight times, I stored a pattern into ROM and called that pattern as I drew my *box*.

I stored the following pattern first:
```
pattern:		.byte	0x3C, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0x7E, 0x3C		; solid circle
pattern_inv:		.byte	0xC3, 0x81, 0x00, 0x00, 0x00, 0x00, 0x81, 0xC3		; solid circle (inverse)

```

I stored the normal pattern into R8 and the inverted pattern into R9. In the *drawBlock* subroutine, instead of storing the hard-set value of 0xFF into R13, I made it so that the program would store the current value of the pattern pointer, and then increment the pattern pointer.
```
	; moves the beginning of the pattern addresses to R8 and R9
	mov.w	#pattern, R8
	mov.w	#pattern_inv, R9

	; I only rotated once because I wanted a smoother animation
	;rla.w	R13					; the column address needs to be multiplied
	;rla.w	R13					; by 8 in order to convert it into a
	rla.w	R13					; pixel address.
	call	#setAddress			; move cursor to upper left corner of block

	mov		#1, R12
	; if R14 is 0, de-color (unfill)
	tst		R14
	jnz		fill
unfill:
	mov.b	@R9, R13
	jmp		continue
	; else if R14 is 1, color (fill)
fill:
	mov.b	@R8, R13
continue:
	mov.w	#0x08, R5			; loop all 8 pixel columns
loopdB:
	call	#writeNokiaByte		; draw the pixels
	tst		R14
	jnz		regular
inverse:
	inc		R9
	mov.b	@R9, R13
	jmp		switch
regular:
	inc		R8
	mov.b	@R8, R13
switch:
	dec.w	R5
	jnz		loopdB
```

As expected, the circle was drawn properly. By using the inverted pattern when the inversion flag is set, the program properly drew the inverted circle as well.

I then got creative and decided to try out different patterns as well. To test these out, feel free to comment/uncomment the desired/undesired patterns at the top of the assembly file.

The image below shows a few preliminary designs with the non-inverted patterns:
![alt test](https://github.com/sabinpark/ECE382_Lab4/blob/master/images/ball_designs.png "ball designs")

At the top of the assembly file, there are other designs you can try out.

##### Fine Movement

Fine movement was not as intuitive as the other functionalities. After discussing the different approaches to achieve fine movement, I decided that the best method would be to use some sort of modulus algorithms. However, I wanted 

## Debugging
#### Required Functionality
* none
#### B Functionality
* none
#### A Functionality
* forgot to update the drawBox function's parameters to be the ball instantiation's parameters
* ball was moving back and forth in the middle of the screen
* had to figure out where the ball's drawing point started from
#### Bonus Functionality
###### Inverted Display
###### Circle
###### Fine Movement

## Documentation
### Prelab
None
### Lab
* None.
* commit history is innacurate due to file over-writing.

