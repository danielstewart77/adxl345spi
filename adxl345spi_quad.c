#include <stdio.h>
#include <pigpio.h>
#include <time.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <pthread.h>
#include <fcntl.h>
#include <sys/stat.h>

#define DATA_FORMAT   0x31
#define DATA_FORMAT_B 0x0B
#define READ_BIT      0x80
#define MULTI_BIT     0x40
#define BW_RATE       0x2C
#define POWER_CTL     0x2D
#define DATAX0        0x32

const char codeVersion[4] = "0.3";
const int timeDefault = 5;
const int freqDefault = 5;
const int freqMax = 3200;
const int speedSPI = 2000000;
const int freqMaxSPI = 100000;
const int coldStartSamples = 2;
const double coldStartDelay = 0.1;
const double accConversion = 2 * 16.0 / 8192.0;
const double tStatusReport = 1;

volatile int running = 0;
volatile int quit = 0;
int h1;
char vSave[256] = "";
double vFreq = freqDefault;
double vTime = timeDefault;

void signalHandler(int signum) {
    printf("\nReceived signal %d, stopping data collection...\n", signum);
    running = 0;
    quit = 1;
}

void printUsage() {
    printf("adxl345spi (version %s)\n"
           "Usage: adxl345spi [OPTION]...\n"
           "Read data from ADXL345 accelerometer through SPI interface on Raspberry Pi.\n"
           "Options:\n"
           "  -s, --save FILE     Save data to specified FILE (otherwise printed to console)\n"
           "  -f, --freq FREQ     Set the sampling rate to FREQ Hz (default: %i Hz)\n"
           , codeVersion, freqDefault);
}

void selectChip(int csPin) {
    // Set all CS pins high (inactive)
    gpioWrite(8, 1);  // CS0
    gpioWrite(7, 1);  // CS1
    gpioWrite(22, 1); // CS2
    gpioWrite(27, 1); // CS3

    // Set the selected CS pin low (active)
    if (csPin != -1) {
        gpioWrite(csPin, 0);
    }
}

int readBytes(int handle, char *data, int count, int csPin) {
    selectChip(csPin);  // Select the appropriate CS pin

    data[0] |= READ_BIT;
    if (count > 1) data[0] |= MULTI_BIT;

    int result = spiXfer(handle, data, data, count);

    selectChip(-1);  // Deselect all CS pins
    return result;
}

int writeBytes(int handle, char *data, int count, int csPin) {
    selectChip(csPin);  // Select the appropriate CS pin
    if (count > 1) data[0] |= MULTI_BIT;
    int result = spiWrite(handle, data, count);
    selectChip(-1);  // Deselect all CS pins

    return result;
}

void *dataCollectionThread(void *arg) {
    char data1[7], data2[7], data3[7], data4[7];
    int16_t x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4;
    double tStart, t;
    FILE *f = NULL;

    // Check if vSave is not empty, if so open the file to write data
    if (strlen(vSave) > 0) {
        f = fopen(vSave, "w");
        if (f == NULL) {
            printf("Failed to open file %s for writing!\n", vSave);
            running = 0;
            return NULL;
        }
        fprintf(f, "time, x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4\n");
    }

    double delay = 1.0 / vFreq;
    tStart = time_time();

    while (running) {
        data1[0] = DATAX0;
        data2[0] = DATAX0;
        data3[0] = DATAX0;
	data4[0] = DATAX0;

        int bytes1 = readBytes(h1, data1, 7, 8);  // CS0 for the first accelerometer
        int bytes2 = readBytes(h1, data2, 7, 7);  // CS1 for the second accelerometer
        int bytes3 = readBytes(h1, data3, 7, 22); // CS2 for the third accelerometer
	    int bytes4 = readBytes(h1, data4, 7, 27); // CS3 for the fourth accelerometer

	if (bytes3 != 7) {
    		printf("Error reading 3rd sensor, bytes read: %d\n", bytes3);
	}
	if (bytes4 != 7) {
    		printf("Error reading 4th sensor, bytes read: %d\n", bytes4);
	}

        if (bytes1 == 7 && bytes2 == 7 && bytes3 == 7 && bytes4 == 7) {
            x1 = (data1[2] << 8) | data1[1];
            y1 = (data1[4] << 8) | data1[3];
            z1 = (data1[6] << 8) | data1[5];

            x2 = (data2[2] << 8) | data2[1];
            y2 = (data2[4] << 8) | data2[3];
            z2 = (data2[6] << 8) | data2[5];

            x3 = (data3[2] << 8) | data3[1];
            y3 = (data3[4] << 8) | data3[3];
            z3 = (data3[6] << 8) | data3[5];

	        x4 = (data4[2] << 8) | data4[1];
            y4 = (data4[4] << 8) | data4[3];
            z4 = (data4[6] << 8) | data4[5];

            t = time_time() - tStart;

            if (f) {
                fprintf(f, "%.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f, %.5f\n",
			t, x1 * accConversion, y1 * accConversion, z1 * accConversion,
			x2 * accConversion, y2 * accConversion, z2 * accConversion,
			x3 * accConversion, y3 * accConversion, z3 * accConversion,
			x4 * accConversion, y4 * accConversion, z4 * accConversion);
            } else {
                printf("time = %.3f, x1 = %.3f, y1 = %.3f, z1 = %.3f, x2 = %.3f, y2 = %.3f, z2 = %.3f, "
			"x3 = %.3f, y3 = %.3f, z3 = %.3f, x4 = %.3f, y4 = %.3f, z4 = %.3f\n",
			t, x1 * accConversion, y1 * accConversion, z1 * accConversion,
			x2 * accConversion, y2 * accConversion, z2 * accConversion,
			x3 * accConversion, y3 * accConversion, z3 * accConversion,
			x4 * accConversion, y4 * accConversion, z4 * accConversion);
            }
        } else {
            printf("Error reading data!\n");
            running = 0;
        }
        time_sleep(delay);
    }

    if (f) {
        fclose(f);
        printf("Data written to %s\n", vSave);
    }

    printf("Data collection stopped.\n");
    return NULL;
}

