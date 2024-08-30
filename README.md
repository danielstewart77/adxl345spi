# diagram for CS pins
<img width="540" alt="interface_options" src="https://github.com/user-attachments/assets/9dd91471-7fa5-4023-b669-858dd7de4aa4">

# enable spi on the pi
`sudo raspi-config`

<img width="540" alt="interface_options" src="https://github.com/user-attachments/assets/a591c801-454a-493b-9a5c-e1adf38396d8">

<img width="541" alt="enable_spi" src="https://github.com/user-attachments/assets/2dd9b149-3348-4186-b72a-def40f93bb00">

## install python (if not already installed)
`sudo apt-get install python3`
`sudo apt install python3-spidev`
`sudo apt install raspberrypi-kernel-headers`
`sudo apt install libpython3-dev python3-pip`
`ls /dev/spi*`

## clone repo:
`git clone https://github.com/danielstewart77/adxl345spi.git`
`cd adxl345spi`

## download pigpio-master
`wget https://github.com/joan2937/pigpio/archive/master.zip`
`unzip master.zip`
`cd pigpio-master`
`make`
`sudo make install`

# launch console app in virtual environment:
`venv/bin/python3 console_driver.py`

## ADXL345 Controller Script

This Python script is designed to interface with the ADXL345 accelerometer via a command-line application. The script provides a simple console-based interface to start, stop, or quit the data collection process, and it also handles some initial setup tasks. Below is a summary of the key functionalities:

### Key Functionalities

1. **Execute Shell Commands:**
   - The `execute_command(command)` function is used to run shell commands. It employs `subprocess.Popen` to execute the command in a shell environment. If the command fails, it catches the error and prints an error message.

2. **Application Control:**
   - **`start_application()`**: Sends a "start" command to the `/tmp/adxl345spi_fifo` file to initiate data collection.
   - **`stop_application()`**: Sends a "stop" command to halt data collection.
   - **`quit_application()`**: Sends a "quit" command to terminate the data collection process.

3. **Main Functionality:**
   - **Initial Setup**: The script begins by executing the ADXL345 SPI application with a unique filename based on the current date and time. It also changes the permissions of the FIFO file to ensure it is writable.
   - **User Interface**: The script then enters a loop that displays a simple menu allowing the user to start, stop, or quit the application. The user can also exit the interface by choosing the appropriate option.

4. **Execution Flow:**
   - The script starts by recording data to a CSV file with a timestamped filename.
   - It sets file permissions for the FIFO used to send commands.
   - The user interacts with the application through a text-based menu to control data collection.

### Requirements

- The script is designed to be run from the command line.
- Requires appropriate permissions to execute the commands successfully.

## Technical Summary of Modifications to the ADXL345 Driver

### 1. Server-Like Operation - Command Listening and Control

The driver has been restructured to enable it to function as a server, listening for and processing commands via a named pipe (`/tmp/adxl345spi_fifo`). The following key components were added or modified:

- **`listenForCommands()`**: Introduced as a continuous command listener that reads instructions (`start`, `stop`, `quit`) from the named pipe. Based on the received command, it triggers corresponding actions such as initiating data collection, halting it, or shutting down the application.

- **`startDataCollection()` and `stopDataCollection()`**: Implemented as control functions to manage the data collection process. These functions are called within `listenForCommands()` to start or stop the data acquisition thread based on the incoming commands.

### 2. Enhanced Support for Triple Accelerometer Configuration

The driver was expanded to support data acquisition from three ADXL345 accelerometers. The following adjustments were made:

- **`selectChip(uint8_t chip)`**: A new utility function introduced to manually control the Chip Select (CS) lines for the three accelerometers. This function asserts the appropriate CS line (CS0, CS1, or CS2) based on the `chip` parameter, ensuring the correct accelerometer is selected for SPI communication.

- **`dataCollectionThread()`**: Modified to handle concurrent data acquisition from all three accelerometers. The thread iterates through each accelerometer by selecting the corresponding CS line via `selectChip()`, performing SPI communication to read sensor data sequentially from each accelerometer.

- **SPI Interface and GPIO Configuration**: Adjusted to accommodate the three accelerometers. The GPIO pins were configured to support multiple Chip Select lines (CS0, CS1, CS2), ensuring accurate and independent communication with each ADXL345 sensor.
