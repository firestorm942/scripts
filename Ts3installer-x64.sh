#!/usr/bin/env bash
#ts3client Installer:

# feel free to change, update, improve, and release this script

# breaking the "one big rule"


# latest update 3/24/2018
CLIVER=3.1.8

echo ""
echo "@-------------------------------------------@"
echo "@  firestorm942s Ts3 Client Installer       @"
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
while [ ${counter} -le 3 ]
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
#          MAIN FUNCTION           #
#----------------------------------#
function Main {
echo ""
echo "------------------------------------------------------"
echo "What would you like to do? (enter number of choice) "; echo "";
INPUT=0
while [ ${INPUT} != 1 ] && [ ${INPUT} != 2 ] && [ ${INPUT} != 3 ]
do
echo "1. Install TeamSpeak"
echo "2. Uninstall TeamSpeak"
echo "3. TeamSpeak Server Management"
echo "4. Exit"
if [ -e /usr/local/bin/ts3client ] && [ -e /home/"$(whoami)"/.ts3client/ts3client_runscript.sh ]
then
echo "5.  TeamSpeak & Exit"
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
    while [ ${INPUT} != 1 ] && [ ${INPUT} != 2 ] && [ ${INPUT} != 3 ]
    do
    echo "1. Install TeamSpeak Server"
    echo "2. Uninstall TeamSpeak Server"
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
fi
fi
done
else
if [ "$INPUT" -eq 4 ]
then
	exit
else
if [ "$INPUT" -eq 5 ] && [ -e /home/"$(whoami)"/.ts3client/ts3client_runscript.sh ]
then
  (nohup ts3client &> /dev/null &)
  exit
else

	echo "invalid choice"
	Main
fi
fi
fi
fi
fi

done
}

#----------------------------------#
#         INSTALL FUNCTION         #
#----------------------------------#
# This is the main install function, here all the files are downloaded/created and installed
function Install {
# the first thing it does is check to see if the .ts3client folder already exists
# if so, then we don't need to create a new one, if not, we do.
if [ -e /home/"$(whoami)"/.ts3client ]
then
	echo  ".ts3client folder exists"
	if [ -e /home/"$(whoami)"/.ts3client/ts3client_runscript.sh ]
	then
		echo  -ne "have you run this before?"
		dots

	fi
	echo ""
fi

#--------------------------------------------
cd /home/"$(whoami)"
#--------------------------------------------
# the .jar file is simply downloaded to the .ts3client folder from ts3client.net
# it first checks to see if the user already has it, if so, it won't be downloaded
echo -ne downloading TeamSpeak3 Client
dots
if [ -e /home/"$(whoami)"/.ts3client/ts3client_runscript.sh ]
then
echo "looks like you already downloaded it!"
else
file="TeamSpeak3-Client-linux_amd64-$CLIVER.run"
echo -n "Downloading $file:"
download "http://dl.4players.de/ts/releases/$CLIVER/$file"
chmod +x ${file}
./${file}
rm -rf ${file}
mv ~/TeamSpeak3-Client-linux_amd64 ~/.ts3client
fi
cd /home/"$(whoami)"/.ts3client
echo""
echo -ne "downloading icon"
dots
if [ -e /home/"$(whoami)"/.ts3client/icon.png ]
then
echo "you already have the icon!"
else
file="TeamSpeak-icon.png"
echo -n "Downloading $file:"
download "http://icons.iconarchive.com/icons/dakirby309/simply-styled/64/$file"
mv TeamSpeak-icon.png icon.png
echo saved to /home/"$(whoami)"/.ts3client
fi
echo ""
#---------------------------------------------
echo -ne "writing bin shell"
# this writes a seperate shell script in the /usr/local/bin folder, this is what allows the user
# to run ts3client from terminal, just by typing ts3client.
dots
if [ ! -e /usr/local/bin/ts3client ]
then
touch ts3client
echo /home/"$(whoami)"/.ts3client/ts3client_runscript.sh >> ts3client
echo -ne saving to usr/local/bin
dots
echo this requires root access:
sudo cp ts3client /usr/local/bin/
sudo chmod +x /usr/local/bin/ts3client
echo "done"
else
echo excecutable already written
fi
echo ""
#--------------------------------------------
echo -ne writing desktop shortcut
dots
cd /home/"$(whoami)"/.ts3client/

touch ts3client-installer.desktop
echo "[Desktop Entry]" >> ts3client-installer.desktop
echo "Type=Application" >> ts3client-installer.desktop
echo "Encoding=UTF-8" >> ts3client-installer.desktop
echo "Name=TeamSpeak" >> ts3client-installer.desktop
echo "Comment=Ts3client Client" >> ts3client-installer.desktop
echo "Exec=/home/$(whoami)/.ts3client/ts3client_runscript.sh" >> ts3client-installer.desktop
echo "Icon=/home/$(whoami)/.ts3client/icon.png"  >> ts3client-installer.desktop
echo "Categories=Games" >> ts3client-installer.desktop
echo "Terminal=false" >> ts3client-installer.desktop
#----------------------------------------------------
echo -ne granting the shortcut excecution permissions
dots
echo this requires root access

echo -ne installing to Desktop
dots
cp ts3client-installer.desktop /home/"$(whoami)"/Desktop
sudo chmod +x /home/"$(whoami)"/Desktop/ts3client-installer.desktop
echo "done"
echo ""

echo installed
#--------------------------------------------
echo ""
echo "SUCCESS!"
echo ""
echo -e "ts3client has been successfully Downloaded and Installed \nCheck your desktop and Applications menu for launchers! \nYou can also run it from terminal with a 'ts3client' command! \ncontact: Speed9425@gmail.com"

echo""

}
## END INSTALL
#----------------------------------#
#       UNINSTALL FUNCTION         #
#----------------------------------#
function Uninstall {
echo -ne "Looking for TeamSpeak3"
dots
if [ ! -e /home/"$(whoami)"/.ts3client/ts3client_runscript.sh ]
then
	echo -ne "  -folder not detected"
	dots
	if [ ! -e /usr/local/bin/ts3client ]
	then
	echo -ne "  -bin launcher not detected"
	dots
	echo""
	echo "TeamSpeak3 doesn't seem to be installed!"
	Main
	return
	fi
fi
echo "TeamSpeak3 found!"
echo -ne "Uninstalling TeamSpeak3"
dots
echo "NOTE: You're save files will be kept"
cd /home/"$(whoami)"/.ts3client
echo ""
echo -ne "Deleting files and folders"
dots
rm ts3client
rm icon.png
echo "Removing Application Launcher"

xdg-desktop-menu uninstall ts3client-installer.desktop
echo "Removing Desktop Shortcut"
rm /home/"$(whoami)"/Desktop/ts3client-installer.desktop
echo ""
echo -ne "Removing Binary Launcher"
dots
echo "this requires root access:"
sudo rm /usr/local/bin/ts3client
echo ""
echo "TeamSpeak3 has been uninstalled :("

}
## END UNINSTALL
Main
