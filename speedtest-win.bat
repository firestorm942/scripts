@echo off
setlocal
cd C:\users\%USERNAME%\AppData\Roaming
powershell -Command "Invoke-WebRequest https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py -OutFile speedtest.py"
.\speedtest.py
del /f speedtest.py
endlocal
pause