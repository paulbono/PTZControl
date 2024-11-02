#!/bin/bash

# Navigate to the PTZControl directory
cd /Users/av/git/PTZControl || echo "PTZControl directory not found."

# Run the ptz_cameras.py script with the specified arguments
python3 ./ptz_cameras.py --main --preset "worship_center"

# Trigger the button 1/4 command via curl
curl http://127.0.0.1:8888/press/bank/1/4
