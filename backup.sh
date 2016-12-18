#!/bin/bash
# Set these values to match your server's settings.

# This script should be located in the craftbukkit folder

# Make sure you change this to the name of your world folder! 
# Add additional worlds by separating them with a space. 

declare -a worlds=(world world_nether)
backupdir=backups/
ext=.zip

hdateformat=$(date '+%Y-%m-%d-%H-%M-%S')H$ext
ddateformat=$(date '+%Y-%m-%d')D$ext
numworlds=${#worlds[@]}

    echo "Starting multiworld backup..."
 
    if [ -d $backupdir ] ; then
        sleep 0
    else
        mkdir -p $backupdir
    fi
    zip $backupdir$hdateformat -r plugins
    for ((i=0;i<$numworlds;i++)); do
        zip -q $backupdir$hdateformat -r ${worlds[$i]}
        echo "Saving '${worlds[$i]}' to '$backupdir$hdateformat'."
    done
    cp $backupdir$hdateformat $backupdir$ddateformat
    echo "Updated daily backup."
    find $backupdir/ -name *H$ext -mmin +1440 -exec rm {} \;
    find $backupdir/ -name *D$ext -mtime +14 -exec rm {} \;
    echo "Removed old backups." 
 
    echo "Backup complete."

exit 0