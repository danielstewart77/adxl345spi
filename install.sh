#!/bin/bash

# first, remove old installations
sh "$INSTALL_DIR/scripts/rm_old_inst.sh"

# Helper function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# install packages
sh "$INSTALL_DIR/scripts/package.sh"

# Create the installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

# Clone the Git repository
sh "$INSTALL_DIR/scripts/repo.sh"

# give the user ownership of the installation directory
sudo chown -R $USER:$USER "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Create the virtual environment
sh "$INSTALL_DIR/scripts/venv.sh"

# Create a launcher, updater, and uninstaller scripts
sh "$INSTALL_DIR/scripts/launcher.sh"

# Create a systemd service
sh "$INSTALL_DIR/scripts/service.sh"

# Add shortcuts to Raspberry Pi OS Accessories
sh "$INSTALL_DIR/scripts/shortcut.sh"

echo "Installation complete. RedOak is ready to use. Shortcuts for uninstall and update scripts have been placed at /opt/redoak/."