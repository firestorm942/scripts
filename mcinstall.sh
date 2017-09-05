#!/bin/bash


#Minecraft Installer:

# feel free to change, update, improve, and release this script

# This script, in no way, is directly distributing any protected minecraft files
# all files are open. Don't worry, you won't be
# breaking the "one big rule"

# happy mining!

# latest update 09/05/2017


echo ""
echo "@-------------------------------------------@"
echo "@  firestorm942s Bash Minecraft Installer   @"
echo "@                                           @"
echo "@                                           @"
echo "@   Please feel free to improve             @"
echo "@     this script however you desire.       @"
echo "@                                           @"
echo "@         feedback is awesome               @"
echo "@-------------------------------------------@"

counter=1

#----------------------------------#
#           DOTS FUNCTION          #
#----------------------------------#
# this function simply prints three dots. It waits .1 seconds between each dot
function dots {
while [ $counter -le 3 ]
do
echo -ne "."
sleep .1
((counter++))
done
let counter=1
echo
}
## END DOTS
#----------------------------------#
#       DOWNLOAD FUNCTION          #
#----------------------------------#
# Download function
download()
{
    local url=$1
    echo -n "    "
    wget -c --progress=dot "$url" 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}
## END DOWNLOAD FUCTION
#----------------------------------#
#         INSTALL FUNCTION         #
#----------------------------------#
# This is the main install function, here all the files are downloaded/created and installed
function Install {
# the first thing it does is check to see if the .minecraft folder already exists
# if so, then we don't need to create a new one, if not, we do.
if [ -e /home/"$(whoami)"/.minecraft ]
then
	echo  ".minecraft folder exists"
	if [ -e /home/"$(whoami)"/.minecraft/Minecraft.jar ]
	then
		echo  -ne "have you run this before?"
		dots

	fi
	echo ""
else
echo -ne "creating /home/$(whoami)/.minecraft"
dots
cd /home/"$(whoami)"
mkdir .minecraft
fi




#--------------------------------------------
cd /home/"$(whoami)"/.minecraft
#--------------------------------------------
# after the .minecraft folder is created, the script checks for Sun-Java
# by checking to see if the installation folder is present, if so, then
# it will not download it, however it will still make sure that sun-java
# is default, just in case openjdk is already installed
echo -ne "looking for oracle java."
dots
if [ -e /usr/lib/jvm/java-8-oracle ]
then
	if [ -e /usr/lib/jvm/java-8-oracle/bin ]
	then
		if [ -e /usr/lib/jvm/java-8-oracle/bin/java ]
		then
		echo "oracle-8-Java is already Installed!"
		#echo -ne "We need to make sure that it is the default Java installation"
		#dots
		#echo "Don't worry if you see lots of errors"
		#echo "this requires root access"
		# setting the default java creates alot of unneeded text, therefore it is done
		# in a new terminal window, because people dont' really need to see it
		#sudo xterm -e update-java-alternatives -s java-8-oracle
		#echo "Oracle Java set as Default."
		fi
	fi
echo ""
else
echo -ne "you'll need to install java"
dots
echo "this will require root access!"
echo "prepare for lots of text!"
echo "Adding java repo..."
sudo add-apt-repository ppa:webupd8team/java
echo "Updating apt-get cache."
sudo xterm -e apt-get update
echo "Installing java."
sudo apt-get install oracle-java8-installer
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo xterm -e update-java-alternatives -s java-8-oracle
echo ""
echo ""
echo ""
echo " JAVA INSTALL SUCCESSFUL!"
echo "------------------------------------"
echo ""
echo ""
echo ""

fi

#--------------------------------------------
# the .jar file is simply downloaded to the .minecraft folder from minecraft.net
# it first checks to see if the user already has it, if so, it won't be downloaded
echo -ne downloading Minecraft.jar
dots
if [ -e /home/"$(whoami)"/.minecraft/Minecraft.jar ]
then
echo "looks like you already downloaded it!"
else
file="Minecraft.jar"
echo -n "Downloading $file:"
download "https://s3.amazonaws.com/Minecraft.Download/launcher/$file"
fi
echo""
echo -ne "downloading icon"
dots
if [ -e /home/"$(whoami)"/.minecraft/icon.png ]
then
echo "you already have the icon!"
else
file="minecraft-icon.png"
echo -n "Downloading $file:"
download "http://icons.iconarchive.com/icons/chrisbanks2/cold-fusion-hd/64/$file"
mv minecraft-icon.png icon.png
echo saved to /home/"$(whoami)"/.minecraft
fi
echo ""
#---------------------------------------------
echo -ne "writing bin shell"
# this writes a seperate shell script in the /usr/local/bin folder, this is what allows the user
# to run minecraft from terminal, just by typing minecraft.
dots
if [ ! -e /usr/local/bin/minecraft ]
then
touch minecraft
echo java -jar /home/"$(whoami)"/.minecraft/Minecraft.jar >> minecraft
echo -ne saving to usr/local/bin
dots
echo this requires root access:
sudo cp minecraft /usr/local/bin/
sudo chmod +x /usr/local/bin/minecraft
echo "done"
else
echo excecutable already written
fi
echo ""
#--------------------------------------------
echo -ne writing desktop shortcut
dots
cd /home/"$(whoami)"/.minecraft/
if [ -e /home/"$(whoami)"/.minecraft/install_files ]
then
echo -ne previous version detected, updating
dots
rm -rf install_files
fi
mkdir install_files
cd install_files

touch minecraft-installer.desktop
echo "[Desktop Entry]" >> minecraft-installer.desktop
echo "Type=Application" >> minecraft-installer.desktop
echo "Encoding=UTF-8" >> minecraft-installer.desktop
echo "Name=Minecraft" >> minecraft-installer.desktop
echo "Comment=Minecraft Client" >> minecraft-installer.desktop
echo "Exec=java -jar /home/$(whoami)/.minecraft/Minecraft.jar" >> minecraft-installer.desktop
echo "Icon=/home/$(whoami)/.minecraft/icon.png"  >> minecraft-installer.desktop
echo "Categories=Game" >> minecraft-installer.desktop
echo "Terminal=false" >> minecraft-installer.desktop
#----------------------------------------------------
echo -ne granting the shortcut excecution permissions
dots
echo this requires root access
cp minecraft-installer.desktop /home/"$(whoami)"/Desktop
sudo chmod +x /home/"$(whoami)"/Desktop/minecraft-installer.desktop
echo "done"
echo ""
#---------------------------------------------
echo -ne writing menu item
dots
touch minecraft-menu.directory
 echo "[Desktop Entry]" >> minecraft-menu.directory
 echo "Value=1.0" >> minecraft-menu.directory
 echo "Type=Directory" >> minecraft-menu.directory
 echo "Encoding=UTF-8" >> minecraft-menu.directory
echo "done"
echo ""
echo -ne installing to Applications menu
dots
xdg-desktop-menu install minecraft-menu.directory minecraft-installer.desktop
xdg-desktop-menu forceupdate
echo installed
#--------------------------------------------
echo ""
echo "SUCCESS!"
echo ""
echo -e "Minecraft has been successfully Downloaded and Installed \nCheck your desktop and Applications menu for launchers! \nYou can also run it from terminal with a 'minecraft' command! \ncontact: Speed9425@gmail.com"
echo "Happy Mining!"

echo""

}
## END INSTALL

