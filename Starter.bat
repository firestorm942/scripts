@echo off
IF EXIST "paperclip.jar" (
:begin
echo Auto Restart Script Initialized
java -Xms1G -Xmx2G -jar paperclip.jar
PAUSE
goto begin
) ELSE (
powershell -Command "Invoke-WebRequest https://ci.destroystokyo.com/job/PaperSpigot/lastSuccessfulBuild/artifact/paperclip.jar -OutFile paperclip.jar"
echo Auto Restart Script Initialized
java -Xms1G -Xmx2G -jar paperclip.jar
PAUSE
goto begin
)
