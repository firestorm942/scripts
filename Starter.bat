@echo off
IF EXIST "paperclip.jar" (
:begin
RAM=1G
MAXRAM=2G
echo Auto Restart Script Initialized
java -Xms1G -Xmx2G -jar paperclip.jar
PAUSE
goto begin
) ELSE (
powershell -Command "Invoke-WebRequest https://ci.destroystokyo.com/job/PaperSpigot/lastSuccessfulBuild/artifact/paperclip.jar -OutFile paperclip.jar"
echo Auto Restart Script Initialized
java -Xms$RAM -Xmx$MAXRAM -jar paperclip.jar
PAUSE
goto begin
)
