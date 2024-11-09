#include <stdio.h>
#include <pigpio.h>

int main() {
    if (gpioInitialise() < 0) {
        printf("Failed to initialize GPIO\n");
        return 1;
    }

    gpioSetMode(27, PI_OUTPUT);       // Set GPIO 27 as output
    gpioSetPullUpDown(27, PI_PUD_DOWN);  // Apply pull-down resistor

    printf("Setting GPIO 27 low...\n");
    gpioWrite(27, 0);  // Set low
    printf("GPIO 27 state: %d\n", gpioRead(27));

    printf("Setting GPIO 27 high...\n");
    gpioWrite(27, 1);  // Set high
    printf("GPIO 27 state: %d\n", gpioRead(27));

    gpioTerminate();
    return 0;
}