void startDataCollection() {
    if (!running) {
        running = 1;
        pthread_t thread_id;
        pthread_create(&thread_id, NULL, dataCollectionThread, NULL);
        pthread_detach(thread_id);  /* Detached since we'll never join this thread */
    } else {
        printf("Data collection is already running.\n");
    }
}

void stopDataCollection() {
    if (running) {
        running = 0;
        printf("Stopping data collection...\n");
    } else {
        printf("Data collection is not running.\n");
    }
}

void listenForCommands() {
    const char *fifo = "/opt/redoak/adxl345spi_fifo";
    unlink(fifo);  // Remove any existing FIFO file to clear previous contents
    mkfifo(fifo, 0666);

    char command[256];
    int fd;

    while (!quit) {
        fd = open(fifo, O_RDONLY);
        read(fd, command, 256);
        close(fd);

        if (strncmp(command, "start", 5) == 0) {
            startDataCollection();
        } else if (strncmp(command, "stop", 4) == 0) {
            stopDataCollection();
        } else if (strncmp(command, "quit", 4) == 0) {
            printf("Quit command received, shutting down...\n");
            stopDataCollection();
            quit = 1;
        } else {
            printf("Unknown command: %s\n", command);
        }
    }
}

int main(int argc, char *argv[]) {
    signal(SIGINT, signalHandler);

    int i;
    for (i = 1; i < argc; i++) {
        if ((strcmp(argv[i], "-s") == 0) || (strcmp(argv[i], "--save") == 0)) {
            if (i + 1 <= argc - 1) {
                i++;
                strcpy(vSave, argv[i]);
            } else {
                printUsage();
                return 1;
            }
        } else if ((strcmp(argv[i], "-f") == 0) || (strcmp(argv[i], "--freq") == 0)) {
            if (i + 1 <= argc - 1) {
                i++;
                vFreq = atoi(argv[i]);
                if ((vFreq < 1) || (vFreq > 3200)) {
                    printf("Wrong sampling rate specified!\n\n");
                    printUsage();
                    return 1;
                }
            } else {
                printUsage();
                return 1;
            }
        } else {
            printUsage();
            return 1;
        }
    }

    if (gpioInitialise() < 0) {
        printf("Failed to initialize GPIO!\n");
        return 1;
    }

    // Initialize GPIO pins for manual CS control
    gpioSetMode(8, PI_OUTPUT);   // CS0
    gpioSetMode(7, PI_OUTPUT);   // CS1
    gpioSetMode(22, PI_OUTPUT);  // CS2
    gpioSetMode(27, PI_OUTPUT);  // CS3

    gpioSetPullUpDown(22, PI_PUD_DOWN);  // Apply pull-down resistor
    gpioSetPullUpDown(27, PI_PUD_DOWN);  // Apply pull-down resistor

    gpioWrite(8, 1);  // Set CS0 to high (inactive)
    gpioWrite(7, 1);  // Set CS1 to high (inactive)
    gpioWrite(22, 1); // Set CS2 to high (inactive)
    gpioWrite(27, 1); // Set CS3 to high (inactive)

    h1 = spiOpen(0, speedSPI, 3);  // Open SPI channel

    if (h1 < 0) {
        printf("Failed to open SPI device!\n");
        return 1;
    }

    char data[2];

    // Step 1: Reset sensors to standby mode (optional but recommended)
    data[0] = POWER_CTL;
    data[1] = 0x00;
    writeBytes(h1, data, 2, 8);
    writeBytes(h1, data, 2, 7);
    writeBytes(h1, data, 2, 22);
    writeBytes(h1, data, 2, 27);

    // Step 2: Set the data rate (BW_RATE)
    data[0] = BW_RATE;
    data[1] = 0x0F;
    writeBytes(h1, data, 2, 8);
    writeBytes(h1, data, 2, 7);
    writeBytes(h1, data, 2, 22);
    writeBytes(h1, data, 2, 27);

    // Step 3: Set the data format (DATA_FORMAT)
    data[0] = DATA_FORMAT;
    data[1] = DATA_FORMAT_B;  // Full resolution, ±16g
    writeBytes(h1, data, 2, 8);
    writeBytes(h1, data, 2, 7);
    writeBytes(h1, data, 2, 22);
    writeBytes(h1, data, 2, 27);

    // Step 4: Set to measurement mode (POWER_CTL)
    data[0] = POWER_CTL;
    data[1] = 0x08;  // Measurement mode
    writeBytes(h1, data, 2, 8);
    writeBytes(h1, data, 2, 7);
    writeBytes(h1, data, 2, 22);
    writeBytes(h1, data, 2, 27);

    // Add a small delay to ensure all sensors are ready
    time_sleep(0.01);  // 10 ms delay

    // Automatically start data collection
    startDataCollection();

    listenForCommands();

    spiClose(h1);

    gpioTerminate();
    printf("Program terminated.\n");
    return 0;
}