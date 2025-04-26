#!/bin/bash

# Change to the PTZControl directory
cd ~/Desktop/PTZControl

# Execute the ptz_cameras.js script with Node.js and the necessary arguments
/usr/local/bin/node ./ptz_cameras.js --main --off
/usr/local/bin/node ./ptz_cameras.js --alt --off

