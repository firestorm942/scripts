#!/bin/bash
cd /tmp || exit
if command -v python > /dev/null 2>&1; then
    echo ""
else
    echo "Installing python"
    sudo apt install -y -qq python
    echo "Install successful"
fi
function Main {
if [ ! -e /usr/bin/speedtest ]
then
    echo "Installing speedtest."
    read -rsp $"Press Enter to Continue...[Ctrl+C] To Cancel"
    wget -qc https://raw.githubusercontent.com/firestorm942/scripts/master/speedtest
    sudo mv speedtest /usr/bin/speedtest
    echo ""
    echo "Speedtest installed successfully!"
    else
    read -p "<Do you wish to remove speedtest?> : y/N" CONDITION;
    if [ "$CONDITION" == "y" ];
    then
    sudo rm -rf /usr/bin/speedtest
    echo "Speedtest removed successfully!"
    else
    exit
fi
fi
}
Main
