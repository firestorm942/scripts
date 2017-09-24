#!/bin/bash
cd /tmp || exit
echo "checking if python is installed"
if command -v python > /dev/null 2>&1; then
    echo "python installed, resuming"
else
    echo "Installing python"
    sudo apt install -y -qq python
    echo "Install successful"
fi
function Main {
if [ ! -e /usr/bin/speedtest ]
then
    echo "Installing speedtest. Press [Enter] to continue/n or [ctrl+c] to cancel."
    wget -qc https://raw.githubusercontent.com/firestorm942/scripts/master/speedtest
    sudo mv speedtest /usr/bin/speedtest
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
