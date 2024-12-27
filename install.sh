#!/bin/bash

INSTALL_DIR="/opt/redoak"

# Remove the installation directory if it exists
if [ -d "$INSTALL_DIR" ]; then
    echo "Removing old installation..."
    sudo rm -r "$INSTALL_DIR"
    echo "Old installation removed."
fi

# Create the installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

# give the user ownership of the installation directory
sudo chown -R $USER:$USER "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Clone the Git repository
echo "Cloning the adxl345spi repo"
git clone https://github.com/danielstewart77/adxl345spi "$INSTALL_DIR"
echo "adxl345spi cloned to $INSTALL_DIR"

# first, remove old installations
sh "$INSTALL_DIR/scripts/rm_old_inst.sh"

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

echo "Installation complete."
echo "Shortcuts for launcher, update and uninstall are located in the Accessories menu."
