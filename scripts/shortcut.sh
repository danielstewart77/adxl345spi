# Add shortcut to Raspberry Pi OS Accessories
MENU_DIR="/usr/share/applications"
SHORTCUT_FILE="$MENU_DIR/redoak_launcher.desktop"

cat <<EOF > "$SHORTCUT_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=RedOak Launcher
Comment=Launch RedOak application
Exec=/usr/local/bin/redoak-launcher
Icon=/opt/redoak/static/icon.png
Terminal=false
Categories=Utility;
EOF

# Ensure proper permissions
chmod +x "$SHORTCUT_FILE"

echo "Launcher shortcut added to accessories."

chmod +x "$SHORTCUT_FILE"
echo "Uninstaller shortcut added to accessories."

# Add shortcut to Raspberry Pi OS Accessories
MENU_DIR="/usr/share/applications"
SHORTCUT_FILE="$MENU_DIR/redoak_updater.desktop"

cat <<EOF > "$SHORTCUT_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=RedOak Updater
Comment=Launch RedOak application
Exec=/usr/local/bin/redoak-updater
Icon=/opt/redoak/static/icon.png
Terminal=false
Categories=Utility;
EOF

chmod +x "$SHORTCUT_FILE"
echo "Updater shortcut added to accessories."

# Add shortcut to Raspberry Pi OS Accessories
echo "Adding RedOak uninstaller shortcut to accessories..."
MENU_DIR="/usr/share/applications"
SHORTCUT_FILE="$MENU_DIR/redoak_uninstaller.desktop"

cat <<EOF > "$SHORTCUT_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=RedOak Uninstaller
Comment=Launch RedOak application
Exec=/usr/local/bin/redoak-uninstaller
Icon=/opt/redoak/static/icon.png
Terminal=false
Categories=Utility;
EOF