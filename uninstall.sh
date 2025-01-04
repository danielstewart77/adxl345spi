#!/bin/bash
echo "Uninstalling RedOak..."
sudo rm -f -r /opt/redoak
sudo rm -f /usr/local/bin/redoak-launcher
sudo rm -f /usr/share/applications/redoak_launcher.desktop
sudo rm -f /usr/local/bin/redoak-updater
sudo rm -f /usr/share/applications/redoak_updater.desktop
sudo rm -f /usr/local/bin/redoak-uninstaller
sudo rm -f /usr/share/applications/redoak_uninstaller.desktop
echo "RedOak has been uninstalled."