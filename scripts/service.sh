# Configure system startup
cat <<EOF > /etc/systemd/system/redoak.service
[Unit]
Description=RedOak Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/redoak-launcher
Restart=always

[Install]
WantedBy=default.target
EOF

# Enable and start the systemd service
systemctl enable redoak.service
systemctl start redoak.service

cat "Created systemd service for RedOak."