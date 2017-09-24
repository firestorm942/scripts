#!/bin/bash
while true
do
# Insert your invocation below
java -Xms2G -Xmx4G -jar paperclip.jar
read -t5 -p "<restart?>:" CONDITION;
if [ "$CONDITION" == "y" ]; then
    echo restarting
    sleep 3
else
    exit
fi

done
