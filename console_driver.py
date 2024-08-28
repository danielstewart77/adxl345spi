import subprocess
from datetime import datetime

def execute_command(command):
    try:
        subprocess.Popen(command, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"Error: Command failed: {e}")

def start_application():
    execute_command('echo "start" > /tmp/adxl345spi_fifo')

def stop_application():
    execute_command('echo "stop" > /tmp/adxl345spi_fifo')

def quit_application():
    execute_command('echo "quit" > /tmp/adxl345spi_fifo')

def main():
    # Step 1: Execute the initial command with the current datetime
    current_datetime = datetime.now().strftime('%Y%m%d_%H%M%S')
    execute_command(f'sudo ./adxl345spi -s {current_datetime}.csv -f 3200')

    # Step 2: Change file permissions
    execute_command('sudo chmod 666 /tmp/adxl345spi_fifo')

    # Step 3: Console interface for user interaction
    while True:
        print("ADXL345 Controller")
        print("1. Start")
        print("2. Stop")
        print("3. Quit")
        print("4. Exit Application")
        choice = input("Enter your choice: ")

        if choice == '1':
            start_application()
        elif choice == '2':
            stop_application()
        elif choice == '3':
            quit_application()
        elif choice == '4':
            quit_application()
            print("Exiting application.")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()
