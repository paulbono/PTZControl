#!/bin/bash
# 21Thank_You_For_Worshiping.sh

echo "Thank You For Worshiping"
curl -i -X POST -H "Content-Type: application/json" -d '{"tag": "[Thank You For Worshiping]"}' http://127.0.0.1:3000/slide

