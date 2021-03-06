//-------------------------------------------------------------------------------
//	Name:		C2C Sabin Park
//	Term:		Fall 2014
//	MCU:		MSP430G2553
//	Date:		21 October 2014
//	Note:		Header file for Pong
//-------------------------------------------------------------------------------

#ifndef PONG_LAB4_H_
#define PONG_LAB4_H_

#define SCREEN_WIDTH 48-4		// since I implemented the smooth animation, I had to divide 96 by 2
#define SCREEN_HEIGHT 7

#define TRUE 1
#define FALSE 0

#define START_X_POS 20			// ball's starting x and y pos
#define START_Y_POS 3

#define START_X_VEL 1			// ball's starting x and y vel
#define START_Y_VEL 1

#define PADDLE_START_X 2		// paddle's starting x and y pos
#define PADDLE_START_Y 4

typedef char c;					// arbitrarily named; used for the collision detections

// vector
typedef struct {
    int x;
    int y;
} vector2d_t;

// ball
typedef struct {
    vector2d_t position;
    vector2d_t velocity;
    unsigned char radius;
    unsigned char color;
} ball_t;

// paddle
typedef struct {
    vector2d_t position;
    int width;
    int height;
} paddle_t;

ball_t createBall(int xPos, int yPos, int xVel, int yVel, unsigned char radius, unsigned char color);
ball_t moveBall(ball_t ball, paddle_t paddle);
vector2d_t initVector(int x, int y);
paddle_t createPaddle(int xPos, int yPos, int width, int height);

c outOfBounds(ball_t ball);
c topCollision(ball_t ball);
c bottomCollision(ball_t ball);
c leftCollision(ball_t ball, paddle_t paddle);
c rightCollision(ball_t ball);

#endif
