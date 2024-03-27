REM @echo off

setlocal EnableDelayedExpansion

REM StartHere.bat

set year=%1
set month=%2
set day=%3
set militaryhour=%4
set minute=%5

set year=%1
set month=%2
set day=%3
set hour=%4
set minute=%5


REM Call it like this:
REM StartHere.bat 2024 03 28 16 00


:: Displaying test case information
echo Service Start: %year%-%month%-%day% %hour%:%minute%

:: Calling the main script (schedule.bat)
call schedule.bat %year% %month% %day% %hour% %minute%

:: Remove trailing space from each time variable
set "timeone=!timeone:~0,-1!"
set "timetwo=!timetwo:~0,-1!"
REM set "timethree=!timethree:~0,-1!" REM - fine on the last one????

:: Displaying the actual results
echo Event Timeline: %timeone% %timetwo% %timethree%

echo !timeone!
echo !timetwo!
echo !timethree!


powershell -Command "(gc -Path \"02 Init.template.xml\") -replace '\[StartBoundary\]', '!timeone!' | Out-File \"02 Init.xml\""
powershell -Command "(gc -Path \"03 Start Stream.template.xml\") -replace '\[StartBoundary\]', '!timetwo!' | Out-File \"03 Start Stream.xml\""
powershell -Command "(gc -Path \"04 Teardown.template.xml\") -replace '\[StartBoundary\]', '!timethree!' | Out-File  \"04 Teardown.xml\""


schtasks /CREATE /TN "%year%-%month%-%day%\02 Init" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\02 Init.xml"
schtasks /CREATE /TN "%year%-%month%-%day%\03 Start Stream" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\03 Start Stream.xml"
schtasks /CREATE /TN "%year%-%month%-%day%\04 Teardown" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\04 Teardown.xml"

