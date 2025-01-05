#!/bin/bash

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

# Check the repository version of Python3
python_version=$(python3 --version 2>&1 | awk '{print $2}')
python_major=$(echo $python_version | cut -d. -f1)
python_minor=$(echo $python_version | cut -d. -f2)

# Function to manually install a newer Python version
install_new_python() {
    echo "Installing Python 3.9+ manually..."
    sudo apt update
    sudo apt install -y build-essential libssl-dev zlib1g-dev libncurses5-dev \
        libgdbm-dev libnss3-dev libreadline-dev libffi-dev curl libbz2-dev

    # Download and compile Python source
    python_version_to_install="3.9.9"
    curl -O https://www.python.org/ftp/python/$python_version_to_install/Python-$python_version_to_install.tgz
    tar -xvf Python-$python_version_to_install.tgz
    cd Python-$python_version_to_install || exit
    ./configure --enable-optimizations
    make -j$(nproc)
    sudo make altinstall

    # Verify installation
    if command -v python3.9 >/dev/null 2>&1; then
        echo "Python 3.9+ installed successfully."
    else
        echo "Failed to install Python 3.9+. Exiting."
        exit 1
    fi
    cd ..
    rm -rf Python-$python_version_to_install Python-$python_version_to_install.tgz
}

# Check Python version and decide whether to install a newer version
if [ "$python_major" -lt 3 ] || { [ "$python_major" -eq 3 ] && [ "$python_minor" -lt 9 ]; }; then
    echo "Python version is $python_version, which is less than 3.9. Installing a newer version..."
    install_new_python
else
    echo "Python version is $python_version, which meets the requirement. Proceeding with package installation..."
fi

# Check if required packages are installed
install_packages() {
    packages=(
        pigpio libpigpio-dev 
        git 
        python3 python3-pip python3-venv 
        build-essential gcc
        python3-dev
        qt5-qmake qt5-default qtbase5-dev qttools5-dev-tools
        qtquickcontrols2-5-dev qtdeclarative5-dev libqt5svg5-dev
        )

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

echo "All required system packages are installed."
