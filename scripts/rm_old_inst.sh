echo "Removing any existing installations..."
sudo rm -f /usr/share/applications/redoak.desktop
sudo rm -f /etc/systemd/system/redoak.service
sudo systemctl disable redoak.service
sudo systemctl stop redoak.service
sudo systemctl daemon-reload

sudo rm -f /usr/local/bin/redoak-launcher
echo "Finished cleaning up. Proceeding with installation."