#----------------------------------#
#     SERVER INSTALL FUNCTION      #
#----------------------------------#
function ServerInstall {
echo -ne "Looking for Server File"
dots
if [ -e /home/"$(whoami)"/Minecraft_Server/bin/minecraft_server.1.12.1.jar ]
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

file="minecraft_server.1.12.1.jar"
echo -ne "Downloading $file:"
download "https://s3.amazonaws.com/Minecraft.Download/versions/1.12.1/$file"

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
 echo "java -Xmx2G -Xms1G -jar bin/minecraft_server.1.12.1.jar nogui" >> mcserver
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
#----------------------------------#
#       UNINSTALL FUNCTION         #
#----------------------------------#
function Uninstall {
echo -ne "Looking for Minecraft"
dots
if [ ! -e /home/"$(whoami)"/.minecraft/Minecraft.jar ]
then
	echo -ne "  -folder not detected"
	dots
	if [ ! -e /usr/local/bin/minecraft ]
	then
	echo -ne "  -bin launcher not detected"
	dots
	echo""
	echo "Minecraft doesn't seem to be installed!"
	Main
	return
	fi
fi
echo "Minecraft found!"
echo -ne "Uninstalling Minecraft"
dots
echo "NOTE: You're save files will be kept"
cd /home/"$(whoami)"/.minecraft
echo ""
echo -ne "Deleting files and folders"
dots
rm -rf bin
rm -rf resourcepacks
rm Minecraft.jar
if [ -e options.txt ]
then
	rm options.txt
fi
if [ -e lastlogin ]
then
	rm lastlogin
fi
rm minecraft
rm -rf resources
rm icon.png
cd install_files
echo "Removing Application Launcher"

xdg-desktop-menu uninstall minecraft-menu.directory minecraft-installer.desktop
echo "Removing Desktop Shortcut"
rm /home/"$(whoami)"/Desktop/minecraft-installer.desktop
rm -rf /home/"$(whoami)"/.minecraft/install_files
echo ""
echo -ne "Removing Binary Launcher"
dots
echo "this requires root access:"
sudo rm /usr/local/bin/minecraft
echo ""
echo "Minecraft has been uninstalled :("

}
## END UNINSTALL

#----------------------------------#
#     TROUBLESHOOT FUNCTION        #
#----------------------------------#
function TroubleShoot {
echo ""
echo ""
echo "#----------------------------------#"
echo "#       Troubleshooting Menu       #"
echo "#----------------------------------#"

echo "What would you like to do? (enter number of choice)"; echo "";
echo "1. install/update Oracle-Java8"
echo "2. install/update Oracle-Java8(headless)"
echo "3. install/update OpenJDK8"
echo "4. use oracle-Java to run minecraft from now on"
echo "5. use OpenJDK to run minecraft from now on"
echo "6. these options didn't fix it!"
echo "7. return to the main menu"
TINPUT=0
read TINPUT
if [ "$TINPUT" -eq 1 ]
then
	echo "Attempting to install oracle java 8."
        echo "Adding apt repo(requires root)."
        sudo add-apt-repository ppa:webupd8team/java
        echo "installing...(requires root)"
        sudo apt-get update
        sudo apt-get install oracle-java8-installer
        echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
        echo "installed, thank you :)";
	TroubleShoot
else
if [ "$TINPUT" -eq 2 ]
then
	echo "Attempting to install oracle java 8(headless)."
        echo "installing...(requires root)"
        wget https://www.headhunterz.pw/EasyJavaInstall-Latest.sh -O EasyJavaInstall-Latest.sh --no-certificate-check && chmod +x EasyJavaInstall-Latest.sh && ./EasyJavaInstall-Latest.sh
        echo -e "installed, thank you to headhunterz \nfor the headless installer script! :) \nyou can see his work here:https://www.headhunterz.pw";
	TroubleShoot
else
if [ "$TINPUT" -eq 3 ]
then
	echo -ne "Installing/Updating OpenJDK8"
	dots
	echo "this requires root access:"
        echo "Adding openjdk8 repo to apt"
        sudo add-apt-repository ppa:openjdk-r/ppa
        echo "this requires root access:"
        echo "installing openjdk8"
        sudo apt-get update
	sudo apt-get install openjdk-8-jdk
	echo ""; echo ""; echo; echo "Finished!"; echo "";
	TroubleShoot
else
if [ "$TINPUT" -eq 4 ]
then
	echo -ne "Making Oracle8 the default(working)"
	dots
	echo "Don't worry if you see lots of errors"

	sudo xterm -e update-java-alternatives -s java-8-oracle
	echo ""; echo ""; echo; echo "Finished!"; echo "";
else
if [ "$TINPUT" -eq 5 ]
then
	echo -ne "Making OpenJDK8 the default(untested)"
	dots
	echo "Don't worry if you see lots of errors"

	sudo xterm -e update-java-alternatives -s java-8-openjdk
	echo ""; echo ""; echo; echo "Finished!"; echo "";
else
if [ "$TINPUT" -eq 6 ]
then
echo "-------------------------------------------------"
echo "if these troubleshooting options didn't fix your,"
echo "problem, I'd be glad to help you out! "
echo "Speed9425@gmail.com"
echo "-------------------------------------------------"
Main
else
if [ "$TINPUT" -eq 7 ]
then
Main
else
echo invalid choice
TroubleShoot
fi
fi
fi
fi
fi
fi
fi
}

## END TROUBLESHOOT
#----------------------------------#
#          FORGE FUNCTION          #
#----------------------------------#
function Forge {
file="forge-1.11-13.19.0.2168-installer.jar"
cd /home/"$(whoami)"/Downloads
echo "Checking for forge installer"
 if [ -e /home/"$(whoami)"/Downloads/$file ]
 then
   echo "Launching forge installer"
   chmod 755 "$file"
   java -jar ./$file &> /dev/null
 else
   echo "You dont have forge"
   echo -ne "Downloading forge:"
   download "http://files.minecraftforge.net/maven/net/minecraftforge/forge/1.11-13.19.0.2168/$file"
   chmod 755 "$file"
   java -jar ./$file &> /dev/null
fi
rm -rf forge-*-installer.*
}

#----------------------------------#
#          MAIN FUNCTION           #
#----------------------------------#
function Main {
echo ""
echo "------------------------------------------------------"
echo "What would you like to do? (enter number of choice) "; echo "";
INPUT=0
while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ]
do
echo "1. Install Minecraft"
echo "2. Uninstall Minecraft"
echo "3. Server Management"
echo "4. Proxy Management"
echo "5. Install Forge"
echo "6. TroubleShooting"
echo "7. Exit"
if [ -e /usr/local/bin/minecraft ] && [ -e /home/"$(whoami)"/.minecraft/Minecraft.jar ]
then
echo "8.  Minecraft & Exit"
fi
read INPUT
if [ "$INPUT" -eq 1 ]
then
	Install
	Main
	return
else
if [ "$INPUT" -eq 2 ]
then
	Uninstall
	Main
	return
else
if [ "$INPUT" -eq 3 ]
then
    echo ""
    echo "------------------------------------------------------"
    echo "What would you like to do? (enter number of choice) "; echo "";
    INPUT=0
    while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ]
    do
    echo "1. Install Minecraft Server"
    echo "2. Uninstall Minecraft Server"
    echo "3. Install PaperSpigot"
    echo "4. Uninstall PaperSpigot"
    read INPUT
    if [ "$INPUT" -eq 1 ]
    then
	    ServerInstall
	    Main
	    return
    else
    if [ "$INPUT" -eq 2 ]
    then
	    ServerUninstall
	    Main
      return
    else
    if [ "$INPUT" -eq 3 ]
    then
      PaperInstall
      Main
      return
    else
    if [ "$INPUT" -eq 4 ]
    then
      PaperUninstall
      Main
      return
