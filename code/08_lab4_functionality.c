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


	paddle_x = PADDLE_START_X;
	paddle_y = PADDLE_START_Y;

	// === Initialize system ================================================
	IFG1=0; /* clear interrupt flag1 */
	WDTCTL=WDTPW+WDTHOLD; /* stop WD */
	button_press = FALSE;

	ball_t pong = createBall(START_X_POS, START_Y_POS, START_X_VEL, START_Y_VEL, 4, 1);
	paddle_t ping = createPaddle(paddle_x, paddle_y, PADDLE_WIDTH, PADDLE_HEIGHT);

	init();
	initNokia();
	clearDisplay();

	drawBlock(pong.position.y, pong.position.x, pong.color);

	while(1) {

		clearDisplay();
		pong = moveBall(pong, ping);

		drawBlock(pong.position.y, pong.position.x, pong.color);

		drawPaddle(ping.position.y, ping.position.x);

		drawGround();

		animationDelay();

    		if (AUX_BUTTON == 0) {
				while(AUX_BUTTON == 0);

				if(pong.color == 1) pong.color = 0;
				else if(pong.color == 0) pong.color = 1;
				button_press = TRUE;

			} else if (UP_BUTTON == 0) {
				while(UP_BUTTON == 0);

				if(ping.position.y > 0)
					ping.position.y -= 1;

				button_press = TRUE;

			} else if (DOWN_BUTTON == 0) {
				while(DOWN_BUTTON == 0);

				if(ping.position.y < 8-3)
					ping.position.y += 1;

				button_press = TRUE;
			}

			if (button_press)
				button_press = FALSE;
		}
}
