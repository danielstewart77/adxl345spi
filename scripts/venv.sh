# Define the installation directory and virtual environment path
INSTALL_DIR="/opt/redoak"
VENV_DIR="$INSTALL_DIR/venv"

echo "Creating a virtual environment..."
# Create a virtual environment
python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip3" install --upgrade pip
"$VENV_DIR/bin/pip3"/bin/pip install -r "$INSTALL_DIR/requirements.txt"
echo "Virtual environment created."