fi
fi
fi
fi
done
else
  if [ "$INPUT" -eq 4 ]
  then
      echo ""
      echo "------------------------------------------------------"
      echo "What would you like to do? (enter number of choice) "; echo "";
      INPUT=0
      while [ $INPUT != 1 ] && [ $INPUT != 2 ] && [ $INPUT != 3 ]
      do
      echo "1. Install Waterfall Proxy"
      echo "2. Uninstall Waterfall Proxy"
      echo "3. Install BungeeCord Proxy(wip)"
      echo "4. Uninstall BungeeCord Proxy"
      read INPUT
      if [ "$INPUT" -eq 1 ]
      then
  	    WaterfallInstall
  	    Main
  	    return
      else
      if [ "$INPUT" -eq 2 ]
      then
  	    WaterfallUninstall
  	    Main
        return
      else
      if [ "$INPUT" -eq 3 ]
      then
        BungeeCordInstall
        Main
        return
      else
      if [ "$INPUT" -eq 4 ]
      then
        BungeeCordUninstall
        Main
        return
  fi
  fi
  fi
  fi
  done
  else
if [ "$INPUT" -eq 5 ]
then
  Forge
  Main
  return
else
if [ "$INPUT" -eq 6 ]
then
	TroubleShoot
	Main
	return
