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

def start_application():
    init()
    """Sends a start command to the ADXL345 FIFO."""
    execute_command('echo "start" > ./adxl345spi_fifo')

def stop_application():
    """Sends a stop command to the ADXL345 FIFO."""
    execute_command('echo "stop" > ./adxl345spi_fifo')

def quit_application():
    """Sends a quit command to the ADXL345 FIFO."""
    execute_command('echo "quit" > ./adxl345spi_fifo')

def handle_choice(choice):
    """Handles user input choices."""
    if choice == '1':
        print("Starting application...")
        start_application()
    elif choice == '2':
        print("Stopping application...")
        stop_application()
    elif choice == '3':
        print("Exiting program.")
        quit_application()
        exit(0)
    else:
        print("Invalid choice. Please try again.")

def get_user_input():
    """Continuously prompts the user for input in a separate thread."""
    while True:
        print("ADXL345 Controller")
        print("1. Start")
        print("2. Stop")
        print("3. Exit Application")
        choice = input("Enter your choice: ")
        handle_choice(choice)

def init():
    """Main function to initialize the ADXL345 and start the input thread."""
    current_datetime = datetime.now().strftime('%Y%m%d_%H%M%S')
    print(f"Initializing ADXL345 with timestamp {current_datetime}")

    # Start the ADXL345 process asynchronously
    subprocess.Popen(f'sudo ./adxl345spi -s {current_datetime}.csv -f 3200 &', shell=True)

    # Wait for one second to allow the named pipe to be created
    time.sleep(1)

    # Change file permissions
    execute_command('sudo chmod 666 adxl345spi_fifo')

    # Start the input thread to handle user interaction
    #input_thread = threading.Thread(target=get_user_input, daemon=True)
    #input_thread.start()

    # Keep the main thread alive
    #input_thread.join()

if __name__ == "__main__":
    main()
