;//-------------------------------------------------------------------------------
;//	Name:		C2C Sabin Park
;//	Term:		Fall 2014
;//	MCU:		MSP430G2553
;//	Date:		21 October 2014
;//	Note:		Lab 4: assembly file
;//-------------------------------------------------------------------------------
;//	NOTE: Run this file with 08_lab4.c NOT with 08_simpleLab4.c
;//-------------------------------------------------------------------------------
	.cdecls C,LIST,"msp430.h"		; BOILERPLATE	Include device header file

LCD1202_SCLK_PIN:				.equ	20h		; P1.5
LCD1202_MOSI_PIN: 				.equ	80h		; P1.7
LCD1202_CS_PIN:					.equ	01h		; P1.0
LCD1202_BACKLIGHT_PIN:			.equ	10h
LCD1202_RESET_PIN:				.equ	01h
NOKIA_CMD:						.equ	00h
NOKIA_DATA:						.equ	01h

STE2007_RESET:					.equ	0xE2
STE2007_DISPLAYALLPOINTSOFF:	.equ	0xA4
STE2007_POWERCONTROL:			.equ	0x28
STE2007_POWERCTRL_ALL_ON:		.equ	0x07
STE2007_DISPLAYNORMAL:			.equ	0xA6
STE2007_DISPLAYON:				.equ	0xAF

PADDLE_WIDTH:					.equ	2		; width of the paddle
PADDLE_HEIGHT:					.equ	3		; height of the paddle
PADDLE_START_X:					.equ	4		; paddle starting x position

; feel free to comment and uncomment the patterns below to check out the different "box" designs

;pattern:						.byte	0x3C, 0x7E, 0xFF, 0xFF, 0xFF, 0xFF, 0x7E, 0x3C		; solid circle
;pattern_inv:					.byte	0xC3, 0x81, 0x00, 0x00, 0x00, 0x00, 0x81, 0xC3		; solid circle (inverse)

pattern:						.byte	0x3C, 0x42, 0xA5, 0x99, 0x99, 0xA5, 0x42, 0x3C		; x-ball
pattern_inv:					.byte	0xC3, 0xBD, 0x5A, 0x66, 0x66, 0x5A, 0xBD, 0xC3		; x-ball (inverse)

;pattern:						.byte	0x1E, 0x21, 0x41, 0x82, 0x81, 0x41, 0x21, 0x1E		; heart
;pattern_inv:					.byte	0xE1, 0xDE, 0xBE, 0x7D, 0x7E, 0xBE, 0xDE, 0xE1		; heart (inverse)

;pattern:						.byte	0xC6, 0x89, 0x89, 0x89, 0x91, 0x91, 0x91, 0x63		; heart
;pattern_inv:					.byte	0x39, 0x76, 0x76, 0x76, 0x6E, 0x6E, 0x6E, 0x9C		; heart (inverse)

 	.text								; BOILERPLATE	Assemble into program memory
	.retain								; BOILERPLATE	Override ELF conditional linking and retain current section
	.retainrefs							; BOILERPLATE	Retain any sections that have references to current section
	.global init
	.global initNokia
	.global clearDisplay
	.global drawBlock					; draw the block
	.global animationDelay				; calls the animation delay
	.global	initPaddle					; initializes the padde location
	.global drawPaddle					; draw the paddle
	.global	drawGround					; draw the ground

;-------------------------------------------------------------------------------
;	Name:		animationDelay
;	Inputs:		none
;	Outputs:	none
;	Purpose:	creates a delay between block movements
;-------------------------------------------------------------------------------
animationDelay:

	push	R4
	push	R5

	mov		#200, R4		; 200 iterations of the short delay

innerDelay:
	mov		#04FFh, R5		; a short delay (supposed 20 ms)

decrementInner:
	dec		R5				; decrement the delay
	jnz		decrementInner

	dec		R4				; decrement the number of delays
	jnz		innerDelay

	pop		R5
	pop		R4

	ret

;-------------------------------------------------------------------------------
;	Name:		initNokia		68(rows)x92(columns)
;	Inputs:		none
;	Outputs:	none
;	Purpose:	Reset and initialize the Nokia Display
;-------------------------------------------------------------------------------
initNokia:

	push	R12
	push	R13

	bis.b	#LCD1202_CS_PIN, &P1OUT

	; This loop creates a nice 20mS delay for the reset low pulse
	bic.b	#LCD1202_RESET_PIN, &P2OUT
	mov		#04FFh, R12
delayNokiaResetLow:
	dec		R12
	jne		delayNokiaResetLow
	bis.b	#LCD1202_RESET_PIN, &P2OUT


	; This loop creates a nice 20mS delay for the reset high pulse
	mov		#04FFh, R12