else
if [ "$INPUT" -eq 7 ]
then
	exit
else
if [ "$INPUT" -eq 8 ] && [ -e /home/"$(whoami)"/.minecraft/Minecraft.jar ]
then
  (nohup minecraft &> /dev/null &)
  exit
else

	echo "invalid choice"
	Main
fi
fi
fi
fi
fi
fi
fi
fi

done
}

#----------------------------------#
#     PAPER INSTALL FUNCTION       #
#----------------------------------#
function PaperInstall {
echo -ne "Looking for Server File"
dots
if [ -e /home/"$(whoami)"/Paper_Server/bin/paperclip.jar ]
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
mkdir /home/"$(whoami)"/Paper_Server
cd /home/"$(whoami)"/Paper_Server
echo -ne "    Accepting eula!!!"
echo "eula=true" >> eula.txt
mkdir bin
cd bin
echo ""

file="paperclip.jar"
echo -n "Downloading $file:"
download "https://ci.destroystokyo.com/job/PaperSpigot/lastSuccessfulBuild/artifact/$file"
dots

file="spigot.png"
echo -n "Downloading server-icon.png:"
download "https://static.spigotmc.org/img/$file"
mv spigot.png server_icon.png
dots

echo ""
echo -ne "Writing Shell Launcher"
dots
if [ -e paper_server ]
then
    rm paper_server
fi
if [ -e papermc ]
then
    rm papermc
fi
touch papermc
 echo "cd /home/$(whoami)/Paper_Server" >> papermc
 echo "pwd" >> papermc
 echo "java -Xmx2G -Xms1G -jar bin/paperclip.jar" >> papermc
echo -ne  "Copying to bin folder"
dots
echo "This may require root access:"
sudo cp papermc /usr/local/bin
sudo chmod +x /usr/local/bin/papermc
echo "done"
echo ""

echo -ne "Creating launchers"
dots

mkdir install_files
cd install_files

if [ -e paper-server_installer.desktop ] || [ -e minecraft-menu.directory ]
then
    rm paper-server_installer.desktop
    rm minecraft-menu.directory
fi
touch paper-server_installer.desktop
  echo "[Desktop Entry]" >> paper-server_installer.desktop
  echo "Type=Application" >> paper-server_installer.desktop
  echo "Encoding=UTF-8" >> paper-server_installer.desktop
  echo "Name=PaperSpigot" >> paper-server_installer.desktop
  echo "Comment=Server GUI" >> paper-server_installer.desktop
  echo "Exec=papermc" >> paper-server_installer.desktop
  echo "Icon=/home/$(whoami)/Paper_Server/bin/server_icon.png" >> paper-server_installer.desktop
  echo "Categories=Game" >> paper-server_installer.desktop
  echo "Terminal=true" >> paper-server_installer.desktop
#----------------------------------------------------
echo -ne "Granting the shortcut excecution permissions"
dots
echo this requires root access
cp paper-server_installer.desktop /home/"$(whoami)"/Desktop
sudo chmod +x /home/"$(whoami)"/Desktop/paper-server_installer.desktop
echo "done"
echo ""

echo -ne "Writing menu item"
dots
touch minecraft-menu.directory
  echo "[Desktop Entry]"
  echo "Value=1.0" >> minecraft-menu.directory
  echo "Type=Directory" >> minecraft-menu.directory
  echo "Encoding=UTF-8" >> minecraft-menu.directory
echo -ne "Installing server launchers"
dots
xdg-desktop-menu install minecraft-menu.directory paper-server_installer.desktop
xdg-desktop-menu forceupdate
echo "done"
echo ""
echo  -e "The PaperSpigot server has been installed! \nrun it from the launchers, or by typing 'papermc' into terminal.\n Credits to spigotmc.org for the server icon"


## END SERVER INSTALL
}

