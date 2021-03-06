//-------------------------------------------------------------------------------
//	Name:		C2C Sabin Park
//	Term:		Fall 2014
//	MCU:		MSP430G2553
//	Date:		21 October 2014
//	Note:		Lab 4: Pong Implementation File
//-------------------------------------------------------------------------------

#include <msp430g2553.h>	// header for the MSP430
#include "pong_lab4.h"		// includes the pong header

vector2d_t initVector(int x, int y) {
	vector2d_t thisVector;
	thisVector.x = x;
	thisVector.y = y;

	return thisVector;
}

paddle_t createPaddle(int xPos, int yPos, int width, int height) {
	paddle_t thisPaddle;

	thisPaddle.position = initVector(xPos, yPos);
	thisPaddle.width = width;
	thisPaddle.height = height;

	return thisPaddle;
}

ball_t createBall(int xPos, int yPos, int xVel, int yVel, unsigned char radius, unsigned char color) {
	ball_t thisBall;

	thisBall.position = initVector(xPos, yPos);
	thisBall.velocity = initVector(xVel, yVel);

	thisBall.radius = radius;
	thisBall.color = color;

	return thisBall;
}

ball_t moveBall(ball_t ball, paddle_t paddle) {
	// if the ball hits the left or right edge, reverse the x velocity
	if(leftCollision(ball, paddle) || rightCollision(ball)) {
		ball.velocity.x *= -1;
	}

	// if the ball hits the top or bottom edge, reverse the y velocity
	if(topCollision(ball) || bottomCollision(ball)) {
		ball.velocity.y *= -1;
	}

	outOfBounds(ball);		// check if the ball goes behind the paddle

	// makes the ball move
	ball.position.x += ball.velocity.x;
	ball.position.y += ball.velocity.y;

	return ball;
}

// if the ball gets out of bounds, just get into an infinite loop to signal GAME OVER
c outOfBounds(ball_t ball) {
	if(ball.position.x <= 0) {
		while(1);
	}
}

c topCollision(ball_t ball) {
	// if the ball hits the top edge, reverse the y velocity
	if(ball.position.y <= 0)
		return TRUE;
	else
		return FALSE;
}

c bottomCollision(ball_t ball) {
	// if the ball hits the bottom edge, reverse the y velocity
	if(ball.position.y >= SCREEN_HEIGHT)
		return TRUE;
	else
		return FALSE;
}

// paddle parameter was added to allow comparison between paddle and ball positions
c leftCollision(ball_t ball, paddle_t paddle) {
	// if the ball hits the paddle, reverse the x velocity

	if(ball.position.x <= (paddle.position.x + paddle.width) &&		// ball is behind paddle (to the left)
			ball.position.y >= (paddle.position.y) &&				// ball is below the top of the paddle
			(ball.position.y + 1) <= (paddle.position.y + 3))		// ball is above the bottom of the paddle
		return TRUE;
	else
		return FALSE;
}

c rightCollision(ball_t ball) {
	// if the ball hits the right edge, reverse the x velocity
	if(ball.position.x  >= SCREEN_WIDTH)
		return TRUE;
	else
		return FALSE;
}
