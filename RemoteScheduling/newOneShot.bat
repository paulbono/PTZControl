REM @echo off

setlocal EnableDelayedExpansion


set year=%1
set month=%2
set day=%3
set militaryhour=%4
set minute=%5


REM Example
REM Service Date Time:	5:00PM
REM 					04/02/2023
REM 
REM 02 Init				3:15PM
REM 03 Start Stream		4:59PM
REM 04 Teardown			6:15PM
REM 
REM 02 -1:45
REM 03 -0:01
REM 04 +1:15


REM Call it like this:
REM newOneShot.bat 2023 12 24 16 00

REM set streamDate = "%year%-%month%-%day%T%militaryhour%:%minute%:00"
set streamDate= "%year%-%month%-%day%T"
echo !streamDate!
REM 2023-04-08T15:15:00

REM 105 minutes before start
set timeone= "!streamDate!07:45:00"
REM 1 minute before start
set timetwo= "!streamDate!09:30:00"
REM 75 minutes after start
set timethree= "!streamDate!10:45:00"
REM set timethree= "2023-12-25T00:15:00"

echo !timeone!
echo !timetwo!
echo !timethree!


powershell -Command "(gc -Path \"02 Init.template.xml\") -replace '\[StartBoundary\]', '!timeone!' | Out-File \"02 Init.xml\""
powershell -Command "(gc -Path \"03 Start Stream.template.xml\") -replace '\[StartBoundary\]', '!timetwo!' | Out-File \"03 Start Stream.xml\""
powershell -Command "(gc -Path \"04 Teardown.template.xml\") -replace '\[StartBoundary\]', '!timethree!' | Out-File  \"04 Teardown.xml\""


schtasks /CREATE /TN "%year%-%month%-%day%\02 Init" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\02 Init.xml"
schtasks /CREATE /TN "%year%-%month%-%day%\03 Start Stream" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\03 Start Stream.xml"
schtasks /CREATE /TN "%year%-%month%-%day%\04 Teardown" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\04 Teardown.xml"

