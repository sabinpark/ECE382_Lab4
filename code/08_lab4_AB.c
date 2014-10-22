//-------------------------------------------------------------------------------
//	Name:		C2C Sabin Park
//	Term:		Fall 2014
//	MCU:		MSP430G2553
//	Date:		21 October 2014
//	Note:		Lab 4: Pong Main File for B and A Functionality
//				Use this file with:
//					08_nokia.asm, pong_lab4.h, and 08_pong_implementation.c
//-------------------------------------------------------------------------------

#include <msp430g2553.h>
#include "pong_lab4.h"

extern void init();
extern void initNokia();
extern void clearDisplay();
extern void drawBlock(unsigned char row, unsigned char col, unsigned char color);
extern void animationDelay();
extern void	initPaddle();
extern void	drawPaddle(unsigned char row, unsigned char col);
extern void drawGround();

static unsigned char paddle_x, paddle_y;

#define		TRUE			1
#define		FALSE			0
#define		UP_BUTTON		(P2IN & BIT5)
#define		DOWN_BUTTON		(P2IN & BIT4)
#define		AUX_BUTTON		(P2IN & BIT3)
#define		LEFT_BUTTON		(P2IN & BIT2)
#define		RIGHT_BUTTON	(P2IN & BIT1)
#define		PADDLE_WIDTH	1
#define		PADDLE_HEIGHT	3

void main() {

	unsigned char button_press;

	paddle_x = PADDLE_START_X;		// initializes the paddle location
	paddle_y = PADDLE_START_Y;

	// === Initialize system ================================================
	IFG1=0; /* clear interrupt flag1 */
	WDTCTL=WDTPW+WDTHOLD; /* stop WD */
	button_press = FALSE;

	// creates the ball and paddle
	ball_t pong = createBall(START_X_POS, START_Y_POS, START_X_VEL, START_Y_VEL, 4, 1);
	paddle_t ping = createPaddle(paddle_x, paddle_y, PADDLE_WIDTH, PADDLE_HEIGHT);

	init();
	initNokia();
	clearDisplay();

	while(1) {

		clearDisplay();		// clears the display before drawing anything

		pong = moveBall(pong, ping);	// moves the ball

		drawBlock(pong.position.y, pong.position.x, pong.color); 	// draws the ball

		drawPaddle(ping.position.y, ping.position.x);				// draws the paddle

		drawGround();												// draws the ground

		animationDelay();											// adds in a delay between moves

		// checks for the AUX button
    	if (AUX_BUTTON == 0) {
			while(AUX_BUTTON == 0);

			if(pong.color == 1) pong.color = 0;
			else if(pong.color == 0) pong.color = 1;
			button_press = TRUE;

		} else if (UP_BUTTON == 0) {  // check the UP button
			while(UP_BUTTON == 0);

			if(ping.position.y > 0)		// to ensure the ball doesn't get too high
				ping.position.y -= 1;

			button_press = TRUE;

		} else if (DOWN_BUTTON == 0) {  // check the DOWN button
			while(DOWN_BUTTON == 0);

			if(ping.position.y < 8-3)	// to ensure the ball doesn't get too low
				ping.position.y += 1;

			button_press = TRUE;
		}

		if (button_press)		// reset the button flag
			button_press = FALSE;
	}
}
