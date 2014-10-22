#include <msp430g2553.h>
#include "pong_lab4.h"

extern void init();
extern void initNokia();
extern void clearDisplay();
extern void drawBlock(unsigned char row, unsigned char col, unsigned char color);
extern void animationDelay();

#define		TRUE			1
#define		FALSE			0
#define		UP_BUTTON		(P2IN & BIT5)
#define		DOWN_BUTTON		(P2IN & BIT4)
#define		AUX_BUTTON		(P2IN & BIT3)
#define		LEFT_BUTTON		(P2IN & BIT2)
#define		RIGHT_BUTTON	(P2IN & BIT1)


void main() {

	unsigned char button_press;

	// === Initialize system ================================================
	IFG1=0; /* clear interrupt flag1 */
	WDTCTL=WDTPW+WDTHOLD; /* stop WD */
	button_press = FALSE;

	ball_t pong = createBall(START_X_POS, START_Y_POS, START_X_VEL, START_Y_VEL, 4, 1);

	init();
	initNokia();
	clearDisplay();

	drawBlock(pong.position.y, pong.position.x, pong.color);

	while(1) {

		clearDisplay();
		pong = moveBall(pong);

		drawBlock(pong.position.y, pong.position.x, pong.color);
		animationDelay();

    		if (AUX_BUTTON == 0) {
				while(AUX_BUTTON == 0);

				if(pong.color == 1) pong.color = 0;
				else if(pong.color == 0) pong.color = 1;
				button_press = TRUE;
			}

			if (button_press) {
				button_press = FALSE;
				//clearDisplay();
				//drawBlock(y,x,c);
			}
		}
}