delayNokiaResetHigh:
	dec		R12
	jne		delayNokiaResetHigh
	bic.b	#LCD1202_CS_PIN, &P1OUT

	; First write seems to come out a bit garbled - not sure cause
	; but it can't hurt to write a reset command twice
	mov		#NOKIA_CMD, R12
	mov		#STE2007_RESET, R13
	call	#writeNokiaByte

	mov		#NOKIA_CMD, R12
	mov		#STE2007_RESET, R13
	call	#writeNokiaByte

	mov		#NOKIA_CMD, R12
	mov		#STE2007_DISPLAYALLPOINTSOFF, R13
	call	#writeNokiaByte

	mov		#NOKIA_CMD, R12
	mov		#STE2007_POWERCONTROL | STE2007_POWERCTRL_ALL_ON, R13
	call	#writeNokiaByte

	mov		#NOKIA_CMD, R12
	mov		#STE2007_DISPLAYNORMAL, R13
	call	#writeNokiaByte

	mov		#NOKIA_CMD, R12
	mov		#STE2007_DISPLAYON, R13
	call	#writeNokiaByte

	pop		R13
	pop		R12

	ret

;-------------------------------------------------------------------------------
;	Name:		init
;	Inputs:		none
;	Outputs:	none
;	Purpose:	Setup the MSP430 to operate the Nokia 1202 Display
;-------------------------------------------------------------------------------
init:
	mov.b	#CALBC1_8MHZ, &BCSCTL1				; Setup fast clock
	mov.b	#CALDCO_8MHZ, &DCOCTL

	bis.w	#TASSEL_1 | MC_2, &TACTL
	bic.w	#TAIFG, &TACTL

	mov.b	#LCD1202_CS_PIN|LCD1202_BACKLIGHT_PIN|LCD1202_SCLK_PIN|LCD1202_MOSI_PIN, &P1OUT
	mov.b	#LCD1202_CS_PIN|LCD1202_BACKLIGHT_PIN|LCD1202_SCLK_PIN|LCD1202_MOSI_PIN, &P1DIR
	mov.b	#LCD1202_RESET_PIN, &P2OUT
	mov.b	#LCD1202_RESET_PIN, &P2DIR
	bis.b	#LCD1202_SCLK_PIN|LCD1202_MOSI_PIN, &P1SEL			; Select Secondary peripheral module function
	bis.b	#LCD1202_SCLK_PIN|LCD1202_MOSI_PIN, &P1SEL2			; by setting P1SEL and P1SEL2 = 1

	bis.b	#UCCKPH|UCMSB|UCMST|UCSYNC, &UCB0CTL0				; 3-pin, 8-bit SPI master
	bis.b	#UCSSEL_2, &UCB0CTL1								; SMCLK
	mov.b	#0x01, &UCB0BR0 									; 1:1
	mov.b	#0x00, &UCB0BR1
	bic.b	#UCSWRST, &UCB0CTL1

	; Buttons on the Nokia 1202
	;	S1		P2.1		Right
	;	S2		P2.2		Left
	;	S3		P2.3		Aux
	;	S4		P2.4		Bottom
	;	S5		P2.5		Up
	;
	;	7 6 5 4 3 2 1 0
	;	0 0 1 1 1 1 1 0		0x3E

	bis.b	#0x3E, &P2REN					; Pullup/Pulldown Resistor Enabled on P2.1 - P2.5
	bis.b	#0x3E, &P2OUT					; Assert output to pull-ups pin P2.1 - P2.5
	bic.b	#0x3E, &P2DIR

	ret

;-------------------------------------------------------------------------------
;	Name:		writeNokiaByte
;	Inputs:		R12 selects between (1) Data or (0) Command string
;				R13 the data or command byte
;	Outputs:	none
;	Purpose:	Write a command or data byte to the display using 9-bit format
;-------------------------------------------------------------------------------
writeNokiaByte:

	push	R12
	push	R13

	bic.b	#LCD1202_CS_PIN, &P1OUT							; LCD1202_SELECT
	bic.b	#LCD1202_SCLK_PIN | LCD1202_MOSI_PIN, &P1SEL	; Enable I/O function by clearing
	bic.b	#LCD1202_SCLK_PIN | LCD1202_MOSI_PIN, &P1SEL2	; LCD1202_DISABLE_HARDWARE_SPI;

	bit.b	#01h, R12
	jeq		cmd

	bis.b	#LCD1202_MOSI_PIN, &P1OUT						; LCD1202_MOSI_LO
	jmp		clock

cmd:
	bic.b	#LCD1202_MOSI_PIN, &P1OUT						; LCD1202_MOSI_HIGH

