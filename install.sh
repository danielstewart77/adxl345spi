#!/bin/bash

INSTALL_DIR="/opt/redoak"

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

echo "Removing any existing installations..."
# Remove the installation directory if it exists
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing old installation..."
    sudo rm -r "$INSTALL_DIR"
    echo "Old installation removed."
fi
sudo rm -f /usr/share/applications/redoak.desktop
sudo rm -f /usr/local/bin/redoak-launcher
echo "Finished cleaning up. Proceeding with installation."

# Create the installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

# give the user ownership of the installation directory
sudo chown -R $USER:$USER "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Clone the Git repository
echo "Cloning the adxl345spi repo"
git clone --branch pywebview https://github.com/danielstewart77/adxl345spi "$INSTALL_DIR"
echo "adxl345spi cloned to $INSTALL_DIR"

# Get the current swap size in MB (ensure the output is a number)
current_swap_size=$(free --mega | awk '/Swap:/ {print $2}')

# Validate the value of current_swap_size
if [ -z "$current_swap_size" ] || ! [[ "$current_swap_size" =~ ^[0-9]+$ ]]; then
    echo "Failed to determine the current swap size. Setting to 0MB."
    current_swap_size=0
fi

# If the swap size is less than 2048MB (2GB), call the swap.sh script
if [ "$current_swap_size" -lt 2048 ]; then
    echo "Current swap size is ${current_swap_size}MB. Adding a 2GB swap file..."
    sh "$INSTALL_DIR/scripts/swap.sh"
else
    echo "Current swap size is ${current_swap_size}MB, which is sufficient."
fi

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# install packages
sudo bash "$INSTALL_DIR/scripts/package.sh"

# Compile the C program
sh "$INSTALL_DIR/scripts/compile.sh"

# Make the Python script executable
chmod +x "$INSTALL_DIR/web.py"

# Create the virtual environment
sh "$INSTALL_DIR/scripts/venv.sh"

# Create a launcher, updater, and uninstaller scripts
sh "$INSTALL_DIR/scripts/launcher.sh"

# Create a systemd service
sh "$INSTALL_DIR/scripts/service.sh"

# Add shortcuts to Raspberry Pi OS Accessories
sh "$INSTALL_DIR/scripts/shortcut.sh"

# Disable hardware acceleration globally for GTK
export LIBGL_ALWAYS_SOFTWARE=1

echo "Installation complete."
echo "Shortcuts for launcher, update and uninstall are located in the Accessories menu."
