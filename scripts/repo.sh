# Clone the Git repository
echo "Cloning the adxl345spi repo"
git clone https://github.com/danielstewart77/adxl345spi "$INSTALL_DIR"
echo "adxl345spi cloned to $INSTALL_DIR"

# Check if adxl345spi executable exists
if [ ! -f "$INSTALL_DIR/adxl345spi" ]; then
    echo "adxl345spi not found, compiling..."
    gcc "$INSTALL_DIR/adxl345spi_quad.c" -o "$INSTALL_DIR/adxl345spi" -lpigpio -pthread
    if [ $? -ne 0 ]; then
        echo "Compilation failed. Exiting."
        exit 1
    fi
    echo "adxl345spi compiled successfully"
else
    echo "adxl345spi found."
fi

# Make the Python script executable
chmod +x "$INSTALL_DIR/web.py"