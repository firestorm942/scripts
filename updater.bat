@echo off
set startdir=%~dp0
echo Auto update engaged
if not exist %~dp0\cache\update (
    echo making directories.
    mkdir %~dp0\cache
    mkdir %~dp0\tools
    mkdir %~dp0\cache\update
)
if exist %~dp0\cache\update\paperclip.jar.old (
    del /f %~dp0\cache\update\paperclip.jar.old
)
move %~dp0\paperclip.jar %~dp0\cache\update\
rename %~dp0\cache\update\paperclip.jar paperclip.jar.old
if not exist %~dp0\tools\wget.exe (
    echo downloading wget
    powershell -Command "Invoke-WebRequest https://eternallybored.org/misc/wget/current/wget64.exe -OutFile wget.exe"
    move wget.exe %~dp0\tools
)
echo Downloading PaperSpigot
.\tools\wget.exe -qc https://ci.destroystokyo.com/job/PaperSpigot/lastSuccessfulBuild/artifact/paperclip.jar -O paperclip.jar
echo Auto update complete
echo press any key to start
start Starter.bat
exit
