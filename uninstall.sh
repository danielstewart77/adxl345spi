#!/bin/bash
echo "Uninstalling RedOak..."
sudo systemctl stop redoak.service
sudo systemctl disable redoak.service
sudo rm -f /etc/systemd/system/redoak.service
sudo rm -f -r /opt/redoak
sudo rm -f /usr/local/bin/redoak-launcher
sudo rm -f /usr/share/applications/redoak_launcher.desktop
sudo rm -f /usr/local/bin/redoak-updater
sudo rm -f /usr/share/applications/redoak_updater.desktop
sudo rm -f /usr/local/bin/redoak-uninstaller
sudo rm -f /usr/share/applications/redoak_uninstaller.desktop
echo "RedOak has been uninstalled."