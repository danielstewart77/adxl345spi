# Create a launcher script
INSTALL_DIR="/opt/redoak"
VENV_DIR="$INSTALL_DIR/venv"

cat <<EOF > /usr/local/bin/redoak-launcher
#!/bin/bash
echo "launching Redoak app"
"$VENV_DIR/bin/python3" "$INSTALL_DIR/web.py"
EOF
chmod +x /usr/local/bin/redoak-launcher
echo created launcher script

# Create an updater script
cat <<EOF > /usr/local/bin/redoak-updater
#!/bin/bash
echo "launching RedOak updater"
sh "$INSTALL_DIR/update.sh"
EOF
chmod +x /usr/local/bin/redoak-updater
echo created updater script

# Create an uninstaller script
cat <<EOF > /usr/local/bin/redoak-uninstaller
#!/bin/bash
echo "launching RedOak uninstaller"
sh "$INSTALL_DIR/uninstall.sh"
EOF
chmod +x /usr/local/bin/redoak-uninstaller
echo created uninstaller script