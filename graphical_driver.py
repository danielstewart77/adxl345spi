import tkinter as tk
from tkinter import messagebox
import subprocess
from datetime import datetime

def execute_command(command):
    try:
        subprocess.Popen(command, shell=True)
    except subprocess.CalledProcessError as e:
        messagebox.showerror("Error", f"Command failed: {e}")

def start_application():
    execute_command(f'echo "start" > /tmp/adxl345spi_fifo')

def stop_application():
    execute_command(f'echo "stop" > /tmp/adxl345spi_fifo')

def quit_application():
    execute_command(f'echo "quit" > /tmp/adxl345spi_fifo')

def main():
    # Step 1: Execute the initial command with the current datetime
    current_datetime = datetime.now().strftime('%Y%m%d_%H%M%S')
    execute_command(f'sudo ./adxl345spi -s {current_datetime}.csv -f 3600')
    
    # Step 2: Change file permissions
    execute_command('sudo chmod 666 /tmp/adxl345spi_fifo')
    
    # Step 3: Set up the graphical interface
    root = tk.Tk()
    root.title("ADXL345 Controller")

    start_button = tk.Button(root, text="Start", command=start_application)
    start_button.pack(pady=10)

    stop_button = tk.Button(root, text="Stop", command=stop_application)
    stop_button.pack(pady=10)

    quit_button = tk.Button(root, text="Quit", command=quit_application)
    quit_button.pack(pady=10)

    root.mainloop()

if __name__ == "__main__":
    main()
