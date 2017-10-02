#!/usr/bin/env bash
#----------------------------------#
#     SERVER INSTALL FUNCTION      #
#----------------------------------#
function ServerInstall {
echo -ne "Looking for Server File"
dots
if [ -e /home/"$(whoami)"/Minecraft_Server/bin/minecraft_server.1.12.2.jar ]
then
	echo -ne "Server Files already installed!"
	dots
	Main
else
echo "not found!"
fi
echo ""
echo -ne "Creating Server Directory"
dots
mkdir /home/"$(whoami)"/Minecraft_Server
cd /home/"$(whoami)"/Minecraft_Server
echo -ne "    Accepting eula!!!"
echo "eula=true" >> eula.txt
mkdir bin
cd bin
echo ""

file="minecraft_server.1.12.2.jar"
echo -ne "Downloading $file:"
download "https://s3.amazonaws.com/Minecraft.Download/versions/1.12.2/$file"

file="minecraft-icon.png"
echo -ne "Downloading $file:"
download "http://icons.iconarchive.com/icons/chrisbanks2/cold-fusion-hd/64/$file"
mv minecraft-icon.png server_icon.png

echo ""
echo -ne "Writing Shell Launcher"
dots
if [ -e minecraft_server ]
then
    rm mincraft_server
fi
if [ -e mcserver ]
then
    rm mcserver
fi
touch mcserver
 echo "cd /home/$(whoami)/Minecraft_Server" >> mcserver
 echo "pwd" >> mcserver
 echo "java -Xmx2G -Xms1G -jar bin/minecraft_server.1.12.2.jar nogui" >> mcserver
echo -ne  "Copying to bin folder"
dots
echo "This may require root access:"
sudo cp mcserver /usr/local/bin
sudo chmod +x /usr/local/bin/mcserver
echo "done"
echo ""

echo -ne "Creating launchers"
dots

mkdir install_files
cd install_files

if [ -e minecraft-server_installer.desktop ] || [ -e minecraft-menu.directory ]
then
    rm minecraft-server_installer.desktop
    rm minecraft-menu.directory
fi
touch minecraft-server_installer.desktop
  echo "[Desktop Entry]" >> minecraft-server_installer.desktop
  echo "Type=Application" >> minecraft-server_installer.desktop
  echo "Encoding=UTF-8" >> minecraft-server_installer.desktop
  echo "Name=Minecraft Server" >> minecraft-server_installer.desktop
  echo "Comment=Server GUI" >> minecraft-server_installer.desktop
  echo "Exec=mcserver" >> minecraft-server_installer.desktop
  echo "Icon=/home/$(whoami)/Minecraft_Server/bin/server_icon.png" >> minecraft-server_installer.desktop
  echo "Categories=Game" >> minecraft-server_installer.desktop
  echo "Terminal=true" >> minecraft-server_installer.desktop
#----------------------------------------------------
echo -ne "Granting the shortcut excecution permissions"
dots
echo this requires root access
cp minecraft-server_installer.desktop /home/"$(whoami)"/Desktop
sudo chmod +x /home/"$(whoami)"/Desktop/minecraft-server_installer.desktop
echo "done"
echo ""

echo -ne "Writing menu item"
dots
touch minecraft-menu.directory
  echo "[Desktop Entry]" >> minecraft-menu.directory
  echo "Value=1.0" >> minecraft-menu.directory
  echo "Type=Directory" >> minecraft-menu.directory
  echo "Encoding=UTF-8" >> minecraft-menu.directory

echo -ne "Installing server launchers"
dots
xdg-desktop-menu install minecraft-menu.directory minecraft-server_installer.desktop
xdg-desktop-menu forceupdate
echo "done"
echo ""
echo  -e "The Minecraft server has been installed! \nrun it from the launchers, or by typing 'mcserver' into terminal"


## END SERVER INSTALL
}

#----------------------------------#
#    SERVER UNINSTALL FUNCTION     #
#----------------------------------#
function ServerUninstall {
if [ ! -d /home/"$(whoami)"/Minecraft_Server ]
then
    echo Server is not installed!
    return
fi
cd /home/"$(whoami)"/Minecraft_Server/bin/install_files
echo -ne "Removing Launchers"
dots
xdg-desktop-menu uninstall minecraft-menu.directory minecraft-server_installer.desktop
echo "done"
echo ""
echo -ne "Removing Desktop Icon"
dots
cd /home/"$(whoami)"/Desktop
if [ -e minecraft-server_installer.desktop ]
then
    rm minecraft-server_installer.desktop
    echo "done"
else
    echo "Does not exist"
fi
echo ""
echo -ne "Removing Server"
dots
if [ -d /home/"$(whoami)"/Minecraft_Server/bin ]
then
    cd /home/"$(whoami)"/Minecraft_Server
    rm -rf bin
    echo "done"
fi
echo ""
echo -ne "Removing launch script"
dots
echo "this requires root access"
sudo rm /usr/local/bin/mcserver
echo "done"

echo "Uninstall Successful"
}
