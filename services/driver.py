import time
import subprocess
import threading
from datetime import datetime

def execute_command(command):
    """Executes a command using subprocess.run."""
    try:
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error: Command failed: {e}")

def start_application(freq:int = 3200):
    init(freq)
    """Sends a start command to the ADXL345 FIFO."""
    execute_command('echo "start" > ./adxl345spi_fifo')

def stop_application():
    """Sends a stop command to the ADXL345 FIFO."""
    execute_command('echo "stop" > ./adxl345spi_fifo')

def quit_application():
    """Sends a quit command to the ADXL345 FIFO."""
    execute_command('echo "quit" > ./adxl345spi_fifo')

def init(freq:int = 3200):
    """Main function to initialize the ADXL345 and start the input thread."""
    current_datetime = datetime.now().strftime('%Y%m%d_%H%M%S')
    print(f"Initializing ADXL345 with timestamp {current_datetime}")

    # Start the ADXL345 process asynchronously
    subprocess.Popen(f'sudo ./adxl345spi -s {current_datetime}.csv -f {freq} &', shell=True)

    # Wait for one second to allow the named pipe to be created
    time.sleep(1)

    # Change file permissions
    execute_command('sudo chmod 666 adxl345spi_fifo')