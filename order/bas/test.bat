@echo off

echo Starting in 15 seconds
pushd PTZControl\SlideListener
start "I'm Running..." node index.js
popd