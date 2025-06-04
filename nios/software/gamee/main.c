#include <stdio.h>
#include "system.h"
#include "io.h"
#include "alt_types.h"

// Constants
#define SCREEN_WIDTH   640
#define SCREEN_HEIGHT  480

#define PADDLE_WIDTH   10
#define PADDLE_HEIGHT  40
#define BALL_SIZE      8

#define PADDLE_MIN     0
#define PADDLE_MAX     (SCREEN_HEIGHT - PADDLE_HEIGHT)

#define BALL_MIN_X     0
#define BALL_MAX_X     (SCREEN_WIDTH - BALL_SIZE)
#define BALL_MIN_Y     0
#define BALL_MAX_Y     (SCREEN_HEIGHT - BALL_SIZE)

// Ball state
int ball_x = SCREEN_WIDTH / 2;
int ball_y = SCREEN_HEIGHT / 2;
int ball_dx = 2;
int ball_dy = 2;

// Paddle positions (Y)
int paddle1_pos = 100;
int paddle2_pos = 100;

// Simple delay (busy wait)
void delay(int ms) {
    volatile int i;
    for (i = 0; i < ms * 1000; i++) {
        asm volatile("nop");
    }
}

// Clamp function
int clamp(int val, int min, int max) {
    if (val < min) return min;
    if (val > max) return max;
    return val;
}

// Update paddle positions
void update_paddles(int p1, int p2) {
    paddle1_pos = clamp(p1, PADDLE_MIN, PADDLE_MAX);
    paddle2_pos = clamp(p2, PADDLE_MIN, PADDLE_MAX);

    // Combine paddles into 16-bit debug output (optional)
    alt_u16 combined = (paddle2_pos << 8) | (paddle1_pos);
    IOWR_ALTERA_AVALON_PIO_DATA(PIO_0_BASE, combined);
}

// Update ball position and handle collisions
void update_ball() {
    // Update ball position
    ball_x += ball_dx;
    ball_y += ball_dy;

    // Bounce off top/bottom
    if (ball_y <= BALL_MIN_Y || ball_y >= BALL_MAX_Y) {
        ball_dy = -ball_dy;
        ball_y = clamp(ball_y, BALL_MIN_Y, BALL_MAX_Y);
    }

    // Left paddle collision
    if (ball_x <= 20) { // Near left paddle (x = 10-19)
        if (ball_y + BALL_SIZE >= paddle1_pos &&
            ball_y <= paddle1_pos + PADDLE_HEIGHT) {
            ball_dx = -ball_dx;
            ball_x = 21; // Prevent sticking
        }
    }

    // Right paddle collision
    if (ball_x + BALL_SIZE >= 610) { // Near right paddle (x = 610-619)
        if (ball_y + BALL_SIZE >= paddle2_pos &&
            ball_y <= paddle2_pos + PADDLE_HEIGHT) {
            ball_dx = -ball_dx;
            ball_x = 610 - BALL_SIZE - 1;
        }
    }

    // Ball out of bounds (score or reset)
    if (ball_x < BALL_MIN_X || ball_x > BALL_MAX_X) {
        // Reset ball to center
        ball_x = SCREEN_WIDTH / 2;
        ball_y = SCREEN_HEIGHT / 2;
        ball_dx = (ball_dx > 0) ? -2 : 2;
        ball_dy = 2;
    }
}

int main() {
    printf("Starting Pong game on Nios II...\n");

    while (1) {
        // Read paddles from PIO
        int p1 = IORD_ALTERA_AVALON_PIO_DATA(PIO_PADDLE1_BASE);
        int p2 = IORD_ALTERA_AVALON_PIO_DATA(PIO_PADDLE2_BASE);

        // Update paddle positions
        update_paddles(p1, p2);

        // Update ball
        update_ball();

        // Output positions to PIOs
        IOWR_ALTERA_AVALON_PIO_DATA(PIO_BALL_X_BASE, ball_x);
        IOWR_ALTERA_AVALON_PIO_DATA(PIO_BALL_Y_BASE, ball_y);

        // Delay for game speed
        delay(25); // ~40 FPS
    }

    return 0;
}