clock:
	bis.b	#LCD1202_SCLK_PIN, &P1OUT						; LCD1202_CLOCK		positive edge
	nop
	bic.b	#LCD1202_SCLK_PIN, &P1OUT						;					negative edge

	bis.b	#LCD1202_SCLK_PIN | LCD1202_MOSI_PIN, &P1SEL	; LCD1202_ENABLE_HARDWARE_SPI;
	bis.b	#LCD1202_SCLK_PIN | LCD1202_MOSI_PIN, &P1SEL2	;

	mov.b	R13, UCB0TXBUF

pollSPI:
	bit.b	#UCBUSY, &UCB0STAT
	jz		pollSPI											; while (UCB0STAT & UCBUSY);

	bis.b	#LCD1202_CS_PIN, &P1OUT							; LCD1202_DESELECT

	pop		R13
	pop		R12

	ret

;-------------------------------------------------------------------------------
;	Name:		clearDisplay
;	Inputs:		none
;	Outputs:	none
;	Purpose:	Writes 0x360 blank 8-bit columns to the Nokia display
;-------------------------------------------------------------------------------
clearDisplay:
	push	R11
	push	R12
	push	R13

	mov.w	#0x00, R12			; set display address to 0,0
	mov.w	#0x00, R13
	call	#setAddress

	mov.w	#0x01, R12			; write a "clear" set of pixels
	tst		R14
	jnz		bgLIGHT				; if the AUX button has not been pressed, jump to keep the screen normal
bgDARK:
	mov.w	#0xFF, R13			; otherwise, make the background DARK
	jmp		bgChanged
bgLIGHT:
	mov.w	#0x00, R13			; to every byte on the display
bgChanged:
	mov.w	#0x360, R11			; loop counter
clearLoop:
	call	#writeNokiaByte
	dec.w	R11
	jnz		clearLoop

	mov.w	#0x00, R12			; set display address to 0,0
	mov.w	#0x00, R13
	call	#setAddress

	pop		R13
	pop		R12
	pop		R11

	ret

;-------------------------------------------------------------------------------
;	Name:		setAddress
;	Inputs:		R12		row
;				R13		col
;	Outputs:	none
;	Purpose:	Sets the cursor address on the 9 row x 96 column display
;-------------------------------------------------------------------------------
setAddress:
	push	R12
	push	R13

	; Since there are only 9 rows on the 1202, we can select the row in 4-bits
	mov.w	R12, R13			; Write a command, setup call to
	mov.w	#0x00, R12
	and.w	#0x0F, R13			; mask out any weird upper nibble bits and
	bis.w	#0xB0, R13			; mask in "B0" as the prefix for a page address
	call	#writeNokiaByte

	; Since there are only 96 columns on the 1202, we need 2 sets of 4-bits
	mov.w	#0x00, R12
	pop		R13					; make a copy of the column address in R13 from the stack
	push	R13
	rra.w	R13					; shift right 4 bits
	rra.w	R13
	rra.w	R13
	rra.w	R13
	and.w	#0x0F, R13			; mask out upper nibble
	bis.w	#0x10, R13			; 10 is the prefix for a upper column address
	call	#writeNokiaByte

	mov.w	#0x00, R12			; Write a command, setup call to
	pop		R13					; make a copy of the top of the stack
	push	R13
	and.w	#0x0F, R13
	call	#writeNokiaByte

	pop		R13
	pop		R12

	ret