#----------------------------------#
#    PAPER UNINSTALL FUNCTION      #
#----------------------------------#
function PaperUninstall {
if [ ! -d /home/"$(whoami)"/Paper_Server ]
then
    echo Server is not installed!
    return
fi
cd /home/"$(whoami)"/Paper_Server/bin/install_files
echo -ne "Removing Launchers"
dots
xdg-desktop-menu uninstall minecraft-menu.directory paper-server_installer.desktop
echo "done"
echo ""
echo -ne "Removing Desktop Icon"
dots
cd /home/"$(whoami)"/Desktop
if [ -e paper-server_installer.desktop ]
then
    rm paper-server_installer.desktop
    echo "done"
else
    echo "Does not exist"
fi
echo ""
echo -ne "Removing Server"
dots
if [ -d /home/"$(whoami)"/Paper_Server/bin ]
then
    cd /home/"$(whoami)"/Paper_Server
    rm -rf bin
    echo "done"
fi
echo ""
echo -ne "Removing launch script"
dots
echo "this requires root access"
sudo rm /usr/local/bin/papermc
echo "done"

echo "Uninstall Successful"
}

#----------------------------------#
#     WATERFALL INSTALL FUNCTION   #
#----------------------------------#
function WaterfallInstall {
echo -ne "Looking for Proxy File"
dots
if [ -e /home/"$(whoami)"/Waterfall_Proxy/bin/Waterfall.jar ]
then
	echo -ne "Proxy Files already installed!"
	dots
	Main
else
echo "not found!"
fi
echo ""
echo -ne "Creating Proxy Directory"
dots
mkdir /home/"$(whoami)"/Waterfall_Proxy
cd /home/"$(whoami)"/Waterfall_Proxy
mkdir bin
cd bin
echo ""

file="Waterfall.jar"
echo -n "Downloading $file:"
download "https://ci.destroystokyo.com/job/Waterfall/lastSuccessfulBuild/artifact/Waterfall-Proxy/bootstrap/target/$file"
dots

file="icon.png"
echo -n "Downloading server-icon.png:"
download "https://aquifermc.org/styles/aquifer/images/$file"
mv icon.png server_icon.png
dots

echo ""
echo -ne "Writing Shell Launcher"
dots
if [ -e wfproxy ]
then
    rm wfproxy
fi
touch wfproxy
  echo "cd /home/$(whoami)/Waterfall_Proxy" >> wfproxy
  echo "pwd" >> wfproxy
  echo "java -Xmx1G -Xms512M -jar bin/Waterfall.jar" >> wfproxy
echo -ne  "Copying to bin folder"
dots
echo "This may require root access:"
sudo cp wfproxy /usr/local/bin
sudo chmod +x /usr/local/bin/wfproxy
echo "done"
echo ""

echo -ne "Creating launchers"
dots

mkdir install_files
cd install_files

if [ -e waterfall-proxy_installer.desktop ] || [ -e minecraft-menu.directory ]
then
    rm waterfall-proxy_installer.desktop
    rm minecraft-menu.directory
fi
touch waterfall-proxy_installer.desktop
  echo "[Desktop Entry]" >> waterfall-proxy_installer.desktop
  echo "Type=Application" >> waterfall-proxy_installer.desktop
  echo "Encoding=UTF-8" >> waterfall-proxy_installer.desktop
  echo "Name=Waterfall" >> waterfall-proxy_installer.desktop
  echo "Comment=Proxy GUI" >> waterfall-proxy_installer.desktop
  echo "Exec=wfproxy" >> waterfall-proxy_installer.desktop
  echo "Icon=/home/$(whoami)/Waterfall_Proxy/bin/server_icon.png" >> waterfall-proxy_installer.desktop
  echo "Categories=Game" >> waterfall-proxy_installer.desktop
  echo "Terminal=true" >> waterfall-proxy_installer.desktop
#----------------------------------------------------
echo -ne "Granting the shortcut excecution permissions"
dots
echo this requires root access
cp waterfall-proxy_installer.desktop /home/"$(whoami)"/Desktop
sudo chmod +x /home/"$(whoami)"/Desktop/waterfall-proxy_installer.desktop
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
xdg-desktop-menu install minecraft-menu.directory waterfall-proxy_installer.desktop
xdg-desktop-menu forceupdate
echo "done"
echo ""
echo  -e "The Waterfall Proxy has been installed! \nrun it from the launchers, or by typing 'wfproxy' into terminal.\n Credits to aquifermc.org for the server icon"


## END SERVER INSTALL
}

