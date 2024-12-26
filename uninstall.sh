sudo dpkg -r redoak-installer
sudo dpkg --purge redoak-installer
sudo rm -f /usr/share/applications/redoak.desktop
sudo rm -f /etc/systemd/system/redoak.service
sudo systemctl disable redoak.service
sudo systemctl stop redoak.service
sudo systemctl daemon-reload
rm -f /usr/local/bin/redoak-launcher