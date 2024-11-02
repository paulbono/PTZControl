#!/bin/bash

# Navigate to the PTZControl directory
cd /Users/av/git/PTZControl || echo "PTZControl directory not found."

# Run the ptz_cameras.js script with the required arguments
node ./ptz_cameras.js --main --alt --query_all
