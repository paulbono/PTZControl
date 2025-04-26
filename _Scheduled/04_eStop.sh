#!/bin/bash
# 23Center_Full.sh

echo "Stop Stream"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Stop Stream]"}' http://127.0.0.1:3000/slide

