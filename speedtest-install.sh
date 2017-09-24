#!/bin/sh
echo "checking if python is installed"
if command -v python > /dev/null 2>&1; then
    echo "python installed, resuming"
    Main
else
    echo "Installing python"
    sudo apt install -y -qq python
    echo "Install successful"
    Main
fi
function Main {
if [ -e /usr/bin/speedtest ]
then
read -p "<Do you wish to remove speedtest?> : y/N" CONDITION;
if [ "$CONDITION" == "y" ];
then
    echo "Starting PaperSpigot..."
    sleep 3
    sudo rm -rf /usr/bin/speedtest
    echo "Speedtest removed successfully!"
else
    read -p "<Do you wish to install speedtest?> : y/N" CONDITION;
    if [ "$CONDITION" == "y" ]; then
    wget -qc https://raw.githubusercontent.com/firestorm942/scripts/master/speedtest
    sudo mv speedtest /usr/bin/speedtest
    echo "Speedtest installed successfully!"
fi
fi
fi
}