#----------------------------------#
#   WATERFALL UNINSTALL FUNCTION   #
#----------------------------------#
function WaterfallUninstall {
if [ ! -d /home/"$(whoami)"/Waterfall_Proxy ]
then
    echo "Proxy is not installed!"
    return
fi
cd /home/"$(whoami)"/Waterfall_Proxy/bin/install_files
echo -ne "Removing Launchers"
dots
xdg-desktop-menu uninstall minecraft-menu.directory waterfall-proxy_installer.desktop
echo "done"
echo ""
echo -ne "Removing Desktop Icon"
dots
cd /home/"$(whoami)"/Desktop
if [ -e waterfall-proxy_installer.desktop ]
then
    rm waterfall-proxy_installer.desktop
    echo "done"
else
    echo "Does not exist"
fi
echo ""
echo -ne "Removing Proxy"
dots
if [ -d /home/"$(whoami)"/Waterfall_Proxy/bin ]
then
    cd /home/"$(whoami)"/Waterfall_Proxy
    rm -rf bin
    echo "done"
fi
echo ""
echo -ne "Removing launch script"
dots
echo "this requires root access"
sudo rm /usr/local/bin/wfproxy
echo "done"

echo "Uninstall Successful"
}

#----------------------------------#
#   BUNGEECORD INSTALL FUNCTION    #
#----------------------------------#
function BungeeCordInstall {
echo -ne "Looking for Proxy File"
dots
if [ -e /home/$(whoami)/BungeeCord_Proxy/bin/BungeeCord.jar ]
then
	echo -ne "Proxy Files already installed!"
	dots
	Main
else
echo "not found!"
fi
echo ""
echo -ne "Creating Proxy Directory"
dots
mkdir /home/$(whoami)/BungeeCord_Proxy
cd /home/$(whoami)/BungeeCord_Proxy
mkdir bin
cd bin
echo ""

file="BungeeCord.jar"
echo -n "Downloading $file:"
download "http://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/$file"

file="spigot.png"
echo -n "Downloading server-icon.png:"
download "https://static.spigotmc.org/img/$file"
mv spigot.png server_icon.png

echo ""
echo -ne "Writing Shell Launcher"
dots
if [ -e bcproxy ]
then
    rm bcproxy
fi
touch bcproxy
  echo "cd /home/$(whoami)/BungeeCord_Proxy" >> bcproxy
  echo "pwd" >> bcproxy
  echo "java -Xmx1G -Xms512M -jar bin/BungeeCord.jar" >> bcproxy
echo -ne  "Copying to bin folder"
dots
echo "This may require root access:"
sudo cp bcproxy /usr/local/bin
sudo chmod +x /usr/local/bin/bcproxy
echo "done"
echo ""

echo -ne "Creating launchers"
dots

mkdir install_files
cd install_files

if [ -e bungeecord-proxy_installer.desktop ] || [ -e minecraft-menu.directory ]
then
    rm bungeecord-proxy_installer.desktop
    rm minecraft-menu.directory
fi
touch bungeecord-proxy_installer.desktop
  echo "[Desktop Entry]" >> bungeecord-proxy_installer.desktop
  echo "Type=Application" >> bungeecord-proxy_installer.desktop
  echo "Encoding=UTF-8" >> bungeecord-proxy_installer.desktop
  echo "Name=BungeeCord" >> bungeecord-proxy_installer.desktop
  echo "Comment=Proxy GUI" >> bungeecord-proxy_installer.desktop
  echo "Exec=bcproxy" >> bungeecord-proxy_installer.desktop
  echo "Icon=/home/$(whoami)/BungeeCord_Proxy/bin/server_icon.png" >> bungeecord-proxy_installer.desktop
  echo "Categories=Game" >> bungeecord-proxy_installer.desktop
  echo "Terminal=true" >> bungeecord-proxy_installer.desktop
#----------------------------------------------------
echo -ne "Granting the shortcut excecution permissions"
dots
echo this requires root access
cp bungeecord-proxy_installer.desktop /home/"$(whoami)"/Desktop
sudo chmod +x /home/$(whoami)/Desktop/bungeecord-proxy_installer.desktop
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
xdg-desktop-menu install minecraft-menu.directory bungeecord-proxy_installer.desktop
xdg-desktop-menu forceupdate
echo "done"
echo ""
echo  -e "The BungeeCord Proxy has been installed! \nrun it from the launchers, or by typing 'bcproxy' into terminal.\n Credits to spigotmc.org for the server icon"


## END PROXY INSTALL
}

