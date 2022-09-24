@echo off

REM turn off cameras
start "I'm Running..." "C:\Users\User\Desktop\Stream_Stop.ahk"
start "I'm Running..." "C:\Users\User\Desktop\PTZControl\WrapperScript\Off.bat"
timeout 5

REM Kill apps we started
taskkill/im Livestream Studio.exe
taskkill/im Companion.exe
taskkill/im chrome.exe
echo logging off in 30 seconds
timeout 30

REM Logoff from computer
logoff