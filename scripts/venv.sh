#!/bin/bash

# Define the installation directory and virtual environment path
INSTALL_DIR="/opt/redoak"
VENV_DIR="$INSTALL_DIR/venv"

# Check the Python version
python_version=$(python3 --version 2>&1 | awk '{print $2}')
python_major=$(echo $python_version | cut -d. -f1)
python_minor=$(echo $python_version | cut -d. -f2)

# Verify Python version
if [ "$python_major" -lt 3 ] || { [ "$python_major" -eq 3 ] && [ "$python_minor" -lt 9 ]; }; then
    echo "Error: Python 3.9 or higher is required. Current version is $python_version."
    exit 1
fi

# Create the virtual environment
echo "Creating a virtual environment with Python $python_version..."
python3 -m venv "$VENV_DIR"

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Upgrade pip and install dependencies
pip3 install --upgrade pip
pip3 install -r "$INSTALL_DIR/requirements.txt"

echo "Virtual environment created successfully with Python $python_version."
