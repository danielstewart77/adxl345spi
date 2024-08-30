# diagram for CS pins
![image](https://github.com/user-attachments/assets/0f07b8ea-7062-4f55-98ac-bffe4ab504de)

# install python (if not already installed)
`sudo apt-get install python3`

# clone repo:
`git clone https://github.com/danielstewart77/adxl345spi.git`

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

## Summary of Changes to adxl345 driver

### 1. Operating Like a Server - Listening for Commands
The code has been modified to allow the application to operate like a server, listening for commands via a named pipe (`/tmp/adxl345spi_fifo`). The following functions were introduced or modified:

- **`listenForCommands()`**: A new function added to continuously listen for commands (`start`, `stop`, `quit`) from the named pipe. Based on the command received, the data collection is either started, stopped, or the application is terminated.
- **`startDataCollection()` and `stopDataCollection()`**: Functions added to control the starting and stopping of the data collection thread. These are invoked based on the commands received in `listenForCommands()`.

### 2. Adding Support for 3 Accelerometers
The code was extended to support three ADXL345 accelerometers. The following modifications were made:

- **`selectChip()`**: A helper function to manually control the Chip Select (CS) lines of the three accelerometers. It sets the appropriate CS pin low for the selected accelerometer.
- **`dataCollectionThread()`**: The thread function was modified to read data from three accelerometers. It reads data from each accelerometer by selecting the corresponding CS pin and performs SPI communication.
- **SPI Initialization**: The SPI interface and GPIO pins were configured to handle three accelerometers (CS0, CS1, and CS2).

