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

# Check if required packages are installed
install_packages() {
    packages=(git python3 python3-pip python3-flask python3-pyqt5 python3-pyqt5.qtwebengine build-essential python3-dev python3-sip python3-sip-dev qtbase5-dev qttools5-dev-tools libqt5webkit5-dev gcc)
    for pkg in "${packages[@]}"; do
        if ! dpkg -l | grep -qw "$pkg"; then
            echo "$pkg is not installed. Attempting to install..."
            sudo apt update
            sudo apt install -y "$pkg" || {
                echo "Retrying with fix-broken for $pkg..."
                sudo apt --fix-broken install -y
                sudo apt install -y "$pkg" || {
                    echo "Failed to install $pkg even after fix-broken. Exiting."
                    exit 1
                }
            }
        else
            echo "$pkg is already installed."
        fi
    done
}

# Run package installation
install_packages

# Define the installation directory and virtual environment path
INSTALL_DIR="/opt/redoak"
VENV_DIR="$INSTALL_DIR/venv"

# Create the installation directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
fi

# Clone the Git repository
echo "Cloning the adxl345spi repo"
git clone https://github.com/danielstewart77/adxl345spi "$INSTALL_DIR"
echo "adxl345spi cloned to " + $INSTALL_DIR

# Create a virtual environment
echo "Creating virtual environment..."
python3 -m venv "$VENV_DIR"

# Activate the virtual environment and install dependencies
echo "Installing Python dependencies in the virtual environment..."
"$VENV_DIR/bin/pip" install --upgrade pip setuptools
if [ -f "$INSTALL_DIR/requirements.txt" ]; then
    "$VENV_DIR/bin/pip" install -r "$INSTALL_DIR/requirements.txt"
fi

# Check if adxl345spi executable exists
if [ ! -f "$INSTALL_DIR/adxl345spi" ]; then
    echo "adxl345spi not found, compiling..."
    gcc "$INSTALL_DIR/adxl345spi_quad.c" -o "$INSTALL_DIR/adxl345spi" -lpigpio -pthread
    if [ $? -ne 0 ]; then
        echo "Compilation failed. Exiting."
        exit 1
    fi
else
    echo "adxl345spi found."
fi

# Make the Python script executable
chmod +x "$INSTALL_DIR/web.py"

# Create a launcher script
cat <<EOF > /usr/local/bin/redoak-launcher
#!/bin/bash
"$VENV_DIR/bin/python" "$INSTALL_DIR/app/web.py"
EOF
chmod +x /usr/local/bin/redoak-launcher

# Configure system startup
cat <<EOF > /etc/systemd/system/redoak.service
[Unit]
Description=RedOak Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/redoak-launcher
Restart=always

[Install]
WantedBy=default.target
EOF

# Enable and start the systemd service
systemctl enable redoak.service
systemctl start redoak.service

# Add shortcut to Raspberry Pi OS taskbar
echo "Adding RedOak shortcut to Raspberry Pi taskbar..."
MENU_DIR="/usr/share/applications"
SHORTCUT_FILE="$MENU_DIR/redoak.desktop"

cat <<EOF > "$SHORTCUT_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=RedOak
Comment=Launch RedOak application
Exec=/usr/local/bin/redoak-launcher
Icon=utilities-terminal
Terminal=false
Categories=Utility;
EOF

# Ensure proper permissions
chmod +x "$SHORTCUT_FILE"
echo "Shortcut added to taskbar successfully."

echo "Installation complete. RedOak is ready to use."
