# Add this to your install script to configure a 1GB swap size

echo "Configuring a 1GB swap file..."

# Turn off any existing swap
sudo dphys-swapfile swapoff

# Update the swap file configuration to set 1GB
sudo sed -i 's/^CONF_SWAPSIZE=.*/CONF_SWAPSIZE=1024/' /etc/dphys-swapfile

# Reinitialize the swap file with the new size
sudo dphys-swapfile setup

# Turn on the swap file
sudo dphys-swapfile swapon

# Verify the swap size
echo "Swap configuration updated. Current swap status:"
sudo swapon --show

echo "1GB swap size configured successfully."
