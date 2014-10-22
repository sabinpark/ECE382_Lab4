//-------------------------------------------------------------------------------
//	Name:		C2C Sabin Park
//	Term:		Fall 2014
//	MCU:		MSP430G2553
//	Date:		21 October 2014
//	Note:		Header file for Pong
//-------------------------------------------------------------------------------

#ifndef PONG_LAB4_H_
#define PONG_LAB4_H_

#define SCREEN_WIDTH 11
#define SCREEN_HEIGHT 7

#define TRUE 1
#define FALSE 0

#define START_X_POS 4
#define START_Y_POS 3

#define START_X_VEL 1
#define START_Y_VEL 1

typedef char c;

typedef struct {
    int x;
    int y;
} vector2d_t;

typedef struct {
    vector2d_t position;
    vector2d_t velocity;
    unsigned char radius;
    unsigned char color;
} ball_t;

ball_t createBall(int xPos, int yPos, int xVel, int yVel, unsigned char radius, unsigned char color);
ball_t moveBall(ball_t ball);
vector2d_t initVector(int x, int y);

c topCollision(ball_t ball);
c bottomCollision(ball_t ball);
c leftCollision(ball_t ball);
c rightCollision(ball_t ball);

#endif
