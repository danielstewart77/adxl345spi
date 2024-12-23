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