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

	unsigned char	x, y, button_press, c;

	// === Initialize system ================================================
	IFG1=0; /* clear interrupt flag1 */
	WDTCTL=WDTPW+WDTHOLD; /* stop WD */
	button_press = FALSE;

	ball_t pong = createBall(2, 2, 1, 1, 4, 1);

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


				//if(c == 1) c = 0;
				//else if(c == 0) c = 1;
				button_press = TRUE;
			}

//			if (button_press) {
//				button_press = FALSE;
//				//clearDisplay();
//				drawBlock(y,x,c);
//			}
		}
}
