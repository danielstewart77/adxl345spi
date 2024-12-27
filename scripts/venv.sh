# Define the installation directory and virtual environment path
INSTALL_DIR="/opt/redoak"
VENV_DIR="$INSTALL_DIR/venv"

echo "Creating a virtual environment..."
# Create a virtual environment
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install -r "$INSTALL_DIR/requirements.txt"
deactivate
echo "Virtual environment created."