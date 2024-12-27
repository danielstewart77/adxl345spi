#!/bin/bash
echo "Uninstalling RedOak..."
sudo systemctl stop redoak.service
sudo systemctl disable redoak.service
sudo rm -f /usr/share/applications/redoak.desktop
sudo rm -f /etc/systemd/system/redoak.service
sudo rm -f -r /opt/redoak
sudo rm -f /usr/local/bin/redoak-launcher
echo "RedOak has been uninstalled."