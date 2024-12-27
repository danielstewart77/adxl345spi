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
    packages=(git python3 python3-pip python3-venv python3-flask python3-pyqt5 python3-pyqt5.qtwebengine build-essential python3-dev python3-sip python3-sip-dev qtbase5-dev qttools5-dev-tools libqt5webkit5-dev gcc)
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