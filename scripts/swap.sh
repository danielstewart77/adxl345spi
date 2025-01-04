#!/bin/bash

echo "Creating a 2GB swap file..."

# Turn off existing swap
sudo swapoff -a

# Create a new 2GB swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 status=progress
sudo chmod 600 /swapfile
sudo mkswap /swapfile

# Enable the new swap file
sudo swapon /swapfile

# Update /etc/fstab to make it permanent
if ! grep -q '/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

echo "2GB swap file created and enabled."
