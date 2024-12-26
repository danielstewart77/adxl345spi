sudo dpkg -r redoak-launcher
sudo dpkg --purge redoak-launcher
sudo rm -f /usr/share/applications/redoak.desktop
sudo rm -f /etc/systemd/system/redoak.service
sudo systemctl disable redoak.service
sudo systemctl stop redoak.service
sudo systemctl daemon-reload
sudo rm -f -r /opt/redoak
sudo rm -f /usr/local/bin/redoak-launcher