;-------------------------------------------------------------------------------
;	Name:		reDrawDisplay
;	Inputs:		R12 pointer to array[12] containing heights of bars
;	Outputs:	none
;	Purpose:	redraw the entire 96x68 display with 12 vertical bars, the
;				bar in column i has height 8xheight[i] pixels and is 8-bits
;				wide.  The bottom 4 pixels of each bar column are intentionally
;				left blank.  This space could be used for a blinking indicator
;	Registers:	R5	column counter
;				R6	row counter
;-------------------------------------------------------------------------------
reDrawDisplay:
		push	R5				; column counter
		push	R6
		push	R7
		push	R12				; row to draw the block		[0-7
		push	R13				; column to draw the block	[0-11]

		call	#clearDisplay	; start with a blank screen and then overlay bars

		; Since I have set the height array to a bunch of illegal values
		; causing this routine to crash, I thought that it would be a good
		; idea to test the array and saturate any illegal values to safe
		; values bounded by [0-7].
		mov		R12, R5			; R5 is now a tmp pointer to the height array
		mov.w	#11, R6			; loop count var
chkLowerDD:
		mov.b	@R5, R7
		cmp.b	#0,R7
		jhs		chkUpperDD
		mov.b	#0,0(R5)

chkUpperDD:
		cmp.b	#8,R7
		jlo		chkNextDD
		mov.b	#7,0(R5)

chkNextDD:
		inc		R5
		dec		R6
		jge		chkLowerDD

		mov		R12, R5			; copy the height array pointer so that we can call drawBlock
		clr		R13				; Draw columns (indexed by R13 in drawBlock) from left to right on the display

colDD:							; For each column, draw blocks from bottom to top
		clr.w	R6
		mov.b	@R5, R6			; load height[R5] into R6

rowDD:
		mov		R6, R12			; mov the decrementing height into R12
		inv.w	R12				; flip the bits and add one so that the negative can be
		inc.w	R12				; added to 7 to form the complement allowing the
		add.w	#7, R12			; blocks to be draw from bottom to top

		call	#drawBlock		; R12=row, R13=column
		dec		R6				; draw the next lower block - since we allow the
		jge		rowDD			; R6 to equal zero

nextDD:
		; you are now back into the outer loop of colDD
		inc		R5				; point to the next element in heightArray
		inc		R13				; prepare to start drawing the next column
		cmp		#12, R13		; check if we have drawn all 12 columns (if we are done)
		jnz		colDD

		pop		R13
		pop		R12
		pop		R7
		pop		R6
		pop		R5

		ret						; bye-bye

;-------------------------------------------------------------------------------
;	Name:		drawBlock
;	Inputs:		R12 row to draw block
;				R13	column to draw block
;	Outputs:	none
;	Purpose:	draw an 8x8 block of black pixels at screeen cordinates	8*row,8*col
;				The display screen, for the purposes of this routine, is divided
;				into 8x8 blocks.  Consequently the codinate system, for the purposes
;				of this routine, start in the upper left of the screen @ (0,0) and
;				end @ (11,7) in the lower right of the display.
;	Registers:	R5	column counter to draw all 8 pixel columns
;-------------------------------------------------------------------------------
drawBlock:
	push	R5
	push	R12
	push	R13
	push	R8
	push	R9

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

	pop		R9
	pop		R8
	pop		R13
	pop		R12
	pop		R5

	ret							; return whence you came

;-------------------------------------------------------------------------------
;	Name:		drawPaddle
;	Inputs:		R12 row to draw paddle
;				R13	column to draw paddle
;	Outputs:	none
;	Purpose:	draw an 8x24 block of black pixels at screeen cordinates	8*row,8*col
;				The display screen, for the purposes of this routine, is divided
;				into 8x8 blocks.  Consequently the codinate system, for the purposes
;				of this routine, start in the upper left of the screen @ (0,0) and
;				end @ (11,7) in the lower right of the display.
;	Registers:	R8	column counter to draw all 8 pixel columns
;				R7	row counter to draw 3 rows (height of the paddle)
;-------------------------------------------------------------------------------
drawPaddle:
	push	R12
	push	R13
	push	R7
	push	R8
	push	R10

	mov		R12, R10					; R10 is the temp row address holder

	mov		#PADDLE_HEIGHT, R7			; row counter

nextRow:

	mov		#PADDLE_WIDTH, R8			; column counter

	mov		#PADDLE_START_X, R13		; sets the x position of the paddle

	call	#setAddress					; move cursor to upper left corner of block

	mov		#1, R12

	tst		R14
	jnz		darkPaddle
	; if R14 is 0, then turn paddle light
	mov		#0x00, R13
	jmp		continuePaddle
darkPaddle:
	; otherwise, keep paddle dark
	mov		#0xFF, R13

continuePaddle:
	call	#writeNokiaByte				; draw the pixels

	dec		R8
	jnz		continuePaddle

	inc		R10
	mov		R10, R12
	dec		R7
	jnz		nextRow

	pop		R10
	pop		R8
	pop		R7
	pop		R13
	pop		R12

	ret							; return whence you came

;-------------------------------------------------------------------------------
;	Name:		drawGround
;	Inputs:		R12 row to draw ground
;				R13	column to draw ground
;	Outputs:	none
;	Purpose:	draw an 8 block x 96 pixels of black pixels at screeen cordinates
;	Registers:	R8	column counter to draw all 96 pixel columns
;-------------------------------------------------------------------------------
drawGround:
	push	R12
	push	R13
	push	R8			; counter to draw the columns

	mov		#8, R12		; 9th row (the cut-off row)
	mov		#0, R13		; start from the left-most side of the screen

	mov		#96, R8

	call	#setAddress

	mov		#1, R12

	tst		R14
	jnz		darkGND
	; if R14 is not zero, then draw the dark ground
	; otherwise, draw the light-colored ground
lightGND:
	mov		#0x00, R13
	jmp		nextCol
darkGND:
	mov		#0x0F, R13
nextCol:
	call	#writeNokiaByte

	dec		R8
	jnz		nextCol

	pop		R8
	pop		R13
	pop		R12

	ret
