#!/bin/bash
echo "Updating RedOak..."
cd /opt/redoak
sudo git pull origin master
# Here you might want to include commands to recompile or reinstall dependencies if necessary
echo "RedOak has been updated."