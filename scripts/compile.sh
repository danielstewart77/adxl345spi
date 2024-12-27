INSTALL_DIR="/opt/redoak"

# Check if adxl345spi executable exists
if [ ! -f "$INSTALL_DIR/adxl345spi" ]; then
    echo "adxl345spi not found, compiling..."
    gcc -I"$INSTALL_DIR" "$INSTALL_DIR/adxl345spi_quad.c" -o "$INSTALL_DIR/adxl345spi" -lpigpio -pthread
    if [ $? -ne 0 ]; then
        echo "Compilation failed. Exiting."
        exit 1
    fi
    echo "adxl345spi compiled successfully"
else
    echo "adxl345spi found."
fi
