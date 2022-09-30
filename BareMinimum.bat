@echo off
REM "Bare Min"


REM "Turn cameras on"
"C:\Program Files\nodejs\node.exe" ./ptz_cameras.js --main --alt --preset "on"
timeout 10

REM "Point Cameras"
"C:\Program Files\nodejs\node.exe" ./ptz_cameras.js --main --preset "worship_center_pnp"
"C:\Program Files\nodejs\node.exe" ./ptz_cameras.js --alt --preset "wide"

REM "PNP"
curl -l 127.0.0.1:8888/press/bank/1/11

REM "Switch to Camera 5"
curl -l 127.0.0.1:8888/press/bank/1/3
REM "Toggle A"
curl -l 127.0.0.1:8888/press/bank/1/30
REM "Auto"
curl -l 127.0.0.1:8888/press/bank/1/2

REM "Switch to Camera 6"
curl -l 127.0.0.1:8888/press/bank/1/4
REM "Toggle B"
curl -l 127.0.0.1:8888/press/bank/1/31
REM "Auto"


REM "AHK stuff"

