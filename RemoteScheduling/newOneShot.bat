@echo off

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


REM set initHour=
REM set initMinute=
REM set streamHour=
REM set steamMinute=
REM set teardownHour=
REM set teardwonMinute=


set streamDate = "%year%-%month%-%day%T%militaryhour%:%minute%:00"

REM 2023-04-08T15:15:00
REM [templatehour]-[templatemonth]-[templateday]T[templatehour]:[templateminute]
powershell -Command "(gc \"02 Init.template.xml\") -replace '[StartBoundary]', 'bar' | Out-File -encoding ASCII \"02 Init.xml\""
powershell -Command "(gc \"03 Start Stream.template.xml\") -replace '[templatehour]', 'bar' | Out-File -encoding ASCII \"02 Init.xml\""
powershell -Command "(gc \"04 Teardown.template.xml\") -replace '[templatehour]', 'bar' | Out-File -encoding ASCII \"02 Init.xml\""


schtasks /CREATE /TN "%year%-%month%-%day%\02 Init" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\02 Init.xml"
schtasks /CREATE /TN "%year%-%month%-%day%\03 Start Stream" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\03 Start Stream.xml"
schtasks /CREATE /TN "%year%-%month%-%day%\04 Teardown" /XML "C:\Users\User\Desktop\PTZControl\RemoteScheduling\04 Teardown.xml"

REM schtasks /change /tn "04 08 2023\02 Init" /sc once /sd 04/05/2023 /st 16:15

REM schtasks /delete /TN "04 08 2023\One"
REM schtasks /create /TN "04 08 2023 One" /V1 /tr "\"C:\Users\User\Desktop\" \"C:\Users\User\Desktop\Init.bat\"" /sc once /sd 04/05/2023 /st 16:15

REM schtasks /change /tn "04 08 2023\One" /tr "C:\Users\User\Desktop\Init.bat" /trd "C:\Users\User\Desktop"










REM REM OLD
REM SCHTASKS /CREATE /SC DAILY /TN "OneShots\04 08 2023\One" /TR "C:\SOURCE\FOLDER\APP-OR-SCRIPT" /ST HH:MMExampleSCHTASKS /CREATE /SC DAILY /TN "MyTasks\Notepad task" /TR "C:\Windows\System32\notepad.exe" /ST 11:00