#----------------------------------#
#  BUNGEECORD UNINSTALL FUNCTION   #
#----------------------------------#
function BungeeCordUninstall {
if [ ! -d /home/$(whoami)/BungeeCord_Proxy ]
then
    echo "Proxy is not installed!"
    return
fi
cd /home/$(whoami)/BungeeCord_Proxy/bin/install_files
echo -ne "Removing Launchers"
dots
xdg-desktop-menu uninstall minecraft-menu.directory bungeecord-proxy_installer.desktop
echo "done"
echo ""
echo -ne "Removing Desktop Icon"
dots
cd /home/$(whoami)/Desktop
if [ -e bungeecord-proxy_installer.desktop ]
then
    rm bungeecord-proxy_installer.desktop
    echo "done"
else
    echo "Does not exist"
fi
echo ""
echo -ne "Removing Proxy"
dots
if [ -d /home/$(whoami)/BungeeCord_Proxy/bin ]
then
    cd /home/$(whoami)/BungeeCord_Proxy
    rm -rf bin
    echo "done"
fi
echo ""
echo -ne "Removing launch script"
dots
echo "this requires root access"
sudo rm /usr/local/bin/bcproxy
echo "done"

echo "Uninstall Successful"
}

#----------------------------------#
#      CALL THE MAIN FUNCTION      #
#----------------------------------#

Main

#THE END
