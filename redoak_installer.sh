#!/bin/bash

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure no other apt processes are running with a timeout
timeout=30  # 30 seconds timeout
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Waiting for other apt processes to finish..."
    sleep 2
    timeout=$((timeout - 2))
    if [ $timeout -le 0 ]; then
        echo "Timeout reached while waiting for apt lock. Exiting."
        exit 1
    fi
done


# Check if GCC is installed
if ! command_exists gcc; then
    echo "GCC not found. Installing..."
    sudo apt update && sudo apt install -y gcc
    if [ $? -ne 0 ]; then
        echo "Failed to install GCC. Exiting."
        exit 1
    fi
else
    echo "GCC is already installed."
fi

# Check if Python is installed
if ! command_exists python3; then
    echo "Python3 not found. Installing..."
    sudo apt update && sudo apt install -y python3
    if [ $? -ne 0 ]; then
        echo "Failed to install Python3. Exiting."
        exit 1
    fi
else
    echo "Python3 is already installed."
fi

# Check if adxl345spi executable exists
if [ ! -f "adxl345spi" ]; then
    echo "adxl345spi not found, compiling..."
    gcc adxl345spi_quad.c -o adxl345spi -lpigpio -pthread
    if [ $? -ne 0 ]; then
        echo "Compilation failed. Exiting."
        exit 1
    fi
else
    echo "adxl345spi found."
fi

# Start the Python application
echo "Installed successfully!"
#python3 console_driver.py
